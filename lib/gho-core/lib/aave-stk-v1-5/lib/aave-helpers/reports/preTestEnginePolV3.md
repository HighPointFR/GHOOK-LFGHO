# Report

## Reserve Configurations

| symbol | underlying | aToken | stableDebtToken | variableDebtToken | decimals | ltv | liquidationThreshold | liquidationBonus | liquidationProtocolFee | reserveFactor | usageAsCollateralEnabled | borrowingEnabled | stableBorrowRateEnabled | supplyCap | borrowCap | debtCeiling | eModeCategory | interestRateStrategy | isActive | isFrozen | isSiloed | isBorrowableInIsolation | isFlashloanable | aTokenImpl | stableDebtTokenImpl | variableDebtTokenImpl |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DAI | 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063 | 0x82E64f49Ed5EC1bC6e43DAD4FC8Af9bb3A2312EE | 0xd94112B5B62d53C9402e7A60289c6810dEF1dC9B | 0x8619d80FB0141ba7F184CbF22fd724116D9f7ffC | 18 | 7500 | 8000 | 10500 | 1000 | 1000 | true | true | true | 45000000 | 30000000 | 0 | 1 | 0xA9F3C3caE095527061e6d270DBE163693e6fda9D | true | false | false | true | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| LINK | 0x53E0bca35eC356BD5ddDFebbD1Fc0fD03FaBad39 | 0x191c10Aa4AF7C30e871E70C95dB0E4eb77237530 | 0x89D976629b7055ff1ca02b927BA3e020F22A44e4 | 0x953A573793604aF8d41F306FEb8274190dB4aE0e | 18 | 5000 | 6500 | 10750 | 1000 | 2000 | true | true | false | 297640 | 163702 | 0 | 0 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| USDC | 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174 | 0x625E7708f30cA75bfd92586e17077590C60eb4cD | 0x307ffe186F84a3bc2613D1eA417A5737D69A7007 | 0xFCCf3cAbbe80101232d343252614b6A3eE81C989 | 6 | 8250 | 8500 | 10400 | 1000 | 1000 | true | true | true | 150000000 | 100000000 | 0 | 1 | 0x41B66b4b6b4c9dab039d96528D1b88f7BAF8C5A4 | true | false | false | true | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| WBTC | 0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6 | 0x078f358208685046a11C85e8ad32895DED33A249 | 0x633b207Dd676331c413D4C013a6294B0FE47cD0e | 0x92b42c66840C7AD907b4BF74879FF3eF7c529473 | 8 | 7000 | 7500 | 10650 | 1000 | 2000 | true | true | false | 1548 | 851 | 0 | 0 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| WETH | 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619 | 0xe50fA9b3c56FfB159cB0FCA61F5c9D750e8128c8 | 0xD8Ad37849950903571df17049516a5CD4cbE55F6 | 0x0c84331e39d6658Cd6e6b9ba04736cC4c4734351 | 18 | 8000 | 8250 | 10500 | 1000 | 1000 | true | true | false | 26900 | 14795 | 0 | 0 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| USDT | 0xc2132D05D31c914a87C6611C10748AEb04B58e8F | 0x6ab707Aca953eDAeFBc4fD23bA73294241490620 | 0x70eFfc565DB6EEf7B927610155602d31b670e802 | 0xfb00AC187a8Eb5AFAE4eACE434F493Eb62672df7 | 6 | 7500 | 8000 | 10500 | 1000 | 1000 | true | true | true | 45000000 | 30000000 | 500000000 | 1 | 0x41B66b4b6b4c9dab039d96528D1b88f7BAF8C5A4 | true | false | false | true | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| AAVE | 0xD6DF932A45C0f255f85145f286eA0b292B21C90B | 0xf329e36C7bF6E5E86ce2150875a84Ce77f477375 | 0xfAeF6A702D15428E588d4C0614AEFb4348D83D48 | 0xE80761Ea617F66F96274eA5e8c37f03960ecC679 | 18 | 6000 | 7000 | 10750 | 1000 | 0 | true | false | false | 36820 | 0 | 0 | 0 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| WMATIC | 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270 | 0x6d80113e533a2C0fe82EaBD35f1875DcEA89Ea97 | 0xF15F26710c827DDe8ACBA678682F3Ce24f2Fb56E | 0x4a1c3aD6Ed28a636ee1751C69071f6be75DEb8B8 | 18 | 6500 | 7000 | 11000 | 1000 | 2000 | true | true | false | 47000000 | 39950000 | 0 | 2 | 0xFB0898dCFb69DF9E01DBE625A5988D6542e5BdC5 | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| CRV | 0x172370d5Cd63279eFa6d502DAB29171933a610AF | 0x513c7E3a9c69cA3e22550eF58AC1C0088e918FFf | 0x08Cb71192985E936C7Cd166A8b268035e400c3c3 | 0x77CA01483f379E58174739308945f044e1a764dc | 18 | 7500 | 8000 | 10500 | 1000 | 1000 | true | true | false | 937700 | 640437 | 0 | 0 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| SUSHI | 0x0b3F868E0BE5597D5DB7fEB59E1CADBb0fdDa50a | 0xc45A479877e1e9Dfe9FcD4056c699575a1045dAA | 0x78246294a4c6fBf614Ed73CcC9F8b875ca8eE841 | 0x34e2eD44EF7466D5f9E0b782B5c08b57475e7907 | 18 | 2000 | 4500 | 11000 | 1000 | 2000 | true | true | false | 299320 | 102484 | 0 | 0 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| GHST | 0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7 | 0x8Eb270e296023E9D92081fdF967dDd7878724424 | 0x3EF10DFf4928279c004308EbADc4Db8B7620d6fc | 0xCE186F6Cccb0c955445bb9d10C59caE488Fea559 | 18 | 2500 | 4500 | 11500 | 1000 | 2000 | true | true | false | 5876000 | 3234000 | 0 | 0 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| BAL | 0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3 | 0x8ffDf2DE812095b1D19CB146E4c004587C0A0692 | 0xa5e408678469d23efDB7694b1B0A85BB0669e8bd | 0xA8669021776Bc142DfcA87c21b4A52595bCbB40a | 18 | 2000 | 4500 | 11000 | 1000 | 2000 | true | true | false | 361000 | 256140 | 0 | 0 | 0x4b8D3277d49E114C8F2D6E0B2eD310e29226fe16 | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| DPI | 0x85955046DF4668e1DD369D2DE9f3AEB98DD2A369 | 0x724dc807b04555b71ed48a6896b6F41593b8C637 | 0xDC1fad70953Bb3918592b6fCc374fe05F5811B6a | 0xf611aEb5013fD2c0511c9CD55c7dc5C1140741A6 | 18 | 2000 | 4500 | 11000 | 1000 | 2000 | true | true | false | 1417 | 779 | 0 | 0 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| EURS | 0xE111178A87A3BFf0c8d18DECBa5798827539Ae99 | 0x38d693cE1dF5AaDF7bC62595A37D667aD57922e5 | 0x8a9FdE6925a839F6B1932d16B36aC026F8d3FbdB | 0x5D557B07776D12967914379C71a1310e917C7555 | 2 | 6500 | 7000 | 10750 | 1000 | 1000 | true | true | true | 4000000 | 947000 | 500000000 | 1 | 0x41B66b4b6b4c9dab039d96528D1b88f7BAF8C5A4 | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| jEUR | 0x4e3Decbb3645551B8A19f0eA1678079FCB33fB4c | 0x6533afac2E7BCCB20dca161449A13A32D391fb00 | 0x6B4b37618D85Db2a7b469983C888040F7F05Ea3D | 0x44705f578135cC5d703b4c9c122528C73Eb87145 | 18 | 0 | 0 | 0 | 1000 | 2000 | false | true | false | 0 | 0 | 0 | 1 | 0x41B66b4b6b4c9dab039d96528D1b88f7BAF8C5A4 | true | true | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| agEUR | 0xE0B52e49357Fd4DAf2c15e02058DCE6BC0057db4 | 0x8437d7C167dFB82ED4Cb79CD44B7a32A1dd95c77 | 0x40B4BAEcc69B882e8804f9286b12228C27F8c9BF | 0x3ca5FA07689F266e907439aFd1fBB59c44fe12f6 | 18 | 0 | 0 | 0 | 1000 | 2000 | false | true | false | 0 | 0 | 0 | 1 | 0x41B66b4b6b4c9dab039d96528D1b88f7BAF8C5A4 | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| miMATIC | 0xa3Fa99A148fA48D14Ed51d610c367C61876997F1 | 0xeBe517846d0F36eCEd99C735cbF6131e1fEB775D | 0x687871030477bf974725232F764aa04318A8b9c8 | 0x18248226C16BF76c032817854E7C83a2113B4f06 | 18 | 7500 | 8000 | 10500 | 1000 | 1000 | true | true | false | 1100000 | 600000 | 200000000 | 1 | 0x41B66b4b6b4c9dab039d96528D1b88f7BAF8C5A4 | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| stMATIC | 0x3A58a54C066FdC0f2D55FC9C89F0415C92eBf3C4 | 0xEA1132120ddcDDA2F119e99Fa7A27a0d036F7Ac9 | 0x1fFD28689DA7d0148ff0fCB669e9f9f0Fc13a219 | 0x6b030Ff3FB9956B1B69f475B77aE0d3Cf2CC5aFa | 18 | 5000 | 6500 | 11000 | 2000 | 2000 | true | false | false | 7500000 | 0 | 0 | 2 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |
| MaticX | 0xfa68FB4628DFF1028CFEc22b4162FCcd0d45efb6 | 0x80cA0d8C38d2e2BcbaB66aA1648Bd1C7160500FE | 0x62fC96b27a510cF4977B59FF952Dc32378Cc221d | 0xB5b46F918C2923fC7f26DB76e8a6A6e9C4347Cf9 | 18 | 5000 | 6500 | 11000 | 2000 | 2000 | true | false | false | 6000000 | 0 | 0 | 2 | 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | true | false | false | false | false | 0xa5ba6E5EC19a1Bf23C857991c857dB62b2Aa187B | 0x52A1CeB68Ee6b7B5D13E0376A1E0E4423A8cE26e | 0x81387c40EB75acB02757C1Ae55D5936E78c9dEd3 |


## InterestRateStrategies

| strategy | getBaseStableBorrowRate | getStableRateSlope1 | getStableRateSlope2 | optimalStableToTotal | maxStabletoTotalExcess | getBaseVariableBorrowRate | getVariableRateSlope1 | getVariableRateSlope2 | optimalUsageRatio | maxExcessUsageRatio |
|---|---|---|---|---|---|---|---|---|---|---|
| 0xA9F3C3caE095527061e6d270DBE163693e6fda9D | 50000000000000000000000000 | 5000000000000000000000000 | 750000000000000000000000000 | 200000000000000000000000000 | 800000000000000000000000000 | 0 | 40000000000000000000000000 | 750000000000000000000000000 | 800000000000000000000000000 | 200000000000000000000000000 |
| 0x03733F4E008d36f2e37F0080fF1c8DF756622E6F | 90000000000000000000000000 | 0 | 0 | 200000000000000000000000000 | 800000000000000000000000000 | 0 | 70000000000000000000000000 | 3000000000000000000000000000 | 450000000000000000000000000 | 550000000000000000000000000 |
| 0x41B66b4b6b4c9dab039d96528D1b88f7BAF8C5A4 | 50000000000000000000000000 | 5000000000000000000000000 | 600000000000000000000000000 | 200000000000000000000000000 | 800000000000000000000000000 | 0 | 40000000000000000000000000 | 600000000000000000000000000 | 900000000000000000000000000 | 100000000000000000000000000 |
| 0xFB0898dCFb69DF9E01DBE625A5988D6542e5BdC5 | 81000000000000000000000000 | 0 | 0 | 200000000000000000000000000 | 800000000000000000000000000 | 0 | 61000000000000000000000000 | 1000000000000000000000000000 | 750000000000000000000000000 | 250000000000000000000000000 |
| 0x4b8D3277d49E114C8F2D6E0B2eD310e29226fe16 | 160000000000000000000000000 | 0 | 0 | 200000000000000000000000000 | 800000000000000000000000000 | 30000000000000000000000000 | 140000000000000000000000000 | 1500000000000000000000000000 | 800000000000000000000000000 | 200000000000000000000000000 |


## EMode categories


| id | label | ltv | liquidationThreshold | liquidationBonus | priceSource |
|---|---|---|---|---|---|
| 1 | Stablecoins | 9700 | 9750 | 10100 | 0x0000000000000000000000000000000000000000 |
| 2 | MATIC correlated | 9250 | 9500 | 10100 | 0x0000000000000000000000000000000000000000 |

