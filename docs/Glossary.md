# Glossary

Comprehensive glossary of terms used across Ekubo Protocol documentation and smart contracts.

---

## A

### Active Liquidity
The amount of liquidity available for trading at the current price tick. Only positions with tick ranges that include the current tick contribute to active liquidity.

**Reference**: `src/libraries/Pool.sol`

### AMM (Automated Market Maker)
A decentralized exchange protocol that uses mathematical formulas to price assets and provide liquidity without traditional order books.

**Reference**: Core AMM logic in `src/Core.sol`

### Amount0, Amount1
The quantities of the two tokens in a pool. Amount0 refers to token0 (lexicographically smaller address), and Amount1 refers to token1.

**Reference**: `src/types/BalanceDelta.sol`

---

## B

### Balance Delta
The change in token balances resulting from a pool operation (swap, mint, burn). Positive values indicate tokens owed to the pool, negative values indicate tokens owed from the pool.

**Contract**: `src/types/BalanceDelta.sol`
```solidity
struct BalanceDelta {
    int256 amount0;
    int256 amount1;
}
```

### Basis Point (bip)
One hundredth of a percent (0.01%). Used for expressing fees and percentages precisely.

**Example**: 3000 basis points = 30% = 0.30

### Burn
The process of removing liquidity from a position or destroying an NFT position token.

**Reference**: `src/PositionManager.sol::burn()`

---

## C

### Callback
A function called by the protocol during certain operations (swaps, flash loans, locks) that must be implemented by the caller to complete the operation.

**Interfaces**: 
- `src/interfaces/ISwapCallback.sol`
- `src/interfaces/IFlashCallback.sol`
- `src/interfaces/ILockCallback.sol`
- `src/interfaces/IMintCallback.sol`

### Cardinality
The number of historical observations stored in a pool's oracle. Higher cardinality allows for longer historical price lookups.

**Reference**: `src/libraries/Oracle.sol`

### Collect
The action of claiming accumulated trading fees from a liquidity position.

**Reference**: `src/PositionManager.sol::collect()`

### Concentrated Liquidity
A liquidity provision model where LPs can specify custom price ranges for their liquidity, increasing capital efficiency compared to uniform liquidity distribution.

**Implementation**: `src/Core.sol`

### Core
The main protocol contract that manages all pools, swaps, and positions.

**Contract**: `src/Core.sol`
**Interface**: `src/interfaces/ICore.sol`

---

## D

### Deadline
A Unix timestamp after which a transaction will revert, protecting users from transactions that execute at unintended times.

**Usage**: All parameter structs in `src/interfaces/`

### Decimals
The number of decimal places for a token. Most ERC20 tokens use 18 decimals (like ETH), but some use different values (USDC uses 6).

**Reference**: ERC20 standard

### Delta
See [Balance Delta](#balance-delta)

### Dynamic Fee
A fee that changes based on pool conditions, typically implemented through hooks.

**Reference**: Custom hooks in `src/base/Hooks.sol`

---

## E

### ERC20
The standard interface for fungible tokens on Ethereum.

**Reference**: Token contracts used with Ekubo

### ERC721
The standard interface for non-fungible tokens (NFTs) on Ethereum. Used for representing liquidity positions.

**Contract**: `src/PositionManager.sol` implements ERC721

### Exact Input
A swap where the input amount is precisely specified and the output amount varies based on the price impact.

**Reference**: `src/SwapRouter.sol::exactInput()`

### Exact Output
A swap where the desired output amount is specified and the required input amount varies based on the price impact.

**Reference**: `src/SwapRouter.sol::exactOutput()`

---

## F

### Fee
The percentage charged on swaps. Fees are distributed to liquidity providers proportional to their contribution to active liquidity.

**Reference**: Fee tiers in `src/types/PoolKey.sol`

Common fee tiers:
- 100 (0.01%)
- 500 (0.05%)
- 3000 (0.30%)
- 10000 (1.00%)

### Fee Growth
A cumulative value tracking total fees earned per unit of liquidity. Used to calculate fees owed to individual positions.

**Reference**: `src/libraries/Position.sol`

### Fee Protocol
The percentage of swap fees that goes to the protocol (not to LPs).

**Reference**: `src/Core.sol::setProtocolFee()`

### Flash Loan
A loan that must be repaid within the same transaction. Used for arbitrage, liquidations, and other capital-efficient operations.

**Reference**: `src/Core.sol::flash()`
**Callback**: `src/interfaces/IFlashCallback.sol`

---

## G

### Gas
The computational cost of executing transactions on Ethereum, paid in ETH (or network native token).

### Governor
The governance contract that manages protocol upgrades and parameter changes.

**Reference**: `docs/governance/dao-structure.md`

---

## H

### Hook
A custom contract that can execute code before or after certain pool operations, enabling advanced features like dynamic fees, limit orders, or custom logic.

**Base Contract**: `src/base/Hooks.sol`
**Interface**: `src/interfaces/IHooks.sol`

### Hook Address
The address of a hook contract associated with a pool. Each pool can have one hook contract.

**Reference**: `src/types/PoolKey.sol`

---

## I

### Impermanent Loss
The temporary loss experienced by liquidity providers when token prices diverge from the entry price. In concentrated liquidity, this is more pronounced when price moves outside the position's range.

### Initialization
The process of creating a new pool with an initial price.

**Reference**: `src/Core.sol::initialize()`

---

## J

### Just-In-Time (JIT) Liquidity
Liquidity added immediately before a large trade and removed immediately after, capturing fees without prolonged exposure to impermanent loss.

---

## K

### Key (Pool Key)
The unique identifier for a pool, containing token addresses, fee tier, tick spacing, and hook address.

**Contract**: `src/types/PoolKey.sol`
```solidity
struct PoolKey {
    address token0;
    address token1;
    uint24 fee;
    int24 tickSpacing;
    address hooks;
}
```

---

## L

### Liquidity
The amount of capital available for trading in a pool. Measured as the geometric mean of the two token reserves at the current price.

**Reference**: `src/libraries/Pool.sol`

### Liquidity Provider (LP)
A user who deposits tokens into a pool to facilitate trading and earn fees.

### Lock
A mechanism that ensures atomic execution of operations. During a lock, external calls are restricted to prevent reentrancy.

**Reference**: `src/Core.sol::lock()`
**Callback**: `src/interfaces/ILockCallback.sol`

### Lower Tick
The lower boundary of a liquidity position's price range.

**Reference**: Position structs in `src/PositionManager.sol`

---

## M

### Mint
The process of creating a new liquidity position or adding liquidity to a pool.

**Reference**: `src/PositionManager.sol::mint()`

### Multi-Hop Swap
A swap that routes through multiple pools to achieve better pricing or access tokens without direct pools.

**Reference**: `src/SwapRouter.sol::exactInput()` and `exactOutput()`

### Multiplier
A factor applied to staking rewards based on lock duration. Longer locks receive higher multipliers.

**Reference**: `docs/governance/dao-structure.md`

---

## N

### NFT (Non-Fungible Token)
A unique token representing ownership of a specific asset. In Ekubo, each liquidity position is represented as an NFT.

**Contract**: `src/PositionManager.sol`

### Nonce
A number used once, typically to prevent replay attacks or ensure transaction uniqueness.

---

## O

### Observation
A snapshot of price and liquidity data at a specific block. Used by the oracle to calculate time-weighted averages.

**Reference**: `src/libraries/Oracle.sol`

```solidity
struct Observation {
    uint32 blockTimestamp;
    int56 tickCumulative;
    uint160 secondsPerLiquidityCumulativeX128;
    bool initialized;
}
```

### Oracle
A system that provides historical price data using time-weighted average prices (TWAP).

**Contract**: `src/Oracle.sol`
**Interface**: `src/interfaces/IOracle.sol`

### Out of Range
A position whose price range does not include the current market price. Out-of-range positions earn no fees.

---

## P

### Path
An encoded sequence of tokens and fee tiers defining a multi-hop swap route.

**Encoding**: `src/libraries/Path.sol`

Format: `token0 | fee0 | token1 | fee1 | token2`

### Periphery
Contracts that provide user-friendly interfaces to the core protocol (Router, Position Manager, Quoter).

**Contracts**: `src/SwapRouter.sol`, `src/PositionManager.sol`, `src/Quoter.sol`

### Pool
A smart contract that holds two tokens and enables trading between them at algorithmically determined prices.

**Reference**: Pool management in `src/Core.sol`

### Pool ID
A unique identifier (bytes32 hash) for a pool, derived from its PoolKey.

**Calculation**: `keccak256(abi.encode(poolKey))`

### Position
A specific range of liquidity provided by an LP, defined by lower tick, upper tick, and liquidity amount.

**Storage**: `src/libraries/Position.sol`

**Struct**:
```solidity
struct PositionInfo {
    uint128 liquidity;
    uint256 feeGrowthInside0LastX128;
    uint256 feeGrowthInside1LastX128;
    uint128 tokensOwed0;
    uint128 tokensOwed1;
}
```

### Position Manager
The contract that manages liquidity positions as ERC721 NFTs.

**Contract**: `src/PositionManager.sol`
**Interface**: `src/interfaces/IPositionManager.sol`

### Price Impact
The effect a trade has on the pool's price. Larger trades relative to liquidity cause greater price impact.

### Protocol Fee
A portion of swap fees collected by the protocol rather than distributed to LPs.

**Configuration**: `src/Core.sol::setProtocolFee()`

---

## Q

### Quote
An estimated output/input amount for a swap without executing it.

**Contract**: `src/Quoter.sol`
**Interface**: `src/interfaces/IQuoter.sol`

### Quorum
The minimum number of votes required for a governance proposal to pass.

**Reference**: `docs/governance/dao-structure.md`

---

## R

### Range Order
A type of liquidity position with a narrow price range, functioning similarly to a limit order.

### Rebalance
The act of adjusting a liquidity position's range to keep it in-range as prices change.

### Reentrancy
An attack where a malicious contract calls back into the protocol before the first invocation completes. Protected against via the lock mechanism.

**Protection**: `src/Core.sol` lock pattern

### Router
A contract that simplifies swap operations with convenient functions and token approval handling.

**Contract**: `src/SwapRouter.sol`
**Interface**: `src/interfaces/ISwapRouter.sol`

---

## S

### Salt
A unique identifier used to differentiate positions with identical parameters (same owner, tick range) for the same pool.

**Usage**: `src/Core.sol::getPosition()` parameter

### Slippage
The difference between expected and executed price due to market movement or price impact.

### Slippage Tolerance
The maximum acceptable price deviation, expressed as a percentage or minimum output amount.

**Protection**: `amountOutMinimum` and `amountInMaximum` parameters

### Sqrt Price
The square root of the price// filepath: docs/glossary.md
# Glossary

Comprehensive glossary of terms used across Ekubo Protocol documentation and smart contracts.

---

## A

### Active Liquidity
The amount of liquidity available for trading at the current price tick. Only positions with tick ranges that include the current tick contribute to active liquidity.

**Reference**: `src/libraries/Pool.sol`

### AMM (Automated Market Maker)
A decentralized exchange protocol that uses mathematical formulas to price assets and provide liquidity without traditional order books.

**Reference**: Core AMM logic in `src/Core.sol`

### Amount0, Amount1
The quantities of the two tokens in a pool. Amount0 refers to token0 (lexicographically smaller address), and Amount1 refers to token1.

**Reference**: `src/types/BalanceDelta.sol`

---

## B

### Balance Delta
The change in token balances resulting from a pool operation (swap, mint, burn). Positive values indicate tokens owed to the pool, negative values indicate tokens owed from the pool.

**Contract**: `src/types/BalanceDelta.sol`
```solidity
struct BalanceDelta {
    int256 amount0;
    int256 amount1;
}
```

### Basis Point (bip)
One hundredth of a percent (0.01%). Used for expressing fees and percentages precisely.

**Example**: 3000 basis points = 30% = 0.30

### Burn
The process of removing liquidity from a position or destroying an NFT position token.

**Reference**: `src/PositionManager.sol::burn()`

---

## C

### Callback
A function called by the protocol during certain operations (swaps, flash loans, locks) that must be implemented by the caller to complete the operation.

**Interfaces**: 
- `src/interfaces/ISwapCallback.sol`
- `src/interfaces/IFlashCallback.sol`
- `src/interfaces/ILockCallback.sol`
- `src/interfaces/IMintCallback.sol`

### Cardinality
The number of historical observations stored in a pool's oracle. Higher cardinality allows for longer historical price lookups.

**Reference**: `src/libraries/Oracle.sol`

### Collect
The action of claiming accumulated trading fees from a liquidity position.

**Reference**: `src/PositionManager.sol::collect()`

### Concentrated Liquidity
A liquidity provision model where LPs can specify custom price ranges for their liquidity, increasing capital efficiency compared to uniform liquidity distribution.

**Implementation**: `src/Core.sol`

### Core
The main protocol contract that manages all pools, swaps, and positions.

**Contract**: `src/Core.sol`
**Interface**: `src/interfaces/ICore.sol`

---

## D

### Deadline
A Unix timestamp after which a transaction will revert, protecting users from transactions that execute at unintended times.

**Usage**: All parameter structs in `src/interfaces/`

### Decimals
The number of decimal places for a token. Most ERC20 tokens use 18 decimals (like ETH), but some use different values (USDC uses 6).

**Reference**: ERC20 standard

### Delta
See [Balance Delta](#balance-delta)

### Dynamic Fee
A fee that changes based on pool conditions, typically implemented through hooks.

**Reference**: Custom hooks in `src/base/Hooks.sol`

---

## E

### ERC20
The standard interface for fungible tokens on Ethereum.

**Reference**: Token contracts used with Ekubo

### ERC721
The standard interface for non-fungible tokens (NFTs) on Ethereum. Used for representing liquidity positions.

**Contract**: `src/PositionManager.sol` implements ERC721

### Exact Input
A swap where the input amount is precisely specified and the output amount varies based on the price impact.

**Reference**: `src/SwapRouter.sol::exactInput()`

### Exact Output
A swap where the desired output amount is specified and the required input amount varies based on the price impact.

**Reference**: `src/SwapRouter.sol::exactOutput()`

---

## F

### Fee
The percentage charged on swaps. Fees are distributed to liquidity providers proportional to their contribution to active liquidity.

**Reference**: Fee tiers in `src/types/PoolKey.sol`

Common fee tiers:
- 100 (0.01%)
- 500 (0.05%)
- 3000 (0.30%)
- 10000 (1.00%)

### Fee Growth
A cumulative value tracking total fees earned per unit of liquidity. Used to calculate fees owed to individual positions.

**Reference**: `src/libraries/Position.sol`

### Fee Protocol
The percentage of swap fees that goes to the protocol (not to LPs).

**Reference**: `src/Core.sol::setProtocolFee()`

### Flash Loan
A loan that must be repaid within the same transaction. Used for arbitrage, liquidations, and other capital-efficient operations.

**Reference**: `src/Core.sol::flash()`
**Callback**: `src/interfaces/IFlashCallback.sol`

---

## G

### Gas
The computational cost of executing transactions on Ethereum, paid in ETH (or network native token).

### Governor
The governance contract that manages protocol upgrades and parameter changes.

**Reference**: `docs/governance/dao-structure.md`

---

## H

### Hook
A custom contract that can execute code before or after certain pool operations, enabling advanced features like dynamic fees, limit orders, or custom logic.

**Base Contract**: `src/base/Hooks.sol`
**Interface**: `src/interfaces/IHooks.sol`

### Hook Address
The address of a hook contract associated with a pool. Each pool can have one hook contract.

**Reference**: `src/types/PoolKey.sol`

---

## I

### Impermanent Loss
The temporary loss experienced by liquidity providers when token prices diverge from the entry price. In concentrated liquidity, this is more pronounced when price moves outside the position's range.

### Initialization
The process of creating a new pool with an initial price.

**Reference**: `src/Core.sol::initialize()`

---

## J

### Just-In-Time (JIT) Liquidity
Liquidity added immediately before a large trade and removed immediately after, capturing fees without prolonged exposure to impermanent loss.

---

## K

### Key (Pool Key)
The unique identifier for a pool, containing token addresses, fee tier, tick spacing, and hook address.

**Contract**: `src/types/PoolKey.sol`
```solidity
struct PoolKey {
    address token0;
    address token1;
    uint24 fee;
    int24 tickSpacing;
    address hooks;
}
```

---

## L

### Liquidity
The amount of capital available for trading in a pool. Measured as the geometric mean of the two token reserves at the current price.

**Reference**: `src/libraries/Pool.sol`

### Liquidity Provider (LP)
A user who deposits tokens into a pool to facilitate trading and earn fees.

### Lock
A mechanism that ensures atomic execution of operations. During a lock, external calls are restricted to prevent reentrancy.

**Reference**: `src/Core.sol::lock()`
**Callback**: `src/interfaces/ILockCallback.sol`

### Lower Tick
The lower boundary of a liquidity position's price range.

**Reference**: Position structs in `src/PositionManager.sol`

---

## M

### Mint
The process of creating a new liquidity position or adding liquidity to a pool.

**Reference**: `src/PositionManager.sol::mint()`

### Multi-Hop Swap
A swap that routes through multiple pools to achieve better pricing or access tokens without direct pools.

**Reference**: `src/SwapRouter.sol::exactInput()` and `exactOutput()`

### Multiplier
A factor applied to staking rewards based on lock duration. Longer locks receive higher multipliers.

**Reference**: `docs/governance/dao-structure.md`

---

## N

### NFT (Non-Fungible Token)
A unique token representing ownership of a specific asset. In Ekubo, each liquidity position is represented as an NFT.

**Contract**: `src/PositionManager.sol`

### Nonce
A number used once, typically to prevent replay attacks or ensure transaction uniqueness.

---

## O

### Observation
A snapshot of price and liquidity data at a specific block. Used by the oracle to calculate time-weighted averages.

**Reference**: `src/libraries/Oracle.sol`

```solidity
struct Observation {
    uint32 blockTimestamp;
    int56 tickCumulative;
    uint160 secondsPerLiquidityCumulativeX128;
    bool initialized;
}
```

### Oracle
A system that provides historical price data using time-weighted average prices (TWAP).

**Contract**: `src/Oracle.sol`
**Interface**: `src/interfaces/IOracle.sol`

### Out of Range
A position whose price range does not include the current market price. Out-of-range positions earn no fees.

---

## P

### Path
An encoded sequence of tokens and fee tiers defining a multi-hop swap route.

**Encoding**: `src/libraries/Path.sol`

Format: `token0 | fee0 | token1 | fee1 | token2`

### Periphery
Contracts that provide user-friendly interfaces to the core protocol (Router, Position Manager, Quoter).

**Contracts**: `src/SwapRouter.sol`, `src/PositionManager.sol`, `src/Quoter.sol`

### Pool
A smart contract that holds two tokens and enables trading between them at algorithmically determined prices.

**Reference**: Pool management in `src/Core.sol`

### Pool ID
A unique identifier (bytes32 hash) for a pool, derived from its PoolKey.

**Calculation**: `keccak256(abi.encode(poolKey))`

### Position
A specific range of liquidity provided by an LP, defined by lower tick, upper tick, and liquidity amount.

**Storage**: `src/libraries/Position.sol`

**Struct**:
```solidity
struct PositionInfo {
    uint128 liquidity;
    uint256 feeGrowthInside0LastX128;
    uint256 feeGrowthInside1LastX128;
    uint128 tokensOwed0;
    uint128 tokensOwed1;
}
```

### Position Manager
The contract that manages liquidity positions as ERC721 NFTs.

**Contract**: `src/PositionManager.sol`
**Interface**: `src/interfaces/IPositionManager.sol`

### Price Impact
The effect a trade has on the pool's price. Larger trades relative to liquidity cause greater price impact.

### Protocol Fee
A portion of swap fees collected by the protocol rather than distributed to LPs.

**Configuration**: `src/Core.sol::setProtocolFee()`

---

## Q

### Quote
An estimated output/input amount for a swap without executing it.

**Contract**: `src/Quoter.sol`
**Interface**: `src/interfaces/IQuoter.sol`

### Quorum
The minimum number of votes required for a governance proposal to pass.

**Reference**: `docs/governance/dao-structure.md`

---

## R

### Range Order
A type of liquidity position with a narrow price range, functioning similarly to a limit order.

### Rebalance
The act of adjusting a liquidity position's range to keep it in-range as prices change.

### Reentrancy
An attack where a malicious contract calls back into the protocol before the first invocation completes. Protected against via the lock mechanism.

**Protection**: `src/Core.sol` lock pattern

### Router
A contract that simplifies swap operations with convenient functions and token approval handling.

**Contract**: `src/SwapRouter.sol`
**Interface**: `src/interfaces/ISwapRouter.sol`

---

## S

### Salt
A unique identifier used to differentiate positions with identical parameters (same owner, tick range) for the same pool.

**Usage**: `src/Core.sol::getPosition()` parameter

### Slippage
The difference between expected and executed price due to market movement or price impact.

### Slippage Tolerance
The maximum acceptable price deviation, expressed as a percentage or minimum output amount.

**Protection**: `amountOutMinimum` and `amountInMaximum` parameters

### Sqrt Price
The square root of the price