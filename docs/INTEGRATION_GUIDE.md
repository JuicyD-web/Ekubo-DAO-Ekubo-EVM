# Integration Guide

Integration Guide for Ekubo Protocol EVM Implementation

---

## Overview

This guide explains how to integrate external applications, wallets, and protocols with Ekubo Protocol EVM smart contracts. It provides detailed examples for all common operations including swaps, liquidity management, and oracle queries.

All code examples reference actual contracts in the `src/` directory and their corresponding interfaces in `src/interfaces/`.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Contract Architecture](#2-contract-architecture)
3. [Getting Started](#3-getting-started)
4. [Core Contract Integration](#4-core-contract-integration)
5. [Swap Router Integration](#5-swap-router-integration)
6. [Position Manager Integration](#6-position-manager-integration)
7. [Quoter Integration](#7-quoter-integration)
8. [Oracle Integration](#8-oracle-integration)
9. [Hooks Integration](#9-hooks-integration)
10. [Advanced Patterns](#10-advanced-patterns)
11. [Error Handling](#11-error-handling)
12. [Security Considerations](#12-security-considerations)
13. [Gas Optimization](#13-gas-optimization)
14. [Event Monitoring](#14-event-monitoring)

---

## 1. Prerequisites

### Required Tools

| Tool | Purpose | Installation |
|------|---------|--------------|
| Node.js >= 18 | JavaScript runtime | [nodejs.org](https://nodejs.org) |
| ethers.js v6 | Ethereum library | `npm install ethers` |
| viem | Alternative library | `npm install viem` |
| TypeScript | Type safety | `npm install typescript` |
| Foundry | Build contracts | [getfoundry.sh](https://getfoundry.sh) |

### Required Knowledge

- Solidity smart contract basics
- ERC20 token standard
- Concentrated liquidity AMM concepts
- Transaction signing and gas management

### Build Contract ABIs

```bash
# Clone repository
git clone https://github.com/ekubo/ekubo-evm.git
cd ekubo-evm

# Build contracts
forge build

# ABIs will be in out/ directory
# out/Core.sol/Core.json
# out/SwapRouter.sol/SwapRouter.json
# out/PositionManager.sol/PositionManager.json
# etc.
```

### Contract Addresses

Find deployed contract addresses in the [Deployment Guide](./deployment-guide.md) or query the deployment registry:

```javascript
// Mainnet addresses (example)
const ADDRESSES = {
  core: "0x...",
  positionManager: "0x...",
  swapRouter: "0x...",
  quoter: "0x...",
  oracle: "0x...",
  weth: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
};
```

---

## 2. Contract Architecture

### Contract Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│                    Ekubo Protocol Architecture                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐       │
│  │ SwapRouter  │     │  Position   │     │   Quoter    │       │
│  │             │     │  Manager    │     │             │       │
│  └──────┬──────┘     └──────┬──────┘     └──────┬──────┘       │
│         │                   │                   │               │
│         │    ┌──────────────┴───────────────┐   │               │
│         │    │                              │   │               │
│         ▼    ▼                              ▼   ▼               │
│  ┌───────────────────────────────────────────────────┐         │
│  │                      Core                         │         │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐           │         │
│  │  │  Pools  │  │  Ticks  │  │Positions│           │         │
│  │  └─────────┘  └─────────┘  └─────────┘           │         │
│  └───────────────────────────────────────────────────┘         │
│         │                                                       │
│         ▼                                                       │
│  ┌───────────────────────────────────────────────────┐         │
│  │                     Hooks                         │         │
│  │  (Optional pool customization)                    │         │
│  └───────────────────────────────────────────────────┘         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Source File References

All contracts are located in the `src/` directory. Here's the complete mapping:

#### Main Contracts

| Contract | Source File | Description |
|----------|-------------|-------------|
| Core | `src/Core.sol` | Main pool logic, state management, and swap execution |
| PositionManager | `src/PositionManager.sol` | NFT-based liquidity position management (ERC721) |
| SwapRouter | `src/SwapRouter.sol` | User-friendly swap execution with routing |
| Quoter | `src/Quoter.sol` | Simulates swaps without execution for price quotes |
| Oracle | `src/Oracle.sol` | Time-weighted average price (TWAP) oracle |

#### Interface Files

All interfaces are in `src/interfaces/`:

| Interface | Source File | Description |
|-----------|-------------|-------------|
| ICore | `src/interfaces/ICore.sol` | Combined core contract interface |
| ICoreActions | `src/interfaces/ICoreActions.sol` | Core write functions (swap, updatePosition, flash, lock) |
| ICoreState | `src/interfaces/ICoreState.sol` | Core read functions (getSlot0, getLiquidity, getPosition) |
| ICoreEvents | `src/interfaces/ICoreEvents.sol` | Core event definitions |
| ICoreErrors | `src/interfaces/ICoreErrors.sol` | Core error definitions |
| IPositionManager | `src/interfaces/IPositionManager.sol` | Position manager interface |
| ISwapRouter | `src/interfaces/ISwapRouter.sol` | Swap router interface |
| IQuoter | `src/interfaces/IQuoter.sol` | Quoter interface |
| IOracle | `src/interfaces/IOracle.sol` | Oracle interface |
| IHooks | `src/interfaces/IHooks.sol` | Hook customization interface |

#### Callback Interfaces

Located in `src/interfaces/callbacks/`:

| Interface | Source File | Purpose |
|-----------|-------------|---------|
| ISwapCallback | `src/interfaces/callbacks/ISwapCallback.sol` | Callback for swap operations |
| IFlashCallback | `src/interfaces/callbacks/IFlashCallback.sol` | Callback for flash loans |
| ILockCallback | `src/interfaces/callbacks/ILockCallback.sol` | Callback for lock operations |
| IMintCallback | `src/interfaces/callbacks/IMintCallback.sol` | Callback for position minting |

#### Type Definitions

Located in `src/types/`:

| Type | Source File | Description |
|------|-------------|-------------|
| PoolKey | `src/types/PoolKey.sol` | Pool identifier structure |
| BalanceDelta | `src/types/BalanceDelta.sol` | Balance change representation |
| Position | `src/types/Position.sol` | Position data structure |
| TickInfo | `src/types/TickInfo.sol` | Tick state information |

#### Library Files

Located in `src/libraries/`:

| Library | Source File | Purpose |
|---------|-------------|---------|
| PoolMath | `src/libraries/PoolMath.sol` | Pool mathematics |
| TickMath | `src/libraries/TickMath.sol` | Tick calculations |
| SqrtPriceMath | `src/libraries/SqrtPriceMath.sol` | Square root price math |
| SwapMath | `src/libraries/SwapMath.sol` | Swap calculations |
| LiquidityMath | `src/libraries/LiquidityMath.sol` | Liquidity calculations |
| Position | `src/libraries/Position.sol` | Position management logic |
| Tick | `src/libraries/Tick.sol` | Tick management logic |
| Oracle | `src/libraries/Oracle.sol` | Oracle calculation logic |
| Hooks | `src/libraries/Hooks.sol` | Hook validation and execution |

---

## 3. Getting Started

### Installation

```bash
# Using npm
npm install ethers

# Using yarn
yarn add ethers

# Using pnpm
pnpm add ethers

# Build Ekubo contracts to get ABIs
cd ekubo-evm
forge build
```

### Basic Setup (ethers.js v6)

```typescript
import { ethers } from "ethers";
import { readFileSync } from "fs";

// Import ABIs from compiled artifacts
// These are generated by running `forge build`
const CoreABI = JSON.parse(readFileSync("out/Core.sol/Core.json", "utf8")).abi;
const SwapRouterABI = JSON.parse(readFileSync("out/SwapRouter.sol/SwapRouter.json", "utf8")).abi;
const PositionManagerABI = JSON.parse(readFileSync("out/PositionManager.sol/PositionManager.json", "utf8")).abi;
const QuoterABI = JSON.parse(readFileSync("out/Quoter.sol/Quoter.json", "utf8")).abi;
const OracleABI = JSON.parse(readFileSync("out/Oracle.sol/Oracle.json", "utf8")).abi;

// Provider setup
const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);

// Signer setup (for transactions)
const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

// Contract instances (use actual deployed addresses)
const ADDRESSES = {
  core: "0x...",
  swapRouter: "0x...",
  positionManager: "0x...",
  quoter: "0x...",
  oracle: "0x...",
};

const core = new ethers.Contract(ADDRESSES.core, CoreABI, signer);
const router = new ethers.Contract(ADDRESSES.swapRouter, SwapRouterABI, signer);
const positionManager = new ethers.Contract(ADDRESSES.positionManager, PositionManagerABI, signer);
const quoter = new ethers.Contract(ADDRESSES.quoter, QuoterABI, provider); // Read-only
const oracle = new ethers.Contract(ADDRESSES.oracle, OracleABI, provider); // Read-only
```

### Basic Setup (viem)

```typescript
import { createPublicClient, createWalletClient, http, getContract } from "viem";
import { mainnet } from "viem/chains";
import { privateKeyToAccount } from "viem/accounts";
import { readFileSync } from "fs";

// Import ABIs
const CoreABI = JSON.parse(readFileSync("out/Core.sol/Core.json", "utf8")).abi;
const SwapRouterABI = JSON.parse(readFileSync("out/SwapRouter.sol/SwapRouter.json", "utf8")).abi;
const PositionManagerABI = JSON.parse(readFileSync("out/PositionManager.sol/PositionManager.json", "utf8")).abi;

// Public client for reads
const publicClient = createPublicClient({
  chain: mainnet,
  transport: http(process.env.RPC_URL),
});

// Wallet client for writes
const account = privateKeyToAccount(process.env.PRIVATE_KEY as `0x${string}`);
const walletClient = createWalletClient({
  account,
  chain: mainnet,
  transport: http(process.env.RPC_URL),
});

// Contract instances
const core = getContract({
  address: ADDRESSES.core as `0x${string}`,
  abi: CoreABI,
  publicClient,
  walletClient,
});

const router = getContract({
  address: ADDRESSES.swapRouter as `0x${string}`,
  abi: SwapRouterABI,
  publicClient,
  walletClient,
});
```

---

## 4. Core Contract Integration

**Reference Contract:** `src/Core.sol`  
**Reference Interfaces:** `src/interfaces/ICore.sol`, `src/interfaces/ICoreActions.sol`, `src/interfaces/ICoreState.sol`

The Core contract is the central hub for all pool operations.

### Pool Key Structure

```typescript
// Reference: src/types/PoolKey.sol
interface PoolKey {
  token0: string;      // First token (must be < token1)
  token1: string;      // Second token
  fee: number;         // Fee tier in hundredths of a bip
  tickSpacing: number; // Tick spacing for the pool
  hooks: string;       // Hook contract (address(0) for none)
}
```

### Creating a Pool Key

```typescript
import { ethers } from "ethers";

// Reference: src/types/PoolKey.sol
function createPoolKey(
  tokenA: string,
  tokenB: string,
  fee: number,
  tickSpacing: number,
  hooks: string = ethers.ZeroAddress
): PoolKey {
  // Ensure token0 < token1 (required by Core.sol)
  const [token0, token1] = tokenA.toLowerCase() < tokenB.toLowerCase()
    ? [tokenA, tokenB]
    : [tokenB, tokenA];

  return {
    token0,
    token1,
    fee,
    tickSpacing,
    hooks,
  };
}

// Common fee tiers (from src/libraries/Fees.sol or similar)
const FEE_TIERS = {
  LOWEST: 100,    // 0.01%
  LOW: 500,       // 0.05%
  MEDIUM: 3000,   // 0.30%
  HIGH: 10000,    // 1.00%
};

const TICK_SPACINGS = {
  LOWEST: 1,
  LOW: 10,
  MEDIUM: 60,
  HIGH: 200,
};

// Example usage
const poolKey = createPoolKey(
  "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", // WETH
  "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", // USDC
  FEE_TIERS.MEDIUM,
  TICK_SPACINGS.MEDIUM
);
```

### Initialize a Pool

```typescript
// Reference: src/Core.sol - initialize() function
// Interface: src/interfaces/ICore.sol

async function initializePool(
  core: ethers.Contract,
  poolKey: PoolKey,
  initialPrice: bigint
): Promise<{ tick: number; txHash: string }> {
  // sqrtPriceX96 = sqrt(price) * 2^96
  // Reference: src/libraries/SqrtPriceMath.sol for price calculations
  const sqrtPriceX96 = initialPrice;

  const tx = await core.initialize(poolKey, sqrtPriceX96);
  const receipt = await tx.wait();

  // Parse PoolInitialized event (defined in src/interfaces/ICoreEvents.sol)
  const event = receipt.logs.find(
    (log: any) => log.topics[0] === core.interface.getEvent("PoolInitialized").topicHash
  );

  const decoded = core.interface.decodeEventLog("PoolInitialized", event.data, event.topics);

  return {
    tick: Number(decoded.tick),
    txHash: receipt.hash,
  };
}

// Helper: Calculate sqrtPriceX96 from price
// Reference: src/libraries/SqrtPriceMath.sol
function priceToSqrtPriceX96(price: number, decimals0: number, decimals1: number): bigint {
  const adjustedPrice = price * Math.pow(10, decimals1 - decimals0);
  const sqrtPrice = Math.sqrt(adjustedPrice);
  return BigInt(Math.floor(sqrtPrice * Math.pow(2, 96)));
}

// Example: Initialize ETH/USDC pool at $2000 per ETH
const sqrtPriceX96 = priceToSqrtPriceX96(2000, 18, 6);
await initializePool(core, poolKey, sqrtPriceX96);
```

### Reading Pool State

```typescript
// Reference: src/interfaces/ICoreState.sol - getSlot0(), getLiquidity(), etc.

async function getPoolState(core: ethers.Contract, poolKey: PoolKey) {
  // Get slot0 data (main pool state)
  // Reference: src/Core.sol - slot0 mapping
  const slot0 = await core.getSlot0(poolKey);
  const [
    sqrtPriceX96,
    tick,
    observationIndex,
    observationCardinality,
    observationCardinalityNext,
    feeProtocol,
    unlocked,
  ] = slot0;

  // Get current liquidity
  // Reference: src/Core.sol - liquidity mapping
  const liquidity = await core.getLiquidity(poolKey);

  // Get fee growth globals
  // Reference: src/Core.sol - feeGrowthGlobal0X128 and feeGrowthGlobal1X128
  const feeGrowth = await core.getFeeGrowthGlobals(poolKey);
  const [feeGrowthGlobal0X128, feeGrowthGlobal1X128] = feeGrowth;

  return {
    sqrtPriceX96,
    tick: Number(tick),
    liquidity,
    feeGrowthGlobal0X128,
    feeGrowthGlobal1X128,
    observationIndex: Number(observationIndex),
    observationCardinality: Number(observationCardinality),
    feeProtocol: Number(feeProtocol),
    unlocked,
  };
}

// Calculate price from sqrtPriceX96
// Reference: src/libraries/SqrtPriceMath.sol
function sqrtPriceX96ToPrice(sqrtPriceX96: bigint, decimals0: number, decimals1: number): number {
  const Q96 = 2n ** 96n;
  const sqrtPrice = Number(sqrtPriceX96) / Number(Q96);
  const price = sqrtPrice * sqrtPrice;
  return price * Math.pow(10, decimals0 - decimals1);
}
```

### Get Tick Information

```typescript
// Reference: src/interfaces/ICoreState.sol - getTickInfo()
// Returns: src/types/TickInfo.sol structure

async function getTickInfo(
  core: ethers.Contract,
  poolKey: PoolKey,
  tick: number
): Promise<{
  liquidityGross: bigint;
  liquidityNet: bigint;
  feeGrowthOutside0X128: bigint;
  feeGrowthOutside1X128: bigint;
  tickCumulativeOutside: bigint;
  secondsPerLiquidityOutsideX128: bigint;
  secondsOutside: number;
  initialized: boolean;
}> {
  const tickInfo = await core.getTickInfo(poolKey, tick);
  return {
    liquidityGross: tickInfo.liquidityGross,
    liquidityNet: tickInfo.liquidityNet,
    feeGrowthOutside0X128: tickInfo.feeGrowthOutside0X128,
    feeGrowthOutside1X128: tickInfo.feeGrowthOutside1X128,
    tickCumulativeOutside: tickInfo.tickCumulativeOutside,
    secondsPerLiquidityOutsideX128: tickInfo.secondsPerLiquidityOutsideX128,
    secondsOutside: Number(tickInfo.secondsOutside),
    initialized: tickInfo.initialized,
  };
}
```

### Get Position Information

```typescript
// Reference: src/interfaces/ICoreState.sol - getPosition()
// Returns: src/types/Position.sol structure

async function getPosition(
  core: ethers.Contract,
  poolKey: PoolKey,
  owner: string,
  tickLower: number,
  tickUpper: number,
  salt: string = ethers.ZeroHash
): Promise<{
  liquidity: bigint;
  feeGrowthInside0LastX128: bigint;
  feeGrowthInside1LastX128: bigint;
  tokensOwed0: bigint;
  tokensOwed1: bigint;
}> {
  const position = await core.getPosition(poolKey, owner, tickLower, tickUpper, salt);
  return {
    liquidity: position.liquidity,
    feeGrowthInside0LastX128: position.feeGrowthInside0LastX128,
    feeGrowthInside1LastX128: position.feeGrowthInside1LastX128,
    tokensOwed0: position.tokensOwed0,
    tokensOwed1: position.tokensOwed1,
  };
}
```

### Direct Position Update via Core (Advanced)

```typescript
// Reference: src/Core.sol - updatePosition() via lock()
// Interface: src/interfaces/ICoreActions.sol
// Most users should use PositionManager instead

interface UpdatePositionParams {
  tickLower: number;
  tickUpper: number;
  liquidityDelta: bigint; // int128
  salt: string; // bytes32
}

// This requires implementing ILockCallback
// Reference: src/interfaces/callbacks/ILockCallback.sol
async function updatePositionViaCore(
  core: ethers.Contract,
  poolKey: PoolKey,
  params: UpdatePositionParams
): Promise<{ amount0: bigint; amount1: bigint }> {
  // The lock() function provides reentrancy protection and atomicity
  // You need a contract that implements ILockCallback.lockAcquired()
  
  const callbackData = ethers.AbiCoder.defaultAbiCoder().encode(
    ["tuple(address,address,uint24,int24,address)", "tuple(int24,int24,int128,bytes32)"],
    [
      [poolKey.token0, poolKey.token1, poolKey.fee, poolKey.tickSpacing, poolKey.hooks],
      [params.tickLower, params.tickUpper, params.liquidityDelta, params.salt],
    ]
  );

  const result = await core.lock(callbackData);
  const decoded = ethers.AbiCoder.defaultAbiCoder().decode(["int256", "int256"], result);

  return {
    amount0: decoded[0],
    amount1: decoded[1],
  };
}
```

### Direct Swap via Core (Advanced)

```typescript
// Reference: src/Core.sol - swap() via lock()
// Interface: src/interfaces/ICoreActions.sol
// Most users should use SwapRouter instead

interface SwapParams {
  zeroForOne: boolean;
  amountSpecified: bigint; // int256 (negative for exact output)
  sqrtPriceLimitX96: bigint; // uint160
}

// This requires implementing ISwapCallback
// Reference: src/interfaces/callbacks/ISwapCallback.sol
async function swapViaCore(
  core: ethers.Contract,
  poolKey: PoolKey,
  params: SwapParams
): Promise<{ amount0: bigint; amount1: bigint }> {
  // You need a contract that implements ISwapCallback.swapCallback()
  
  const callbackData = ethers.AbiCoder.defaultAbiCoder().encode(
    ["tuple(address,address,uint24,int24,address)", "tuple(bool,int256,uint160)"],
    [
      [poolKey.token0, poolKey.token1, poolKey.fee, poolKey.tickSpacing, poolKey.hooks],
      [params.zeroForOne, params.amountSpecified, params.sqrtPriceLimitX96],
    ]
  );

  const result = await core.lock(callbackData);
  const decoded = ethers.AbiCoder.defaultAbiCoder().decode(["int256", "int256"], result);

  return {
    amount0: decoded[0],
    amount1: decoded[1],
  };
}
```

---

## 5. Swap Router Integration

**Reference Contract:** `src/SwapRouter.sol`  
**Reference Interface:** `src/interfaces/ISwapRouter.sol`

The SwapRouter provides a user-friendly interface for executing swaps.

### Single Pool Swap - Exact Input

```typescript
// Reference: src/SwapRouter.sol - exactInputSingle()
// Interface: src/interfaces/ISwapRouter.sol

interface ExactInputSingleParams {
  tokenIn: string;
  tokenOut: string;
  fee: number;
  recipient: string;
  amountIn: bigint;
  amountOutMinimum: bigint;
  sqrtPriceLimitX96: bigint;
}

async function swapExactInputSingle(
  router: ethers.Contract,
  tokenIn: ethers.Contract,
  params: ExactInputSingleParams
): Promise<{ amountOut: bigint; txHash: string }> {
  // 1. Approve router to spend tokens
  const allowance = await tokenIn.allowance(await router.signer.getAddress(), router.target);
  if (allowance < params.amountIn) {
    const approveTx = await tokenIn.approve(router.target, ethers.MaxUint256);
    await approveTx.wait();
  }

  // 2. Execute swap
  const tx = await router.exactInputSingle(params);
  const receipt = await tx.wait();

  // 3. Parse Swap event (from Core contract)
  // Reference: src/interfaces/ICoreEvents.sol
  const swapEvent = receipt.logs.find(
    (log: any) => {
      try {
        const parsed = router.interface.parseLog(log);
        return parsed?.name === "Swap";
      } catch {
        return false;
      }
    }
  );

  return {
    amountOut: 0n, // Parse from event or calculate from balance change
    txHash: receipt.hash,
  };
}

// Example usage
async function swapETHForUSDC(
  router: ethers.Contract,
  weth: ethers.Contract,
  amountIn: bigint,
  minAmountOut: bigint,
  recipient: string
) {
  const params: ExactInputSingleParams = {
    tokenIn: await weth.getAddress(),
    tokenOut: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", // USDC
    fee: 3000, // 0.3%
    recipient,
    amountIn,
    amountOutMinimum: minAmountOut,
    sqrtPriceLimitX96: 0n, // No price limit
  };

  return swapExactInputSingle(router, weth, params);
}
```

### Single Pool Swap - Exact Output

```typescript
// Reference: src/SwapRouter.sol - exactOutputSingle()
// Interface: src/interfaces/ISwapRouter.sol

interface ExactOutputSingleParams {
  tokenIn: string;
  tokenOut: string;
  fee: number;
  recipient: string;
  amountOut: bigint;
  amountInMaximum: bigint;
  sqrtPriceLimitX96: bigint;
}

async function swapExactOutputSingle(
  router: ethers.Contract,
  tokenIn: ethers.Contract,
  params: ExactOutputSingleParams
): Promise<{ amountIn: bigint; txHash: string }> {
  // 1. Approve maximum input amount
  const allowance = await tokenIn.allowance(await router.signer.getAddress(), router.target);
  if (allowance < params.amountInMaximum) {
    const approveTx = await tokenIn.approve(router.target, ethers.MaxUint256);
    await approveTx.wait();
  }

  // 2. Execute swap
  const tx = await router.exactOutputSingle(params);
  const receipt = await tx.wait();

  return {
    amountIn: 0n, // Parse from event
    txHash: receipt.hash,
  };
}
```

### Multi-Hop Swap

```typescript
// Reference: src/SwapRouter.sol - exactInput()
// Interface: src/interfaces/ISwapRouter.sol

interface ExactInputParams {
  path: string; // Encoded path
  recipient: string;
  amountIn: bigint;
  amountOutMinimum: bigint;
}

// Path encoding helper
// Path format: token0 (20 bytes) + fee (3 bytes) + token1 (20 bytes) + fee (3 bytes) + token2 (20 bytes) ...
function encodePath(tokens: string[], fees: number[]): string {
  if (tokens.length !== fees.length + 1) {
    throw new Error("Invalid path: tokens.length must equal fees.length + 1");
  }

  let encoded = tokens[0].toLowerCase().replace("0x", "");
  for (let i = 0; i < fees.length; i++) {
    // Encode fee as 3 bytes (24 bits)
    encoded += fees[i].toString(16).padStart(6, "0");
    encoded += tokens[i + 1].toLowerCase().replace("0x", "");
  }

  return "0x" + encoded;
}

async function swapExactInputMultiHop(
  router: ethers.Contract,
  tokenIn: ethers.Contract,
  params: ExactInputParams
): Promise<{ amountOut: bigint; txHash: string }> {
  // Approve
  await tokenIn.approve(router.target, params.amountIn);

  // Execute
  const tx = await router.exactInput(params);
  const receipt = await tx.wait();

  return {
    amountOut: 0n, // Parse from event
    txHash: receipt.hash,
  };
}

// Example: WETH -> USDC -> DAI swap
const path = encodePath(
  [
    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", // WETH
    "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", // USDC
    "0x6B175474E89094C44Da98b954EedeAC495271d0F", // DAI
  ],
  [3000, 500] // WETH-USDC 0.3%, USDC-DAI 0.05%
);
```

### ETH Swaps (with WETH wrapping)

```typescript
// Reference: src/SwapRouter.sol - Uses WETH internally for ETH handling

async function swapETHForTokens(
  router: ethers.Contract,
  tokenOut: string,
  fee: number,
  recipient: string,
  amountIn: bigint,
  amountOutMinimum: bigint
): Promise<{ amountOut: bigint; txHash: string }> {
  // Router automatically wraps ETH to WETH
  const wethAddress = await router.WETH9(); // or WETH() depending on implementation

  const params = {
    tokenIn: wethAddress,
    tokenOut,
    fee,
    recipient,
    amountIn,
    amountOutMinimum,
    sqrtPriceLimitX96: 0n,
  };

  // Send ETH with transaction
  const tx = await router.exactInputSingle(params, { value: amountIn });
  const receipt = await tx.wait();

  return {
    amountOut: 0n,
    txHash: receipt.hash,
  };
}

async function swapTokensForETH(
  router: ethers.Contract,
  tokenIn: ethers.Contract,
  fee: number,
  recipient: string,
  amountIn: bigint,
  amountOutMinimum: bigint
): Promise<{ amountOut: bigint; txHash: string }> {
  await tokenIn.approve(router.target, amountIn);

  const wethAddress = await router.WETH9();

  const params = {
    tokenIn: await tokenIn.getAddress(),
    tokenOut: wethAddress,
    fee,
    recipient: router.target, // Send to router first for unwrapping
    amountIn,
    amountOutMinimum,
    sqrtPriceLimitX96: 0n,
  };

  // If router supports multicall with unwrapWETH
  // Use multicall to swap then unwrap
  const swapCall = router.interface.encodeFunctionData("exactInputSingle", [params]);
  const unwrapCall = router.interface.encodeFunctionData("unwrapWETH9", [amountOutMinimum, recipient]);

  const tx = await router.multicall([swapCall, unwrapCall]);
  const receipt = await tx.wait();

  return {
    amountOut: 0n,
    txHash: receipt.hash,
  };
}
```

---

## 6. Position Manager Integration

**Reference Contract:** `src/PositionManager.sol`  
**Reference Interface:** `src/interfaces/IPositionManager.sol`

The PositionManager manages liquidity positions as ERC721 NFTs.

### Mint Position (Add Liquidity)

```typescript
// Reference: src/PositionManager.sol - mint()
// Interface: src/interfaces/IPositionManager.sol

interface MintParams {
  poolKey: PoolKey;
  tickLower: number;
  tickUpper: number;
  amount0Desired: bigint;
  amount1Desired: bigint;
  amount0Min: bigint;
  amount1Min: bigint;
  recipient: string;
  deadline: number;
}

async function mintPosition(
  positionManager: ethers.Contract,
  token0: ethers.Contract,
  token1: ethers.Contract,
  params: MintParams
): Promise<{
  tokenId: bigint;
  liquidity: bigint;
  amount0: bigint;
  amount1: bigint;
  txHash: string;
}> {
  // 1. Approve tokens
  await token0.approve(positionManager.target, params.amount0Desired);
  await token1.approve(positionManager.target, params.amount1Desired);

  // 2. Mint position
  const tx = await positionManager.mint(params);
  const receipt = await tx.wait();

  // 3. Parse PositionMinted event
  // Reference: src/interfaces/IPositionManager.sol events
  const event = receipt.logs.find(
    (log: any) => {
      try {
        const parsed = positionManager.interface.parseLog(log);
        return parsed?.name === "PositionMinted";
      } catch {
        return false;
      }
    }
  );

  const decoded = positionManager.interface.parseLog(event);

  return {
    tokenId: decoded.args.tokenId,
    liquidity: decoded.args.liquidity,
    amount0: decoded.args.amount0,
    amount1: decoded.args.amount1,
    txHash: receipt.hash,
  };
}

// Helper: Calculate tick from price
// Reference: src/libraries/TickMath.sol
function priceToTick(price: number, decimals0: number, decimals1: number): number {
  const adjustedPrice = price * Math.pow(10, decimals1 - decimals0);
  return Math.floor(Math.log(adjustedPrice) / Math.log(1.0001));
}

// Helper: Round tick to valid tick spacing
// Reference: Tick spacing must be a multiple defined in pool
function roundToTickSpacing(tick: number, tickSpacing: number): number {
  return Math.floor(tick / tickSpacing) * tickSpacing;
}

// Example: Add full-range liquidity
async function addFullRangeLiquidity(
  positionManager: ethers.Contract,
  token0: ethers.Contract,
  token1: ethers.Contract,
  fee: number,
  tickSpacing: number,
  amount0: bigint,
  amount1: bigint,
  recipient: string
) {
  // Reference: src/libraries/TickMath.sol - MIN_TICK and MAX_TICK constants
  const MIN_TICK = -887272;
  const MAX_TICK = 887272;

  const poolKey = createPoolKey(
    await token0.getAddress(),
    await token1.getAddress(),
    fee,
    tickSpacing
  );

  const params: MintParams = {
    poolKey,
    tickLower: roundToTickSpacing(MIN_TICK, tickSpacing),
    tickUpper: roundToTickSpacing(MAX_TICK, tickSpacing),
    amount0Desired: amount0,
    amount1Desired: amount1,
    amount0Min: (amount0 * 99n) / 100n, // 1% slippage
    amount1Min: (amount1 * 99n) / 100n,
    recipient,
    deadline: Math.floor(Date.now() / 1000) + 3600, // 1 hour
  };

  return mintPosition(positionManager, token0, token1, params);
}
```

### Increase Liquidity

```typescript
// Reference: src/PositionManager.sol - increaseLiquidity()
// Interface: src/interfaces/IPositionManager.sol

interface IncreaseLiquidityParams {
  tokenId: bigint;
  amount0Desired: bigint;
  amount1Desired: bigint;
  amount0Min: bigint;
  amount1Min: bigint;
  deadline: number;
}

async function increaseLiquidity(
  positionManager: ethers.Contract,
  token0: ethers.Contract,
  token1: ethers.Contract,
  params: IncreaseLiquidityParams
): Promise<{
  liquidity: bigint;
  amount0: bigint;
  amount1: bigint;
  txHash: string;
}> {
  // Approve tokens
  await token0.approve(positionManager.target, params.amount0Desired);
  await token1.approve(positionManager.target, params.amount1Desired);

  // Increase liquidity
  const tx = await positionManager.increaseLiquidity(params);
  const receipt = await tx.wait();

  // Parse LiquidityIncreased event
  const event = receipt.logs.find(
    (log: any) => {
      try {
        const parsed = positionManager.interface.parseLog(log);
        return parsed?.name === "LiquidityIncreased";
      } catch {
        return false;
      }
    }
  );

  const decoded = positionManager.interface.parseLog(event);

  return {
    liquidity: decoded.args.liquidity,
    amount0: decoded.args.amount0,
    amount1: decoded.args.amount1,
    txHash: receipt.hash,
  };
}
```

### Decrease Liquidity

```typescript
// Reference: src/PositionManager.sol - decreaseLiquidity()
// Interface: src/interfaces/IPositionManager.sol

interface DecreaseLiquidityParams {
  tokenId: bigint;
  liquidity: bigint; // uint128
  amount0Min: bigint;
  amount1Min: bigint;
  deadline: number;
}

async function decreaseLiquidity(
  positionManager: ethers.Contract,
  params: DecreaseLiquidityParams
): Promise<{
  amount0: bigint;
  amount1: bigint;
  txHash: string;
}> {
  const tx = await positionManager.decreaseLiquidity(params);
  const receipt = await tx.wait();

  const event = receipt.logs.find(
    (log: any) => {
      try {
        const parsed = positionManager.interface.parseLog(log);
        return parsed?.name === "LiquidityDecreased";
      } catch {
        return false;
      }
    }
  );

  const decoded = positionManager.interface.parseLog(event);

  return {
    amount0: decoded.args.amount0,
    amount1: decoded.args.amount1,
    txHash: receipt.hash,
  };
}
```

### Collect Fees

```typescript
// Reference: src/PositionManager.sol - collect()
// Interface: src/interfaces/IPositionManager.sol

interface CollectParams {
  tokenId: bigint;
  recipient: string;
  amount0Max: bigint; // uint128
  amount1Max: bigint; // uint128
}

async function collectFees(
  positionManager: ethers.Contract,
  params: CollectParams
): Promise<{
  amount0: bigint;
  amount1: bigint;
  txHash: string;
}> {
  const tx = await positionManager.collect(params);
  const receipt = await tx.wait();

  const event = receipt.logs.find(
    (log: any) => {
      try {
        const parsed = positionManager.interface.parseLog(log);
        return parsed?.name === "FeesCollected";
      } catch {
        return false;
      }
    }
  );

  const decoded = positionManager.interface.parseLog(event);

  return {
    amount0: decoded.args.amount0,
    amount1: decoded.args.amount1,
    txHash: receipt.hash,
  };
}

// Collect all fees (use uint128 max)
async function collectAllFees(
  positionManager: ethers.Contract,
  tokenId: bigint,
  recipient: string
) {
  const MAX_UINT128 = BigInt("0xffffffffffffffffffffffffffffffff");
  
  return collectFees(positionManager, {
    tokenId,
    recipient,
    amount0Max: MAX_UINT128,
    amount1Max: MAX_UINT128,
  });
}
```

### Burn Position

```typescript
// Reference: src/PositionManager.sol - burn()
// Interface: src/interfaces/IPositionManager.sol

async function burnPosition(
  positionManager: ethers.Contract,
  tokenId: bigint
): Promise<{ txHash: string }> {
  // Position must have zero liquidity and zero tokens owed
  const position = await positionManager.positions(tokenId);

  if (position.liquidity > 0n) {
    throw new Error("Position still has liquidity. Decrease liquidity first.");
  }

  if (position.tokensOwed0 > 0n || position.tokensOwed1 > 0n) {
    throw new Error("Position has uncollected fees. Collect fees first.");
  }

  const tx = await positionManager.burn(tokenId);
  const receipt = await tx.wait();

  return { txHash: receipt.hash };
}

// Full position close: decrease all liquidity, collect, burn
async function closePosition(
  positionManager: ethers.Contract,
  tokenId: bigint,
  recipient: string
): Promise<void> {
  const position = await positionManager.positions(tokenId);

  // 1. Decrease all liquidity
  if (position.liquidity > 0n) {
    await decreaseLiquidity(positionManager, {
      tokenId,
      liquidity: position.liquidity,
      amount0Min: 0n,
      amount1Min: 0n,
      deadline: Math.floor(Date.now() / 1000) + 3600,
    });
  }

  // 2. Collect all tokens
  await collectAllFees(positionManager, tokenId, recipient);

  // 3. Burn NFT
  await burnPosition(positionManager, tokenId);
}
```

### Read Position Data

```typescript
// Reference: src/PositionManager.sol - positions() view function
// Interface: src/interfaces/IPositionManager.sol
// Returns: Position struct from src/types/Position.sol

interface Position {
  nonce: bigint;
  operator: string;
  poolKey: PoolKey;
  tickLower: number;
  tickUpper: number;
  liquidity: bigint;
  feeGrowthInside0LastX128: bigint;
  feeGrowthInside1LastX128: bigint;
  tokensOwed0: bigint;
  tokensOwed1: bigint;
}

async function getPosition(
  positionManager: ethers.Contract,
  tokenId: bigint
): Promise<Position> {
  const position = await positionManager.positions(tokenId);
  
  return {
    nonce: position.nonce,
    operator: position.operator,
    poolKey: position.poolKey,
    tickLower: Number(position.tickLower),
    tickUpper: Number(position.tickUpper),
    liquidity: position.liquidity,
    feeGrowthInside0LastX128: position.feeGrowthInside0LastX128,
    feeGrowthInside1LastX128: position.feeGrowthInside1LastX128,
    tokensOwed0: position.tokensOwed0,
    tokensOwed1: position.tokensOwed1,
  };
}

// Get all positions for an owner (using ERC721Enumerable if implemented)
async function getPositionsByOwner(
  positionManager: ethers.Contract,
  owner: string
): Promise<bigint[]> {
  const balance = await positionManager.balanceOf(owner);
  const tokenIds: bigint[] = [];

  for (let i = 0n; i < balance; i++) {
    const tokenId = await positionManager.tokenOfOwnerByIndex(owner, i);
    tokenIds.push(tokenId);
  }

  return tokenIds;
}
```

---

## 7. Quoter Integration

**Reference Contract:** `src/Quoter.sol`  
**Reference Interface:** `src/interfaces/IQuoter.sol`

The Quoter simulates swaps without executing them, useful for getting price quotes and gas estimates.

### Quote Exact Input Single

```typescript
// Reference: src/Quoter.sol - quoteExactInputSingle()
// Interface: src/interfaces/IQuoter.sol

interface QuoteExactInputSingleParams {
  tokenIn: string;
  tokenOut: string;
  fee: number;
  amountIn: bigint;
  sqrtPriceLimitX96: bigint;
}

interface QuoteResult {
  amountOut: bigint;
  sqrtPriceX96After: bigint;
  tickAfter: number;
  gasEstimate: bigint;
}

async function quoteExactInputSingle(
  quoter: ethers.Contract,
  params: QuoteExactInputSingleParams
): Promise<QuoteResult> {
  // Use staticCall to simulate without gas cost
  const result = await quoter.quoteExactInputSingle.staticCall(params);

  return {
    amountOut: result.amountOut,
    sqrtPriceX96After: result.sqrtPriceX96After,
    tickAfter: Number(result.tickAfter),
    gasEstimate: result.gasEstimate,
  };
}

// Example usage: Get swap quote
async function getSwapQuote(
  quoter: ethers.Contract,
  tokenIn: string,
  tokenOut: string,
  amountIn: bigint
): Promise<bigint> {
  const result = await quoteExactInputSingle(quoter, {
    tokenIn,
    tokenOut,
    fee: 3000, // 0.3%
    amountIn,
    sqrtPriceLimitX96: 0n, // No price limit
  });

  return result.amountOut;
}
```

### Quote Exact Output Single

```typescript
// Reference: src/Quoter.sol - quoteExactOutputSingle()
// Interface: src/interfaces/IQuoter.sol

interface QuoteExactOutputSingleParams {
  tokenIn: string;
  tokenOut: string;
  fee: number;
  amountOut: bigint;
  sqrtPriceLimitX96: bigint;
}

async function quoteExactOutputSingle(
  quoter: ethers.Contract,
  params: QuoteExactOutputSingleParams
): Promise<{
  amountIn: bigint;
  sqrtPriceX96After: bigint;
  tickAfter: number;
  gasEstimate: bigint;
}> {
  const result = await quoter.quoteExactOutputSingle.staticCall(params);

  return {
    amountIn: result.amountIn,
    sqrtPriceX96After: result.sqrtPriceX96After,
    tickAfter: Number(result.tickAfter),
    gasEstimate: result.gasEstimate,
  };
}
```

### Quote Multi-Hop

```typescript
// Reference: src/Quoter.sol - quoteExactInput(), quoteExactOutput()
// Interface: src/interfaces/IQuoter.sol

interface QuoteExactInputParams {
  path: string; // Encoded path
  amountIn: bigint;
}

async function quoteExactInput(
  quoter: ethers.Contract,
  params: QuoteExactInputParams
): Promise<{
  amountOut: bigint;
  sqrtPriceX96AfterList: bigint[];
  tickAfterList: number[];
  gasEstimate: bigint;
}> {
  const result = await quoter.quoteExactInput.staticCall(params);

  return {
    amountOut: result.amountOut,
    sqrtPriceX96AfterList: result.sqrtPriceX96AfterList,
    tickAfterList: result.tickAfterList.map((t: any) => Number(t)),
    gasEstimate: result.gasEstimate,
  };
}

// Example: Quote multi-hop swap
async function getMultiHopQuote(
  quoter: ethers.Contract,
  tokens: string[],
  fees: number[],
  amountIn: bigint
): Promise<bigint> {
  const path = encodePath(tokens, fees);
  const result = await quoteExactInput(quoter, { path, amountIn });
  return result.amountOut;
}
```

### Price Impact Calculation

```typescript
// Reference: src/libraries/SqrtPriceMath.sol for price conversions

async function calculatePriceImpact(
  quoter: ethers.Contract,
  core: ethers.Contract,
  poolKey: PoolKey,
  amountIn: bigint,
  zeroForOne: boolean
): Promise<number> {
  // Get current price
  const slot0 = await core.getSlot0(poolKey);
  const sqrtPriceX96Before = slot0[0];

  // Get quote for swap
  const quote = await quoteExactInputSingle(quoter, {
    tokenIn: zeroForOne ? poolKey.token0 : poolKey.token1,
    tokenOut: zeroForOne ? poolKey.token1 : poolKey.token0,
    fee: poolKey.fee,
    amountIn,
    sqrtPriceLimitX96: 0n,
  });

  // Calculate price impact
  const sqrtPriceX96After = quote.sqrtPriceX96After;

  // Convert sqrtPriceX96 to actual price
  // Reference: src/libraries/SqrtPriceMath.sol
  const Q96 = 2n ** 96n;
  const priceBefore = Number(sqrtPriceX96Before) ** 2 / Number(Q96) ** 2;
  const priceAfter = Number(sqrtPriceX96After) ** 2 / Number(Q96) ** 2;

  const priceImpact = Math.abs((priceAfter - priceBefore) / priceBefore) * 100;

  return priceImpact;
}
```

---

## 8. Oracle Integration

**Reference Contract:** `src/Oracle.sol`  
**Reference Interface:** `src/interfaces/IOracle.sol`  
**Reference Library:** `src/libraries/Oracle.sol`

The Oracle provides time-weighted average prices (TWAP).

### Get TWAP

```typescript
// Reference: src/Oracle.sol - observe()
// Interface: src/interfaces/IOracle.sol
// Math: src/libraries/Oracle.sol

async function getTWAP(
  oracle: ethers.Contract,
  poolKey: PoolKey,
  secondsAgo: number
): Promise<{
  arithmeticMeanTick: number;
  harmonicMeanLiquidity: bigint;
}> {
  // Request observations for [secondsAgo, 0] (past and present)
  const secondsAgos = [secondsAgo, 0];

  const result = await oracle.observe(poolKey, secondsAgos);
  const tickCumulatives = result[0];
  const secondsPerLiquidityCumulativeX128s = result[1];

  // Calculate arithmetic mean tick
  const tickDelta = tickCumulatives[1] - tickCumulatives[0];
  const arithmeticMeanTick = Math.floor(Number(tickDelta) / secondsAgo);

  // Calculate harmonic mean liquidity
  // Reference: src/libraries/Oracle.sol for liquidity calculation
  const secondsPerLiquidityDelta =
    secondsPerLiquidityCumulativeX128s[1] - secondsPerLiquidityCumulativeX128s[0];

  const Q128 = 2n ** 128n;
  const harmonicMeanLiquidity =
    secondsPerLiquidityDelta > 0n
      ? (BigInt(secondsAgo) * Q128) / secondsPerLiquidityDelta
      : 0n;

  return { arithmeticMeanTick, harmonicMeanLiquidity };
}

// Convert tick to price
// Reference: src/libraries/TickMath.sol
function tickToPrice(tick: number, decimals0: number, decimals1: number): number {
  const price = Math.pow(1.0001, tick);
  return price * Math.pow(10, decimals0 - decimals1);
}

// Example: Get 1-hour TWAP price
async function getHourlyTWAPPrice(
  oracle: ethers.Contract,
  poolKey: PoolKey,
  decimals0: number,
  decimals1: number
): Promise<number> {
  const { arithmeticMeanTick } = await getTWAP(oracle, poolKey, 3600);
  return tickToPrice(arithmeticMeanTick, decimals0, decimals1);
}
```

### Increase Observation Cardinality

```typescript
// Reference: src/Oracle.sol - increaseObservationCardinalityNext()
// Interface: src/interfaces/IOracle.sol

async function increaseCardinality(
  oracle: ethers.Contract,
  poolKey: PoolKey,
  cardinality: number
): Promise<{ txHash: string }> {
  const tx = await oracle.increaseObservationCardinalityNext(poolKey, cardinality);
  const receipt = await tx.wait();

  return { txHash: receipt.hash };
}

// Example: Increase to support 24-hour TWAP with 10-minute granularity
// 24 hours / 10 minutes = 144 observations
await increaseCardinality(oracle, poolKey, 144);
```

### Historical Observations

```typescript
// Reference: src/Oracle.sol - getObservation()
// Interface: src/interfaces/IOracle.sol
// Storage: src/Core.sol - observations array

interface Observation {
  blockTimestamp: number;
  tickCumulative: bigint;
  secondsPerLiquidityCumulativeX128: bigint;
  initialized: boolean;
}

async function getObservation(
  oracle: ethers.Contract,
  poolKey: PoolKey,
  index: number
): Promise<Observation> {
  const observation = await oracle.getObservation(poolKey, index);
  
  return {
    blockTimestamp: Number(observation.blockTimestamp),
    tickCumulative: observation.tickCumulative,
    secondsPerLiquidityCumulativeX128: observation.secondsPerLiquidityCumulativeX128,
    initialized: observation.initialized,
  };
}

// Get multiple time-point prices
async function getHistoricalPrices(
  oracle: ethers.Contract,
  poolKey: PoolKey,
  timePoints: number[], // Array of seconds ago
  decimals0: number,
  decimals1: number
): Promise<{ timestamp: number; price: number }[]> {
  const results: { timestamp: number; price: number }[] = [];
  const now = Math.floor(Date.now() / 1000);

  for (let i = 0; i < timePoints.length - 1; i++) {
    const period = timePoints[i] - timePoints[i + 1];
    const twap = await getTWAP(oracle, poolKey, period);
    const price = tickToPrice(twap.arithmeticMeanTick, decimals0, decimals1);

    results.push({
      timestamp: now - timePoints[i],
      price,
    });
  }

  return results;
}
```

---

## 9. Hooks Integration

**Reference Interface:** `src/interfaces/IHooks.sol`  
**Reference Library:** `src/libraries/Hooks.sol`

Hooks allow custom logic to be executed during pool operations.

### Hook Flags

```typescript
// Reference: src/libraries/Hooks.sol - Hook flag constants

const HOOK_FLAGS = {
  BEFORE_INITIALIZE: 1n << 0n,
  AFTER_INITIALIZE: 1n << 1n,
  BEFORE_SWAP: 1n << 2n,
  AFTER_SWAP: 1n << 3n,
  BEFORE_MODIFY_POSITION: 1n << 4n,
  AFTER_MODIFY_POSITION: 1n << 5n,
  BEFORE_DONATE: 1n << 6n,
  AFTER_DONATE: 1n << 7n,
};

// Hook flags are encoded in the address itself
// Reference: src/libraries/Hooks.sol - validateHookAddress()
function getHookFlags(hookAddress: string): bigint {
  const addressBigInt = BigInt(hookAddress);
  return addressBigInt & 0xffn; // Last byte contains flags
}

function hasBeforeSwap(hookAddress: string): boolean {
  return (getHookFlags(hookAddress) & HOOK_FLAGS.BEFORE_SWAP) !== 0n;
}

function hasAfterSwap(hookAddress: string): boolean {
  return (getHookFlags(hookAddress) & HOOK_FLAGS.AFTER_SWAP) !== 0n;
}
```

### Using Pools with Hooks

```typescript
// Reference: src/Core.sol - initialize() with hooks parameter

async function createPoolWithHook(
  core: ethers.Contract,
  token0: string,
  token1: string,
  fee: number,
  tickSpacing: number,
  hookAddress: string,
  sqrtPriceX96: bigint
): Promise<{ tick: number; txHash: string }> {
  const poolKey = createPoolKey(token0, token1, fee, tickSpacing, hookAddress);

  const tx = await core.initialize(poolKey, sqrtPriceX96);
  const receipt = await tx.wait();

  const event = receipt.logs.find(
    (log: any) => {
      try {
        const parsed = core.interface.parseLog(log);
        return parsed?.name === "PoolInitialized";
      } catch {
        return false;
      }
    }
  );

  const decoded = core.interface.parseLog(event);

  return {
    tick: Number(decoded.args.tick),
    txHash: receipt.hash,
  };
}
```

### Implementing a Hook Contract

```solidity
// Example hook implementation
// Reference: src/interfaces/IHooks.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IHooks} from "./interfaces/IHooks.sol";
import {PoolKey} from "./types/PoolKey.sol";
import {BalanceDelta} from "./types/BalanceDelta.sol";

contract ExampleHook is IHooks {
    // beforeSwap is called before every swap
    // Reference: src/interfaces/IHooks.sol
    function beforeSwap(
        address sender,
        PoolKey calldata poolKey,
        SwapParams calldata params,
        bytes calldata hookData
    ) external override returns (bytes4, BalanceDelta) {
        // Custom logic before swap
        // For example: take a fee, check whitelist, etc.
        
        // Return selector to confirm execution
        return (IHooks.beforeSwap.selector, BalanceDelta(0, 0));
    }

    // afterSwap is called after every swap
    function afterSwap(
        address sender,
        PoolKey calldata poolKey,
        SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external override returns (bytes4, BalanceDelta) {
        // Custom logic after swap
        // For example: distribute rewards, update state, etc.
        
        return (IHooks.afterSwap.selector, BalanceDelta(0, 0));
    }
    
    // Implement other hook functions as needed...
}
```

---

## 10. Advanced Patterns

### Multicall

```typescript
// Reference: Many contracts inherit Multicall functionality
// Common pattern in src/PositionManager.sol, src/SwapRouter.sol

async function executeMulticall(
  contract: ethers.Contract,
  calls: string[]
): Promise<string[]> {
  const tx = await contract.multicall(calls);
  const receipt = await tx.wait();

  // Decode results
  return receipt.returnData || [];
}

// Example: Decrease liquidity + collect in one transaction
async function decreaseAndCollect(
  positionManager: ethers.Contract,
  tokenId: bigint,
  liquidity: bigint,
  recipient: string
): Promise<{ txHash: string }> {
  const decreaseCall = positionManager.interface.encodeFunctionData("decreaseLiquidity", [
    {
      tokenId,
      liquidity,
      amount0Min: 0n,
      amount1Min: 0n,
      deadline: Math.floor(Date.now() / 1000) + 3600,
    },
  ]);

  const collectCall = positionManager.interface.encodeFunctionData("collect", [
    {
      tokenId,
      recipient,
      amount0Max: BigInt("0xffffffffffffffffffffffffffffffff"),
      amount1Max: BigInt("0xffffffffffffffffffffffffffffffff"),
    },
  ]);

  const tx = await positionManager.multicall([decreaseCall, collectCall]);
  const receipt = await tx.wait();

  return { txHash: receipt.hash };
}
```

### Flash Loans

```typescript
// Reference: src/Core.sol - flash()
interface FlashParams {
  recipient: string;
  token0: string;
  token1: string;
  amount0: bigint;
  amount1: bigint;
  data: string;
}

// Flash loan callback contract must implement IFlashCallback
// Reference: src/interfaces/callbacks/IFlashCallback.sol

// Example flash loan executor contract
const flashExecutorCode = `
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IFlashCallback} from "./interfaces/callbacks/IFlashCallback.sol";
import {ICore} from "./interfaces/ICore.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashExecutor is IFlashCallback {
    ICore public immutable core;
    
    constructor(address _core) {
        core = ICore(_core);
    }
    
    function executeFlash(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external {
        core.flash(address(this), token0, token1, amount0, amount1, data);
    }
    
    function flashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external override {
        require(msg.sender == address(core), "Unauthorized");
        
        // Decode data and perform arbitrage/liquidation/etc
        (address token0, address token1, uint256 amount0, uint256 amount1) = 
            abi.decode(data, (address, address, uint256, uint256));
        
        // ... perform operations ...
        
        // Repay flash loan with fees
        if (amount0 > 0) {
            IERC20(token0).transfer(address(core), amount0 + fee0);
        }
        if (amount1 > 0) {
            IERC20(token1).transfer(address(core), amount1 + fee1);
        }
    }
}
`;
```

### Just-In-Time Liquidity

```typescript
// JIT liquidity: Add liquidity just before a swap, remove after
async function executeJIT(
  positionManager: ethers.Contract,
  router: ethers.Contract,
  poolKey: PoolKey,
  currentTick: number,
  tickSpacing: number,
  amount0: bigint,
  amount1: bigint,
  swapParams: ExactInputSingleParams
): Promise<void> {
  // Calculate tight tick range around current tick
  const tickLower = roundToTickSpacing(currentTick - tickSpacing, tickSpacing);
  const tickUpper = roundToTickSpacing(currentTick + tickSpacing, tickSpacing);

  // Use multicall for atomic execution (if supported)
  // Or use a custom contract for atomicity

  // 1. Mint position
  const mintParams: MintParams = {
    poolKey,
    tickLower,
    tickUpper,
    amount0Desired: amount0,
    amount1Desired: amount1,
    amount0Min: 0n,
    amount1Min: 0n,
    recipient: await positionManager.signer.getAddress(),
    deadline: Math.floor(Date.now() / 1000) + 60,
  };

  // This would need to be atomic in a real implementation
  // Using a custom contract or flashbots bundle
}
```

---

## 11. Error Handling

### Common Errors

```typescript
// Reference: src/interfaces/ICoreErrors.sol
const ERRORS = {
  PoolNotInitialized: "Pool has not been initialized",
  PoolAlreadyInitialized: "Pool already exists",
  InvalidTickRange: "Tick range is invalid",
  InsufficientLiquidity: "Not enough liquidity for swap",
  PriceSlippageExceeded: "Price moved beyond slippage tolerance",
  DeadlineExpired: "Transaction deadline has passed",
  InsufficientInputAmount: "Input amount too low",
  InsufficientOutputAmount: "Output amount below minimum",
};

async function handleSwapError(error: any): Promise<never> {
  const errorMessage = error.message || "";

  if (errorMessage.includes("InsufficientOutputAmount")) {
    throw new Error("Slippage tolerance exceeded. Try increasing slippage or reducing amount.");
  }

  if (errorMessage.includes("DeadlineExpired")) {
    throw new Error("Transaction took too long. Please try again.");
  }

  if (errorMessage.includes("InsufficientLiquidity")) {
    throw new Error("Not enough liquidity in pool. Try a smaller amount or different route.");
  }

  if (errorMessage.includes("PriceSlippageExceeded")) {
    throw new Error("Price moved too much. Increase slippage tolerance.");
  }

  throw error;
}

// Wrapper for safe execution
async function safeSwap(
  router: ethers.Contract,
  params: ExactInputSingleParams
): Promise<{ success: boolean; amountOut?: bigint; error?: string }> {
  try {
    const tx = await router.exactInputSingle(params);
    const receipt = await tx.wait();

    return {
      success: true,
      amountOut: 0n, // Parse from event
    };
  } catch (error: any) {
    return {
      success: false,
      error: error.message,
    };
  }
}
```

### Transaction Simulation

```typescript
async function simulateSwap(
  router: ethers.Contract,
  params: ExactInputSingleParams
): Promise<{ success: boolean; error?: string }> {
  try {
    await router.exactInputSingle.staticCall(params);
    return { success: true };
  } catch (error: any) {
    return {
      success: false,
      error: error.message,
    };
  }
}
```

---

## 12. Security Considerations

### Input Validation

```typescript
function validateSwapParams(params: ExactInputSingleParams): void {
  // Check addresses
  if (params.tokenIn === ethers.ZeroAddress) {
    throw new Error("Invalid tokenIn address");
  }
  if (params.tokenOut === ethers.ZeroAddress) {
    throw new Error("Invalid tokenOut address");
  }
  if (params.tokenIn === params.tokenOut) {
    throw new Error("tokenIn and tokenOut must be different");
  }

  // Check amounts
  if (params.amountIn <= 0n) {
    throw new Error("amountIn must be positive");
  }
  if (params.amountOutMinimum < 0n) {
    throw new Error("amountOutMinimum cannot be negative");
  }

  // Check deadline
  if (params.deadline && params.deadline < Math.floor(Date.now() / 1000)) {
    throw new Error("Deadline has already passed");
  }

  // Validate fee tier
  const validFees = [100, 500, 3000, 10000];
  if (!validFees.includes(params.fee)) {
    throw new Error("Invalid fee tier");
  }
}
```

### Slippage Protection

```typescript
function calculateMinOutput(
  expectedOutput: bigint,
  slippageBps: number // Basis points (100 = 1%)
): bigint {
  const slippageFactor = 10000n - BigInt(slippageBps);
  return (expectedOutput * slippageFactor) / 10000n;
}

function calculateMaxInput(
  expectedInput: bigint,
  slippageBps: number
): bigint {
  const slippageFactor = 10000n + BigInt(slippageBps);
  return (expectedInput * slippageFactor) / 10000n;
}

// Example usage
async function swapWithSlippageProtection(
  router: ethers.Contract,
  quoter: ethers.Contract,
  tokenIn: ethers.Contract,
  params: Omit<ExactInputSingleParams, "amountOutMinimum">,
  slippageBps: number = 50 // 0.5% default
): Promise<{ amountOut: bigint; txHash: string }> {
  // Get quote first
  const quote = await quoteExactInputSingle(quoter, {
    tokenIn: params.tokenIn,
    tokenOut: params.tokenOut,
    fee: params.fee,
    amountIn: params.amountIn,
    sqrtPriceLimitX96: params.sqrtPriceLimitX96,
  });

  // Calculate minimum output with slippage
  const amountOutMinimum = calculateMinOutput(quote.amountOut, slippageBps);

  // Execute swap
  return swapExactInputSingle(router, tokenIn, {
    ...params,
    amountOutMinimum,
  });
}
```

### Deadline Management

```typescript
function getDeadline(minutesFromNow: number = 20): number {
  return Math.floor(Date.now() / 1000) + minutesFromNow * 60;
}

// For mainnet, use shorter deadlines
function getMainnetDeadline(): number {
  return getDeadline(10); // 10 minutes
}

// For L2s, can use longer deadlines
function getL2Deadline(): number {
  return getDeadline(30); // 30 minutes
}
```

---

## 13. Gas Optimization

### Efficient Token Approval

```typescript
// Use infinite approval to save gas on repeated swaps
async function ensureApproval(
  token: ethers.Contract,
  spender: string,
  amount: bigint
): Promise<void> {
  const owner = await token.signer.getAddress();
  const currentAllowance = await token.allowance(owner, spender);

  if (currentAllowance < amount) {
    // Use max approval to avoid future approvals
    const tx = await token.approve(spender, ethers.MaxUint256);
    await tx.wait();
  }
}

// Or use permit for gasless approvals (if supported)
async function permitApproval(
  token: ethers.Contract,
  owner: string,
  spender: string,
  value: bigint,
  deadline: number,
  v: number,
  r: string,
  s: string
): Promise<void> {
  const tx = await token.permit(owner, spender, value, deadline, v, r, s);
  await tx.wait();
}
```

### Batch Operations

```typescript
// Batch multiple position operations
async function batchCollectFees(
  positionManager: ethers.Contract,
  tokenIds: bigint[],
  recipient: string
): Promise<{ txHash: string }> {
  const calls = tokenIds.map((tokenId) =>
    positionManager.interface.encodeFunctionData("collect", [
      {
        tokenId,
        recipient,
        amount0Max: BigInt("0xffffffffffffffffffffffffffffffff"),
        amount1Max: BigInt("0xffffffffffffffffffffffffffffffff"),
      },
    ])
  );

  const tx = await positionManager.multicall(calls);
  const receipt = await tx.wait();

  return { txHash: receipt.hash };
}
```

### Gas Estimation

```typescript
async function estimateSwapGas(
  router: ethers.Contract,
  params: ExactInputSingleParams
): Promise<bigint> {
  const gasEstimate = await router.exactInputSingle.estimateGas(params);
  return gasEstimate;
}

async function getOptimalGasPrice(provider: ethers.Provider): Promise<{
  maxFeePerGas: bigint;
  maxPriorityFeePerGas: bigint;
}> {
  const feeData = await provider.getFeeData();

  return {
    maxFeePerGas: feeData.maxFeePerGas || 0n,
    maxPriorityFeePerGas: feeData.maxPriorityFeePerGas || 0n,
  };
}
```

---

## 14. Event Monitoring

### Listening to Events

```typescript
// Reference: src/interfaces/ICoreEvents.sol
async function monitorSwaps(
  core: ethers.Contract,
  poolKey: PoolKey,
  callback: (event: any) => void
): Promise<void> {
  const poolId = ethers.keccak256(
    ethers.AbiCoder.defaultAbiCoder().encode(
      ["address", "address", "uint24", "int24", "address"],
      [poolKey.token0, poolKey.token1, poolKey.fee, poolKey.tickSpacing, poolKey.hooks]
    )
  );

  core.on("Swap", (poolIdEvent, sender, amount0, amount1, sqrtPriceX96, liquidity, tick, event) => {
    if (poolIdEvent === poolId) {
      callback({
        poolId: poolIdEvent,
        sender,
        amount0,
        amount1,
        sqrtPriceX96,
        liquidity,
        tick,
        transactionHash: event.transactionHash,
        blockNumber: event.blockNumber,
      });
    }
  });
}

// Historical events
async function getSwapHistory(
  core: ethers.Contract,
  poolKey: PoolKey,
  fromBlock: number,
  toBlock: number
): Promise<any[]> {
  const poolId = ethers.keccak256(
    ethers.AbiCoder.defaultAbiCoder().encode(
      ["address", "address", "uint24", "int24", "address"],
      [poolKey.token0, poolKey.token1, poolKey.fee, poolKey.tickSpacing, poolKey.hooks]
    )
  );

  const filter = core.filters.Swap(poolId);
  const events = await core.queryFilter(filter, fromBlock, toBlock);

  return events.map((event) => ({
    poolId: event.args?.poolId,
    sender: event.args?.sender,
    amount0: event.args?.amount0,
    amount1: event.args?.amount1,
    sqrtPriceX96: event.args?.sqrtPriceX96,
    liquidity: event.args?.liquidity,
    tick: event.args?.tick,
    transactionHash: event.transactionHash,
    blockNumber: event.blockNumber,
  }));
}
```