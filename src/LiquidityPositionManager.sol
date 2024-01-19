// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console2} from "forge-std/console2.sol";
import {BaseHook} from "v4-periphery/BaseHook.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {PoolKey} from "@uniswap/v4-core/contracts/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {BalanceDelta} from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";
import {ERC6909} from "ERC-6909/ERC6909.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {Position, PositionId, PositionIdLibrary} from "./types/PositionId.sol";
import {Position as PoolPosition} from "@uniswap/v4-core/contracts/libraries/Position.sol";
import {LiquidityAmounts} from "v4-periphery/libraries/LiquidityAmounts.sol";
import {TickMath} from "@uniswap/v4-core/contracts/libraries/TickMath.sol";
import {UD60x18} from "@prb-math/UD60x18.sol";
import {IterableMapping2} from "./utils/IterableMapping.sol";
import {EACAggregatorProxy} from "./interfaces/EACAggregatorProxy.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IGhoToken} from '@aave/gho/gho/interfaces/IGhoToken.sol';
import {SqrtPriceMath} from "@uniswap/v4-core/contracts/libraries/SqrtPriceMath.sol";
import {AUniswap} from "./utils/FlashLoanUtils/AUniswap.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";






contract LiquidityPositionManager is ERC6909, AUniswap{
    using CurrencyLibrary for Currency;
    using PositionIdLibrary for Position;
    using PoolIdLibrary for PoolKey;
    using IterableMapping2 for IterableMapping2.Map;

    IPoolManager public immutable manager;

    struct CallbackData {
        address sender;
        address owner;
        PoolKey key;
        IPoolManager.ModifyPositionParams params;
        bytes hookData;
    }

    struct BorrowerPosition{
        Position position;
        uint128 liquidity;
        uint256 debt;
    }

    constructor(IPoolManager _manager, address _owner, PoolKey memory _poolKey) Ownable(_owner){
        manager = _manager;
        poolKey = _poolKey;
    }

    uint8 maxLTV = 80; //80%

    UD60x18 maxLTVUD60x18 = UD60x18.wrap(maxLTV).div(UD60x18.wrap(100)); //80% as UD60x18
    uint256 minBorrowAmount = 1e18; //1 GHO

    bytes constant ZERO_BYTES = new bytes(0);


    EACAggregatorProxy public ETHPriceFeed = EACAggregatorProxy(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); //chainlink ETH price feed
    EACAggregatorProxy public USDCPriceFeed = EACAggregatorProxy(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6); //chainlink USDC price feed

    mapping(address => BorrowerPosition) public userPosition; //user position todo need to be private ?
    IterableMapping2.Map private users; //list of users
    PoolKey private poolKey; //current hook pool key


    /// @notice Given an existing position, readjust it to a new range, optionally using net-new tokens
    ///     This function supports partially withdrawing tokens from an LP to open up a new position
    /// @param owner The owner of the position
    /// @param position The position to rebalance
    /// @param existingLiquidityDelta How much liquidity to remove from the existing position
    /// @param params The new position parameters
    /// @param hookDataOnBurn the arbitrary bytes to provide to hooks when the existing position is modified
    /// @param hookDataOnMint the arbitrary bytes to provide to hooks when the new position is created
    function rebalancePosition(
        address owner,
        Position memory position,
        int256 existingLiquidityDelta,
        IPoolManager.ModifyPositionParams memory params,
        bytes calldata hookDataOnBurn,
        bytes calldata hookDataOnMint
    ) external returns (BalanceDelta delta) {
        if (!(msg.sender == owner || isOperator[owner][msg.sender])) revert InsufficientPermission();
        delta = abi.decode(
            manager.lock(
                abi.encodeCall(
                    this.handleRebalancePosition,
                    (msg.sender, owner, position, existingLiquidityDelta, params, hookDataOnBurn, hookDataOnMint)
                )
            ),
            (BalanceDelta)
        );

        // adjust 6909 balances
        _burn(owner, position.toTokenId(), uint256(-existingLiquidityDelta));
        uint256 newPositionTokenId =
            Position({poolKey: position.poolKey, tickLower: params.tickLower, tickUpper: params.tickUpper}).toTokenId();
        _mint(owner, newPositionTokenId, uint256(params.liquidityDelta));

        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            CurrencyLibrary.NATIVE.transfer(msg.sender, ethBalance);
        }
    }

    
    function handleRebalancePosition(
        address sender,
        address owner,
        Position memory position,
        int256 existingLiquidityDelta,
        IPoolManager.ModifyPositionParams memory params,
        bytes memory hookDataOnBurn,
        bytes memory hookDataOnMint
    ) external returns (BalanceDelta delta) {
        PoolKey memory key = position.poolKey;

        // unwind the old position
        BalanceDelta deltaBurn = manager.modifyPosition(
            key,
            IPoolManager.ModifyPositionParams({
                tickLower: position.tickLower,
                tickUpper: position.tickUpper,
                liquidityDelta: existingLiquidityDelta
            }),
            hookDataOnBurn
        );
        BalanceDelta deltaMint = manager.modifyPosition(key, params, hookDataOnMint);

        delta = deltaBurn + deltaMint;

        processBalanceDelta(sender, owner, key.currency0, key.currency1, delta);
    }

    function handleModifyPosition(bytes memory rawData) external returns (BalanceDelta delta) {
        CallbackData memory data = abi.decode(rawData, (CallbackData));

        delta = manager.modifyPosition(data.key, data.params, data.hookData);
        processBalanceDelta(data.sender, data.owner, data.key.currency0, data.key.currency1, delta);
    }

    function modifyPosition(
        address owner,
        PoolKey memory key,
        IPoolManager.ModifyPositionParams memory params,
        bytes calldata hookData
    ) external returns (BalanceDelta delta) {
        // checks & effects
        //if user don't exist yet, add him to the list
        if(users.get(owner) != true){
           users.set(owner, true);
        }


        uint256 tokenId = Position({poolKey: key, tickLower: params.tickLower, tickUpper: params.tickUpper}).toTokenId();
        console2.log("liquidity delta %e", params.liquidityDelta);
        if (params.liquidityDelta < 0) {
            // only the operator or owner can burn
            if (!(msg.sender == owner || isOperator[owner][msg.sender])){
                revert InsufficientPermission();
            } 

            uint256 liquidity = uint256(-params.liquidityDelta);
            console2.log("liquidity to withdraw %e", uint128(liquidity));
            console2.log("can user withdraw ? %s", _canUserWithdraw(owner, params.tickLower, params.tickUpper, uint128(liquidity)));
            if(!_canUserWithdraw(owner, params.tickLower, params.tickUpper, uint128(liquidity))){
                revert("Cannot Withdraw because LTV is inferior to min LTV"); //todo allow partial withdraw according to debt
            }
            
            //recreate new position with new liquidity
            userPosition[owner] = BorrowerPosition(Position({poolKey: key, tickLower: params.tickLower, tickUpper: params.tickUpper}), uint128(userPosition[owner].liquidity - liquidity), userPosition[owner].debt); //todo check if this is the right way to remove user position
            _burn(owner, tokenId, uint256(-params.liquidityDelta));
            

           
        } else {
            // allow anyone to mint to a destination address
            // TODO: guarantee that k is less than int256 max
            // TODO: proper book keeping to avoid double-counting
            uint256 liquidity = uint256(params.liquidityDelta);
            userPosition[owner] = BorrowerPosition(Position({poolKey: key, tickLower: params.tickLower, tickUpper: params.tickUpper}),uint128(liquidity), userPosition[owner].debt) ;
            _mint(owner, tokenId, uint256(params.liquidityDelta));
        }
        

        // interactions
        delta = abi.decode(
            manager.lock(
                abi.encodeCall(
                    this.handleModifyPosition, abi.encode(CallbackData(msg.sender, owner, key, params, hookData))
                )
            ),
            (BalanceDelta)
        );

        uint256 ethBalance = address(this).balance;
        console2.log("ETH balance before actual modify position %e", ethBalance);
        if (ethBalance > 0) {
            CurrencyLibrary.NATIVE.transfer(owner, ethBalance);
        }

        
    }

    function lockAcquired(bytes calldata data) external returns (bytes memory) {
        require(msg.sender == address(manager));

        (bool success, bytes memory returnData) = address(this).call(data);
        if (success) return returnData;
        if (returnData.length == 0) revert("LockFailure");
        // if the call failed, bubble up the reason
        /// @solidity memory-safe-assembly
        assembly {
            revert(add(returnData, 32), mload(returnData))
        }
    }

    

    function processBalanceDelta(
        address sender,
        address recipient,
        Currency currency0,
        Currency currency1,
        BalanceDelta delta
    ) internal {
        if (delta.amount0() > 0) {
            if (currency0.isNative()) {
                manager.settle{value: uint128(delta.amount0())}(currency0);
            } else {
                IERC20(Currency.unwrap(currency0)).transferFrom(sender, address(manager), uint128(delta.amount0()));
                manager.settle(currency0);
            }
        }
        if (delta.amount1() > 0) {
            if (currency1.isNative()) {
                manager.settle{value: uint128(delta.amount1())}(currency1);
            } else {
                IERC20(Currency.unwrap(currency1)).transferFrom(sender, address(manager), uint128(delta.amount1()));
                manager.settle(currency1);
            }
        }

        if (delta.amount0() < 0) {
            manager.take(currency0, recipient, uint128(-delta.amount0()));
        }
        if (delta.amount1() < 0) {
            manager.take(currency1, recipient, uint128(-delta.amount1()));
        }
    }

   

    
    // --- ERC-6909 --- //
    function _mint(address owner, uint256 tokenId, uint256 amount) internal {
        balanceOf[owner][tokenId] += amount;
        emit Transfer(msg.sender, address(this), owner, tokenId, amount);
    }

    function _burn(address owner, uint256 tokenId, uint256 amount) internal {
        balanceOf[owner][tokenId] -= amount;
        emit Transfer(msg.sender, owner, address(this), tokenId, amount);
    }

    //Helper function to return PoolKey
    function _getPoolKey() private view returns (PoolKey memory) {
        return poolKey;
    }

    
}
