# API_REFERENCE.md

Ekubo Protocol EVM API Reference

---

## Overview

This document provides an overview of the key smart contract interfaces and functions available in the Ekubo Protocol EVM implementation.

---

## 1. Core Contracts

### ICoreActions

The main interface for core pool actions including swaps, liquidity management, and flash loans.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PoolKey} from "../types/PoolKey.sol";
import {BalanceDelta} from "../types/BalanceDelta.sol";

interface ICoreActions {
    /// @notice Update a position's liquidity
    /// @param poolKey The pool identifier
    /// @param params Position update parameters
    /// @return delta The balance changes
    function updatePosition(
        PoolKey calldata poolKey,
        UpdatePositionParams calldata params
    ) external returns (BalanceDelta delta);

    /// @notice Execute a swap
    /// @param poolKey The pool identifier
    /// @param params Swap parameters
    /// @return delta The balance changes
    function swap(
        PoolKey calldata poolKey,
        SwapParams calldata params
    ) external returns (BalanceDelta delta);

    /// @notice Execute a flash loan
    /// @param recipient The address receiving the flash loan
    /// @param token0 First token address
    /// @param token1 Second token address
    /// @param amount0 Amount of token0
    /// @param amount1 Amount of token1
    /// @param data Callback data
    function flash(
        address recipient,
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;

    /// @notice Acquire a lock for atomic operations
    /// @param data Callback data
    /// @return result The callback result
    function lock(bytes calldata data) external returns (bytes memory result);
}

struct UpdatePositionParams {
    int24 tickLower;
    int24 tickUpper;
    int128 liquidityDelta;
    bytes32 salt;
}

struct SwapParams {
    bool zeroForOne;
    int256 amountSpecified;
    uint160 sqrtPriceLimitX96;
}
```

### ICoreState

Interface for reading core contract state.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PoolKey} from "../types/PoolKey.sol";

interface ICoreState {
    /// @notice Get the current pool state
    /// @param poolKey The pool identifier
    /// @return sqrtPriceX96 Current sqrt price
    /// @return tick Current tick
    /// @return observationIndex Current observation index
    /// @return observationCardinality Current cardinality
    /// @return observationCardinalityNext Next cardinality
    /// @return feeProtocol Protocol fee
    /// @return unlocked Whether pool is unlocked
    function getSlot0(PoolKey calldata poolKey)
        external
        view
        returns (
            uint160 sqrtPriceX96,
            int24 tick,
            uint16 observationIndex,
            uint16 observationCardinality,
            uint16 observationCardinalityNext,
            uint8 feeProtocol,
            bool unlocked
        );

    /// @notice Get pool liquidity
    /// @param poolKey The pool identifier
    /// @return liquidity Current liquidity
    function getLiquidity(PoolKey calldata poolKey)
        external
        view
        returns (uint128 liquidity);

    /// @notice Get tick information
    /// @param poolKey The pool identifier
    /// @param tick The tick to query
    /// @return info Tick information
    function getTickInfo(PoolKey calldata poolKey, int24 tick)
        external
        view
        returns (TickInfo memory info);

    /// @notice Get position information
    /// @param poolKey The pool identifier
    /// @param owner Position owner
    /// @param tickLower Lower tick bound
    /// @param tickUpper Upper tick bound
    /// @param salt Position salt
    /// @return info Position information
    function getPosition(
        PoolKey calldata poolKey,
        address owner,
        int24 tickLower,
        int24 tickUpper,
        bytes32 salt
    ) external view returns (PositionInfo memory info);

    /// @notice Get fee growth globals
    /// @param poolKey The pool identifier
    /// @return feeGrowthGlobal0X128 Fee growth for token0
    /// @return feeGrowthGlobal1X128 Fee growth for token1
    function getFeeGrowthGlobals(PoolKey calldata poolKey)
        external
        view
        returns (uint256 feeGrowthGlobal0X128, uint256 feeGrowthGlobal1X128);
}

struct TickInfo {
    uint128 liquidityGross;
    int128 liquidityNet;
    uint256 feeGrowthOutside0X128;
    uint256 feeGrowthOutside1X128;
    int56 tickCumulativeOutside;
    uint160 secondsPerLiquidityOutsideX128;
    uint32 secondsOutside;
    bool initialized;
}

struct PositionInfo {
    uint128 liquidity;
    uint256 feeGrowthInside0LastX128;
    uint256 feeGrowthInside1LastX128;
    uint128 tokensOwed0;
    uint128 tokensOwed1;
}
```

### ICore

Combined core interface inheriting from actions and state.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ICoreActions} from "./ICoreActions.sol";
import {ICoreState} from "./ICoreState.sol";
import {ICoreEvents} from "./ICoreEvents.sol";
import {ICoreErrors} from "./ICoreErrors.sol";

interface ICore is ICoreActions, ICoreState, ICoreEvents, ICoreErrors {
    /// @notice Initialize a new pool
    /// @param poolKey The pool parameters
    /// @param sqrtPriceX96 Initial sqrt price
    /// @return tick The initial tick
    function initialize(PoolKey calldata poolKey, uint160 sqrtPriceX96)
        external
        returns (int24 tick);

    /// @notice Deposit tokens to the core
    /// @param token Token address
    /// @param amount Amount to deposit
    function deposit(address token, uint256 amount) external;

    /// @notice Withdraw tokens from the core
    /// @param token Token address
    /// @param to Recipient address
    /// @param amount Amount to withdraw
    function withdraw(address token, address to, uint256 amount) external;

    /// @notice Get token balance held by core for caller
    /// @param token Token address
    /// @return balance Token balance
    function balanceOf(address token) external view returns (uint256 balance);

    /// @notice Set protocol fee for a pool
    /// @param poolKey The pool identifier
    /// @param feeProtocol0 Protocol fee for token0
    /// @param feeProtocol1 Protocol fee for token1
    function setProtocolFee(
        PoolKey calldata poolKey,
        uint8 feeProtocol0,
        uint8 feeProtocol1
    ) external;

    /// @notice Collect protocol fees
    /// @param poolKey The pool identifier
    /// @param recipient Fee recipient
    /// @return amount0 Collected token0 fees
    /// @return amount1 Collected token1 fees
    function collectProtocolFees(PoolKey calldata poolKey, address recipient)
        external
        returns (uint256 amount0, uint256 amount1);
}
```

---

## 2. Position Management

### IPositionManager

Manages liquidity positions as NFTs (ERC721).

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PoolKey} from "../types/PoolKey.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Metadata} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

interface IPositionManager is IERC721, IERC721Metadata {
    /// @notice Mint a new position
    /// @param params Mint parameters
    /// @return tokenId The minted token ID
    /// @return liquidity Amount of liquidity minted
    /// @return amount0 Amount of token0 used
    /// @return amount1 Amount of token1 used
    function mint(MintParams calldata params)
        external
        payable
        returns (
            uint256 tokenId,
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );

    /// @notice Increase liquidity in a position
    /// @param params Increase liquidity parameters
    /// @return liquidity Amount of liquidity added
    /// @return amount0 Amount of token0 used
    /// @return amount1 Amount of token1 used
    function increaseLiquidity(IncreaseLiquidityParams calldata params)
        external
        payable
        returns (uint128 liquidity, uint256 amount0, uint256 amount1);

    /// @notice Decrease liquidity from a position
    /// @param params Decrease liquidity parameters
    /// @return amount0 Amount of token0 received
    /// @return amount1 Amount of token1 received
    function decreaseLiquidity(DecreaseLiquidityParams calldata params)
        external
        returns (uint256 amount0, uint256 amount1);

    /// @notice Collect fees from a position
    /// @param params Collection parameters
    /// @return amount0 Amount of token0 collected
    /// @return amount1 Amount of token1 collected
    function collect(CollectParams calldata params)
        external
        returns (uint256 amount0, uint256 amount1);

    /// @notice Burn a position with zero liquidity
    /// @param tokenId The position token ID
    function burn(uint256 tokenId) external;

    /// @notice Get position details
    /// @param tokenId The position token ID
    /// @return position The position data
    function positions(uint256 tokenId)
        external
        view
        returns (Position memory position);

    /// @notice Get the next token ID to be minted
    /// @return tokenId Next token ID
    function nextTokenId() external view returns (uint256 tokenId);
}

struct MintParams {
    PoolKey poolKey;
    int24 tickLower;
    int24 tickUpper;
    uint256 amount0Desired;
    uint256 amount1Desired;
    uint256 amount0Min;
    uint256 amount1Min;
    address recipient;
    uint256 deadline;
}

struct IncreaseLiquidityParams {
    uint256 tokenId;
    uint256 amount0Desired;
    uint256 amount1Desired;
    uint256 amount0Min;
    uint256 amount1Min;
    uint256 deadline;
}

struct DecreaseLiquidityParams {
    uint256 tokenId;
    uint128 liquidity;
    uint256 amount0Min;
    uint256 amount1Min;
    uint256 deadline;
}

struct CollectParams {
    uint256 tokenId;
    address recipient;
    uint128 amount0Max;
    uint128 amount1Max;
}

struct Position {
    uint96 nonce;
    address operator;
    PoolKey poolKey;
    int24 tickLower;
    int24 tickUpper;
    uint128 liquidity;
    uint256 feeGrowthInside0LastX128;
    uint256 feeGrowthInside1LastX128;
    uint128 tokensOwed0;
    uint128 tokensOwed1;
}
```

---

## 3. Router Interfaces

### ISwapRouter

Handles token swaps with exact input/output semantics.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface ISwapRouter {
    /// @notice Swap exact input for single pool
    /// @param params Swap parameters
    /// @return amountOut Amount of output tokens
    function exactInputSingle(ExactInputSingleParams calldata params)
        external
        payable
        returns (uint256 amountOut);

    /// @notice Swap exact output for single pool
    /// @param params Swap parameters
    /// @return amountIn Amount of input tokens used
    function exactOutputSingle(ExactOutputSingleParams calldata params)
        external
        payable
        returns (uint256 amountIn);

    /// @notice Swap exact input through multiple pools
    /// @param params Swap parameters
    /// @return amountOut Amount of output tokens
    function exactInput(ExactInputParams calldata params)
        external
        payable
        returns (uint256 amountOut);

    /// @notice Swap exact output through multiple pools
    /// @param params Swap parameters
    /// @return amountIn Amount of input tokens used
    function exactOutput(ExactOutputParams calldata params)
        external
        payable
        returns (uint256 amountIn);
}

struct ExactInputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    address recipient;
    uint256 amountIn;
    uint256 amountOutMinimum;
    uint160 sqrtPriceLimitX96;
}

struct ExactOutputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    address recipient;
    uint256 amountOut;
    uint256 amountInMaximum;
    uint160 sqrtPriceLimitX96;
}

struct ExactInputParams {
    bytes path;
    address recipient;
    uint256 amountIn;
    uint256 amountOutMinimum;
}

struct ExactOutputParams {
    bytes path;
    address recipient;
    uint256 amountOut;
    uint256 amountInMaximum;
}
```

### IQuoter

Provides swap quotes without executing transactions.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IQuoter {
    /// @notice Quote exact input single swap
    /// @param params Quote parameters
    /// @return amountOut Expected output amount
    /// @return sqrtPriceX96After Price after swap
    /// @return tickAfter Tick after swap
    /// @return gasEstimate Estimated gas usage
    function quoteExactInputSingle(QuoteExactInputSingleParams calldata params)
        external
        returns (
            uint256 amountOut,
            uint160 sqrtPriceX96After,
            int24 tickAfter,
            uint256 gasEstimate
        );

    /// @notice Quote exact output single swap
    /// @param params Quote parameters
    /// @return amountIn Expected input amount
    /// @return sqrtPriceX96After Price after swap
    /// @return tickAfter Tick after swap
    /// @return gasEstimate Estimated gas usage
    function quoteExactOutputSingle(QuoteExactOutputSingleParams calldata params)
        external
        returns (
            uint256 amountIn,
            uint160 sqrtPriceX96After,
            int24 tickAfter,
            uint256 gasEstimate
        );

    /// @notice Quote exact input multi-hop swap
    /// @param params Quote parameters
    /// @return amountOut Expected output amount
    /// @return sqrtPriceX96AfterList Prices after each swap
    /// @return tickAfterList Ticks after each swap
    /// @return gasEstimate Estimated gas usage
    function quoteExactInput(QuoteExactInputParams calldata params)
        external
        returns (
            uint256 amountOut,
            uint160[] memory sqrtPriceX96AfterList,
            int24[] memory tickAfterList,
            uint256 gasEstimate
        );

    /// @notice Quote exact output multi-hop swap
    /// @param params Quote parameters
    /// @return amountIn Expected input amount
    /// @return sqrtPriceX96AfterList Prices after each swap
    /// @return tickAfterList Ticks after each swap
    /// @return gasEstimate Estimated gas usage
    function quoteExactOutput(QuoteExactOutputParams calldata params)
        external
        returns (
            uint256 amountIn,
            uint160[] memory sqrtPriceX96AfterList,
            int24[] memory tickAfterList,
            uint256 gasEstimate
        );
}

struct QuoteExactInputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    uint256 amountIn;
    uint160 sqrtPriceLimitX96;
}

struct QuoteExactOutputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    uint256 amountOut;
    uint160 sqrtPriceLimitX96;
}

struct QuoteExactInputParams {
    bytes path;
    uint256 amountIn;
}

struct QuoteExactOutputParams {
    bytes path;
    uint256 amountOut;
}
```

---

## 4. Oracle Interface

### IOracle

Provides time-weighted average price (TWAP) observations.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PoolKey} from "../types/PoolKey.sol";

interface IOracle {
    /// @notice Get TWAP observations
    /// @param poolKey The pool identifier
    /// @param secondsAgos Array of seconds ago to observe
    /// @return tickCumulatives Cumulative tick values
    /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity
    function observe(PoolKey calldata poolKey, uint32[] calldata secondsAgos)
        external
        view
        returns (
            int56[] memory tickCumulatives,
            uint160[] memory secondsPerLiquidityCumulativeX128s
        );

    /// @notice Increase observation cardinality
    /// @param poolKey The pool identifier
    /// @param observationCardinalityNext Desired cardinality
    function increaseObservationCardinalityNext(
        PoolKey calldata poolKey,
        uint16 observationCardinalityNext
    ) external;

    /// @notice Get observation at index
    /// @param poolKey The pool identifier
    /// @param index Observation index
    /// @return observation The observation data
    function getObservation(PoolKey calldata poolKey, uint256 index)
        external
        view
        returns (Observation memory observation);
}

struct Observation {
    uint32 blockTimestamp;
    int56 tickCumulative;
    uint160 secondsPerLiquidityCumulativeX128;
    bool initialized;
}
```

---

## 5. Callback Interfaces

### ISwapCallback

Callback for swap operations.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface ISwapCallback {
    /// @notice Called after a swap is executed
    /// @param amount0Delta Change in token0 (positive = owed to pool)
    /// @param amount1Delta Change in token1 (positive = owed to pool)
    /// @param data Callback data passed through swap
    function swapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}
```

### IFlashCallback

Callback for flash loan operations.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IFlashCallback {
    /// @notice Called after flash loan funds are transferred
    /// @param fee0 Fee owed for token0
    /// @param fee1 Fee owed for token1
    /// @param data Callback data passed through flash
    function flashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external;
}
```

### ILockCallback

Callback for lock operations.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface ILockCallback {
    /// @notice Called when lock is acquired
    /// @param data Callback data passed through lock
    /// @return result Result data to return from lock
    function lockAcquired(bytes calldata data)
        external
        returns (bytes memory result);
}
```

### IMintCallback

Callback for mint operations.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IMintCallback {
    /// @notice Called after position mint
    /// @param amount0Owed Amount of token0 owed
    /// @param amount1Owed Amount of token1 owed
    /// @param data Callback data
    function mintCallback(
        uint256 amount0Owed,
        uint256 amount1Owed,
        bytes calldata data
    ) external;
}
```

---

## 6. Hooks Interface

### IHooks

Interface for pool hooks that can customize pool behavior.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PoolKey} from "../types/PoolKey.sol";
import {BalanceDelta} from "../types/BalanceDelta.sol";

interface IHooks {
    /// @notice Called before pool initialization
    /// @param sender The address initiating the action
    /// @param poolKey The pool being initialized
    /// @param sqrtPriceX96 Initial price
    /// @param hookData Additional hook data
    /// @return selector Function selector for validation
    function beforeInitialize(
        address sender,
        PoolKey calldata poolKey,
        uint160 sqrtPriceX96,
        bytes calldata hookData
    ) external returns (bytes4 selector);

    /// @notice Called after pool initialization
    /// @param sender The address that initiated the action
    /// @param poolKey The pool that was initialized
    /// @param sqrtPriceX96 Initial price
    /// @param tick Initial tick
    /// @param hookData Additional hook data
    /// @return selector Function selector for validation
    function afterInitialize(
        address sender,
        PoolKey calldata poolKey,
        uint160 sqrtPriceX96,
        int24 tick,
        bytes calldata hookData
    ) external returns (bytes4 selector);

    /// @notice Called before a swap
    /// @param sender The address initiating the swap
    /// @param poolKey The pool being swapped in
    /// @param params Swap parameters
    /// @param hookData Additional hook data
    /// @return selector Function selector for validation
    /// @return delta Balance delta override (if any)
    function beforeSwap(
        address sender,
        PoolKey calldata poolKey,
        SwapParams calldata params,
        bytes calldata hookData
    ) external returns (bytes4 selector, BalanceDelta delta);

    /// @notice Called after a swap
    /// @param sender The address that initiated the swap
    /// @param poolKey The pool that was swapped in
    /// @param params Swap parameters
    /// @param delta Balance changes from swap
    /// @param hookData Additional hook data
    /// @return selector Function selector for validation
    /// @return deltaAdjustment Balance delta adjustment
    function afterSwap(
        address sender,
        PoolKey calldata poolKey,
        SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external returns (bytes4 selector, BalanceDelta deltaAdjustment);

    /// @notice Called before modifying a position
    /// @param sender The address modifying the position
    /// @param poolKey The pool containing the position
    /// @param params Position modification parameters
    /// @param hookData Additional hook data
    /// @return selector Function selector for validation
    function beforeModifyPosition(
        address sender,
        PoolKey calldata poolKey,
        UpdatePositionParams calldata params,
        bytes calldata hookData
    ) external returns (bytes4 selector);

    /// @notice Called after modifying a position
    /// @param sender The address that modified the position
    /// @param poolKey The pool containing the position
    /// @param params Position modification parameters
    /// @param delta Balance changes
    /// @param hookData Additional hook data
    /// @return selector Function selector for validation
    function afterModifyPosition(
        address sender,
        PoolKey calldata poolKey,
        UpdatePositionParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external returns (bytes4 selector);

    /// @notice Called before a donation
    /// @param sender The address making the donation
    /// @param poolKey The pool receiving the donation
    /// @param amount0 Amount of token0 donated
    /// @param amount1 Amount of token1 donated
    /// @param hookData Additional hook data
    /// @return selector Function selector for validation
    function beforeDonate(
        address sender,
        PoolKey calldata poolKey,
        uint256 amount0,
        uint256 amount1,
        bytes calldata hookData
    ) external returns (bytes4 selector);

    /// @notice Called after a donation
    /// @param sender The address that made the donation
    /// @param poolKey The pool that received the donation
    /// @param amount0 Amount of token0 donated
    /// @param amount1 Amount of token1 donated
    /// @param hookData Additional hook data
    /// @return selector Function selector for validation
    function afterDonate(
        address sender,
        PoolKey calldata poolKey,
        uint256 amount0,
        uint256 amount1,
        bytes calldata hookData
    ) external returns (bytes4 selector);
}
```

---

## 7. Events

### Core Events

```solidity
interface ICoreEvents {
    /// @notice Emitted when a pool is initialized
    event PoolInitialized(
        bytes32 indexed poolId,
        address indexed token0,
        address indexed token1,
        uint24 fee,
        int24 tickSpacing,
        address hooks,
        uint160 sqrtPriceX96,
        int24 tick
    );

    /// @notice Emitted when a position is updated
    event PositionUpdated(
        bytes32 indexed poolId,
        address indexed owner,
        int24 tickLower,
        int24 tickUpper,
        int128 liquidityDelta,
        int256 amount0,
        int256 amount1
    );

    /// @notice Emitted when a swap occurs
    event Swap(
        bytes32 indexed poolId,
        address indexed sender,
        int256 amount0,
        int256 amount1,
        uint160 sqrtPriceX96,
        uint128 liquidity,
        int24 tick
    );

    /// @notice Emitted when a flash loan occurs
    event Flash(
        address indexed sender,
        address indexed recipient,
        uint256 amount0,
        uint256 amount1,
        uint256 fee0,
        uint256 fee1
    );

    /// @notice Emitted when fees are collected
    event Collect(
        bytes32 indexed poolId,
        address indexed owner,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount0,
        uint128 amount1
    );

    /// @notice Emitted when protocol fees are collected
    event ProtocolFeesCollected(
        bytes32 indexed poolId,
        address indexed recipient,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice Emitted when tokens are donated to a pool
    event Donate(
        bytes32 indexed poolId,
        address indexed sender,
        uint256 amount0,
        uint256 amount1
    );
}
```

### Position Manager Events

```solidity
interface IPositionManagerEvents {
    /// @notice Emitted when a position is minted
    event PositionMinted(
        uint256 indexed tokenId,
        address indexed owner,
        bytes32 indexed poolId,
        int24 tickLower,
        int24 tickUpper,
        uint128 liquidity,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice Emitted when liquidity is increased
    event LiquidityIncreased(
        uint256 indexed tokenId,
        uint128 liquidity,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice Emitted when liquidity is decreased
    event LiquidityDecreased(
        uint256 indexed tokenId,
        uint128 liquidity,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice Emitted when fees are collected
    event FeesCollected(
        uint256 indexed tokenId,
        address indexed recipient,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice Emitted when a position is burned
    event PositionBurned(uint256 indexed tokenId);
}
```

---

## 8. Error Definitions

### Core Errors

```solidity
interface ICoreErrors {
    /// @notice Pool has already been initialized
    error PoolAlreadyInitialized();

    /// @notice Pool has not been initialized
    error PoolNotInitialized();

    /// @notice Invalid pool key parameters
    error InvalidPoolKey();

    /// @notice Invalid tick range
    error InvalidTickRange(int24 tickLower, int24 tickUpper);

    /// @notice Tick spacing mismatch
    error TickSpacingMismatch(int24 expected, int24 actual);

    /// @notice Invalid sqrt price
    error InvalidSqrtPrice(uint160 sqrtPriceX96);

    /// @notice Insufficient liquidity for operation
    error InsufficientLiquidity();

    /// @notice Insufficient input amount
    error InsufficientInputAmount();

    /// @notice Insufficient output amount
    error InsufficientOutputAmount();

    /// @notice Price slippage exceeded
    error PriceSlippageExceeded(uint160 expected, uint160 actual);

    /// @notice Invalid sqrt price limit for swap direction
    error InvalidSqrtPriceLimit(uint160 sqrtPriceLimitX96);

    /// @notice Contract is locked
    error ContractLocked();

    /// @notice Only callable by locker
    error NotLocker();

    /// @notice Callback validation failed
    error InvalidCallback();

    /// @notice Token transfer failed
    error TransferFailed(address token);

    /// @notice Unauthorized caller
    error Unauthorized();

    /// @notice Invalid hook response
    error InvalidHookResponse();
}
```

### Position Manager Errors

```solidity
interface IPositionManagerErrors {
    /// @notice Position does not exist
    error PositionNotFound(uint256 tokenId);

    /// @notice Caller is not position owner
    error NotPositionOwner(uint256 tokenId, address caller);

    /// @notice Position still has liquidity
    error PositionNotEmpty(uint256 tokenId);

    /// @notice Deadline has passed
    error DeadlineExpired(uint256 deadline, uint256 currentTime);

    /// @notice Slippage tolerance exceeded
    error SlippageExceeded(
        uint256 amount0,
        uint256 amount0Min,
        uint256 amount1,
        uint256 amount1Min
    );

    /// @notice Invalid recipient address
    error InvalidRecipient();
}
```

### Router Errors

```solidity
interface IRouterErrors {
    /// @notice Insufficient output amount
    error InsufficientOutputAmount(uint256 amountOut, uint256 amountOutMinimum);

    /// @notice Excessive input amount
    error ExcessiveInputAmount(uint256 amountIn, uint256 amountInMaximum);

    /// @notice Invalid path
    error InvalidPath();

    /// @notice Deadline expired
    error DeadlineExpired(uint256 deadline);
}
```

---

## 9. Data Types

### PoolKey

```solidity
/// @notice Identifies a pool
struct PoolKey {
    /// @dev First token address (must be < token1)
    address token0;
    /// @dev Second token address
    address token1;
    /// @dev Fee tier in hundredths of a bip
    uint24 fee;
    /// @dev Tick spacing for the pool
    int24 tickSpacing;
    /// @dev Hook contract address (address(0) for no hooks)
    address hooks;
}
```

### BalanceDelta

```solidity
/// @notice Represents changes in token balances
struct BalanceDelta {
    int256 amount0;
    int256 amount1;
}
```

### Pool State

```solidity
/// @notice Complete pool state
struct PoolState {
    uint160 sqrtPriceX96;
    int24 tick;
    uint16 observationIndex;
    uint16 observationCardinality;
    uint16 observationCardinalityNext;
    uint8 feeProtocol;
    bool unlocked;
    uint128 liquidity;
    uint256 feeGrowthGlobal0X128;
    uint256 feeGrowthGlobal1X128;
    uint128 protocolFees0;
    uint128 protocolFees1;
}
```

---

## 10. Constants

```solidity
/// @notice Minimum tick value
int24 constant MIN_TICK = -887272;

/// @notice Maximum tick value
int24 constant MAX_TICK = 887272;

/// @notice Minimum sqrt price
uint160 constant MIN_SQRT_PRICE = 4295128739;

/// @notice Maximum sqrt price
uint160 constant MAX_SQRT_PRICE = 1461446703485210103287273052203988822378723970342;

/// @notice Fixed point Q96 multiplier
uint256 constant Q96 = 2**96;

/// @notice Fixed point Q128 multiplier
uint256 constant Q128 = 2**128;

/// @notice Fee denominator (1,000,000 = 100%)
uint24 constant FEE_DENOMINATOR = 1_000_000;

/// @notice Maximum protocol fee (50%)
uint8 constant MAX_PROTOCOL_FEE = 50;
```

---

## 11. Integration Examples

### Initialize a Pool

```solidity
PoolKey memory poolKey = PoolKey({
    token0: address(tokenA) < address(tokenB) ? address(tokenA) : address(tokenB),
    token1: address(tokenA) < address(tokenB) ? address(tokenB) : address(tokenA),
    fee: 3000, // 0.3%
    tickSpacing: 60,
    hooks: address(0)
});

uint160 sqrtPriceX96 = 79228162514264337593543950336; // 1:1 price
int24 tick = core.initialize(poolKey, sqrtPriceX96);
```

### Execute a Swap

```solidity
// Using the router
ExactInputSingleParams memory params = ExactInputSingleParams({
    tokenIn: address(tokenA),
    tokenOut: address(tokenB),
    fee: 3000,
    recipient: msg.sender,
    amountIn: 1 ether,
    amountOutMinimum: 0.99 ether,
    sqrtPriceLimitX96: 0
});

uint256 amountOut = router.exactInputSingle(params);
```

### Add Liquidity

```solidity
MintParams memory params = MintParams({
    poolKey: poolKey,
    tickLower: -887220,
    tickUpper: 887220,
    amount0Desired: 1 ether,
    amount1Desired: 1 ether,
    amount0Min: 0.99 ether,
    amount1Min: 0.99 ether,
    recipient: msg.sender,
    deadline: block.timestamp + 3600
});

(uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1) = 
    positionManager.mint(params);
```

### Get TWAP Price

```solidity
uint32[] memory secondsAgos = new uint32[](2);
secondsAgos[0] = 3600; // 1 hour ago
secondsAgos[1] = 0;    // now

(int56[] memory tickCumulatives,) = oracle.observe(poolKey, secondsAgos);

int56 tickDelta = tickCumulatives[1] - tickCumulatives[0];
int24 arithmeticMeanTick = int24(tickDelta / int56(uint56(3600)));
```

---

## 12. References

- [Ekubo Protocol Documentation](./README.md)
- [Integration Guide](./INTEGRATION_GUIDE.md)
- [Hooks Development Guide](./HOOKS_GUIDE.md)
- [Foundry Documentation](https://book.getfoundry.sh/)
- [Solidity Documentation](https://docs.soliditylang.org/)

---

**Last Updated:** December 7, 2025