# 🇬HOOk
### **An experimental Liquidity Position Manager for Uniswap v4 that allows a user to mint GHO**

> The codebase is forked from https://github.com/saucepoint/bungi

---

This project aims to mint GHO from Bungi's Uniswap v4 LP manager. An implemntation was tried using directly hooks from uniswap v4 but unfortunately hooks don't allow anybody but the owner to modify positions, making it impossible to liquidate users hen their position collateral is inferior to their debt. This may change in the future depending on how uniswap v4 final implementation.




# Features

Until Uniswap Labs releases a canonical LP router (equivalent to v3's [NonfungiblePositionManager](https://github.com/Uniswap/v3-periphery/blob/main/contracts/NonfungiblePositionManager.sol)), there was a growing need for **an advanced LP router** with more features than the baseline [PoolModifyPositionTest](https://github.com/Uniswap/v4-core/blob/main/contracts/test/PoolModifyPositionTest.sol)


## 🇬HOOK liquidity position manager (LPM) supports:


- [x] Semi-fungible LP tokens ([ERC-6909](https://github.com/jtriley-eth/ERC-6909))

- [x] Gas efficient rebalancing. Completely (or partially) move assets from an existing position into a new range

- [x] Permissioned operators and managers. Delegate to a trusted party to manage your liquidity positions
    - **Allow a hook to modify and adjust your position(s)!**

- Mint GHO against your LP


---

# Usage

Deploy for tests

```solidity
// -- snip --
// (other imports)

import {Position, PositionId, PositionIdLibrary} from "bungi/src/types/PositionId.sol";
import {LiquidityPositionManager} from "bungi/src/LiquidityPositionManager.sol";

contract CounterTest is Test {
    using PositionIdLibrary for Position;
    LiquidityPositionManager lpm;

    function setUp() public {
        // -- snip --
        // (deploy v4 PoolManager)

        lpm = new LiquidityPositionManager(IPoolManager(address(manager)));
    }
}

```

Run tests with forge test  --fork-url https://eth-mainnet.g.alchemy.com/v2/CO_jeJ4sXVaNu6Uu6DL3kLzNPKmUp5bS 

Mint GHO (need enough liquidity first)
```solidity
function borrowGho(uint256 amount, address user) public returns (bool, uint256){
        //if amount is inferior to min amount, revert
        if(amount < minBorrowAmount){
            revert("Borrow amount to borrow is inferior to 1 GHO");
        }
        console2.log("Borrow amount requested %e", amount);    
        console2.log("User collateral value in USD %e", _getUserLiquidityPriceUSD(user).unwrap() / 10**18);
        console2.log("Max borrow amount %e", _getUserLiquidityPriceUSD(user).sub((UD60x18.wrap(userPosition[user].debt)).div(UD60x18.wrap(10**ERC20(GHO).decimals()))).mul(maxLTVUD60x18).unwrap());

        //get user position price in USD, then check if borrow amount + debt already owed (adjusted to GHO decimals) is inferior to maxLTV (80% = maxLTV/100)
        if(_getUserLiquidityPriceUSD(user).lte((UD60x18.wrap((amount+ userPosition[user].debt)).div(UD60x18.wrap(10**ERC20(GHO).decimals()))).div(maxLTVUD60x18))){ 
            revert("user LTV is superior to maximum LTV"); //TODO add proper error message
        }
        userPosition[user].debt =  userPosition[user].debt + amount;
        console2.log("user debt after borrow %e", userPosition[user].debt);
        IGhoToken(GHO).mint(user, amount);
    }
```

Repay GHO
```solidity
function repayGho(uint256 amount, address user) public returns (bool){
        //check if user has debt already
        if(userPosition[user].debt < amount){
            revert("user debt is inferior to amount to repay");
        }
        //check if user has enough GHO to repay, need to approve first then repay 
        bool isSuccess = ERC20(GHO).transferFrom(user, address(this), amount); //send GHO to this address then burning it
        if(!isSuccess){
            revert("transferFrom failed");
            return false;
        }else{
            IGhoToken(GHO).burn(amount);
            userPosition[user].debt = userPosition[user].debt - amount;
            return true;
        }
        
    }
```

Liquidate User (if Collateral < Debt), callable by anybody
```solidity
/// @notice Given an existing position, liquidate position by repaying debt with a flashloan, then withdrawing collateral
    ///     This function supports partially withdrawing tokens from an LP to open up a new position
    /// @param owner The owner of the position
    /// @param position The position to liquidate
    /// @param hookLiquidationData the arbitrary bytes to provide to hooks when the existing position is modified
    function liquidateUser(
        address owner,
        Position memory position,
        bytes calldata hookLiquidationData
    ) external returns (bool liquidationSuccess) {
        
        if(getUserCurrentLTV(owner) < maxLTVUD60x18){
            revert("User LTV is not at risk of liquidation");
        }

        uint8 liquidationPremium = 20; //20% of GHO debt to liquidator

        //get user Current Position and debt
        BorrowerPosition storage currentParams = userPosition[owner];

        //send GHO to this address then burning it
        bool isTransferSuccess = ERC20(GHO).transferFrom(msg.sender, address(this), currentParams.debt); 

        if(!isTransferSuccess){
            revert("GHO transferFrom failed");
        }

        //burn GHO debt
        IGhoToken(GHO).burn(currentParams.debt);

        //reset user debt to 0
        userPosition[owner].debt = 0; 

        //burn ERC6909 position tokens
        _burn(owner, currentParams.position.toTokenId(), uint256(currentParams.liquidity));


        //Set Position params to 0 to liquidate
        IPoolManager.ModifyPositionParams memory liquidationParams = IPoolManager.ModifyPositionParams({
            tickLower: currentParams.position.tickLower,
            tickUpper: currentParams.position.tickUpper,
            liquidityDelta: -int256(int128(currentParams.liquidity))
        });

       uint256 token0balance = ERC20(WETH).balanceOf(address(this));
       uint256 token1balance = ERC20(USDC).balanceOf(address(this));

        // interactions, second parameter is receiver of tokens.
        BalanceDelta delta = abi.decode(
            manager.lock(
                abi.encodeCall(
                    this.handleModifyPosition, abi.encode(CallbackData(msg.sender, address(this), poolKey, liquidationParams, hookLiquidationData))
                )
            ),
            (BalanceDelta)
        );

        //After the call, balances should be settled and we should receive positions tokens back here.
        token0balance = ERC20(WETH).balanceOf(address(this)) - token0balance; //get actual received token0 amount after withdrawing position
        token1balance = ERC20(USDC).balanceOf(address(this)) - token1balance; //get actual received token1 amount after withdrawing position

        console2.log("ETH balance after actual liquidation %e", token0balance);
        console2.log("USDC balance after actual liquidation %e", token1balance);
        
        IERC20(WETH).transferFrom(address(this), msg.sender, (token0balance*liquidationPremium)/100); //send 20% ETH to liquidator as liquidation premium
        IERC20(USDC).transferFrom(address(this), msg.sender, (token1balance*liquidationPremium)/100); //send 20% USDc to liquidator as liquidation premium

        IERC20(WETH).transferFrom(address(this),address(owner),(token0balance*(100-liquidationPremium)/100)); //send 80% ETH to original user 
        IERC20(USDC).transferFrom(address(this),address(owner),(token1balance*(100-liquidationPremium)/100)); //send 80% USDC to original user 

        return(userPosition[owner].debt == 0);
    }
```

Add Liquidity
```solidity
    // Mint 1e18 worth of liquidity on range [-600, 600]
    int24 tickLower = -600;
    int24 tickUpper = 600;
    uint256 liquidity = 1e18;
    
    lpm.modifyPosition(
        address(this),
        poolKey,
        IPoolManager.ModifyPositionParams({
            tickLower: tickLower,
            tickUpper: tickUpper,
            liquidityDelta: int256(liquidity)
        }),
        ZERO_BYTES
    );

    // recieved 1e18 LP tokens (6909)
    Position memory position = Position({poolKey: poolKey, tickLower: tickLower, tickUpper: tickUpper});
    assertEq(lpm.balanceOf(address(this), position.toTokenId()), liquidity);
```

Remove Liquidity
```solidity
    // assume liquidity has been provisioned
    int24 tickLower = -600;
    int24 tickUpper = 600;
    uint256 liquidity = 1e18;

    // remove all liquidity
    lpm.modifyPosition(
        address(this),
        poolKey,
        IPoolManager.ModifyPositionParams({
            tickLower: tickLower,
            tickUpper: tickUpper,
            liquidityDelta: -int256(liquidity)
        }),
        ZERO_BYTES
    );
```


Rebalance Liquidity
```solidity
    // lens-style contract to help with liquidity math
    LiquidityHelpers helper = new LiquidityHelpers(IPoolManager(address(manager)), lpm);

    // assume existing position has liquidity already provisioned
    Position memory position = Position({poolKey: poolKey, tickLower: tickLower, tickUpper: tickUpper});

    // removing all `liquidity`` from an existing position and moving it into a new range
    uint128 newLiquidity = helper.getNewLiquidity(position, -liquidity, newTickLower, newTickUpper);
    lpm.rebalancePosition(
        address(this),
        position,
        -liquidity, // fully unwind
        IPoolManager.ModifyPositionParams({
            tickLower: newTickLower,
            tickUpper: newTickUpper,
            liquidityDelta: int256(uint256(newLiquidity))
        }),
        ZERO_BYTES,
        ZERO_BYTES
    );
```



---

Additional resources:

[v4-periphery](https://github.com/uniswap/v4-periphery)

[v4-core](https://github.com/uniswap/v4-core)

