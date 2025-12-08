# Architecture Documentation

Technical architecture of the Ekubo Protocol EVM implementation.

---

## Overview

This is an EVM-compatible implementation of the Ekubo Protocol, originally designed for Starknet. The architecture leverages EVM-specific optimizations while maintaining protocol semantics.

---

## Design Principles

1. **Security First:** All design decisions prioritize security.
2. **Gas Efficiency:** Optimize for EVM gas costs.
3. **Composability:** Easy integration with other DeFi protocols.
4. **Upgradeability:** Prepared for future improvements.
5. **Compatibility:** Maintain semantic compatibility with the original protocol.

---

## System Components

### Core Contracts

- **Pool Manager:** Manages liquidity pools, handles swaps and liquidity operations, stores pool state and configurations.
- **Position Manager:** Manages LP positions (NFTs), handles position minting/burning, tracks position-specific data.
- **Router:** User-facing entry point, handles multi-hop swaps, manages slippage protection.

### Supporting Contracts

- **Libraries:** Math (fixed-point arithmetic, sqrt), Tick management, Position helpers, Safe token transfer utilities.
- **Interfaces:** Standard ERC interfaces, protocol-specific interfaces, external protocol interfaces.

---

## Key Differences from Starknet Version

### Storage Layout

- **Starknet (Cairo):** Felt-based storage.
- **EVM (Solidity):** Packed storage for gas efficiency.

### Math Operations

- **Starknet:** Native 252-bit felt arithmetic, Cairo hints.
- **EVM:** 256-bit uint operations, custom fixed-point math libraries, Solady optimizations.

### Account Model

- **Starknet:** Account abstraction native, protocol-level signature verification.
- **EVM:** EOA and contract accounts, `msg.sender` access control, ERC-2612 permits for gasless approvals.

---

## Data Structures

### Pool State

```solidity
struct PoolState {
    uint160 sqrtPriceX96;
    int24 tick;
    uint16 observationIndex;
    uint16 observationCardinality;
    uint16 observationCardinalityNext;
    uint8 feeProtocol;
    bool unlocked;
}
```

### Position Info

```solidity
struct PositionInfo {
    uint128 liquidity;
    uint256 feeGrowthInside0LastX128;
    uint256 feeGrowthInside1LastX128;
    uint128 tokensOwed0;
    uint128 tokensOwed1;
}
```

### Tick Info

```solidity
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
```

---

## Gas Optimizations

- **Storage Packing:** Pack multiple values into single storage slot.
- **Bitmap for Tick Management:** Use bitmap to track initialized ticks for O(1) checks.
- **Calldata vs Memory:** Use calldata for read-only arrays.
- **Unchecked Arithmetic:** Use unchecked blocks where overflow is impossible.

---

## Security Considerations

- **Reentrancy Protection:** Global lock pattern for critical functions.
- **Price Oracle Manipulation:** Time-weighted average price (TWAP) and observations array.
- **Access Control:** Role-based access control for owner and operators.

---

## Integration Patterns

- **Adding Liquidity:** Approve tokens, call router to add liquidity.
- **Swapping:** Use router for single or multi-hop swaps.

---

## Future Considerations

- **Potential Upgrades:** Multi-chain deployment, further gas optimizations, new pool types, dynamic fees, integration helpers.
- **Extensibility Points:** Custom fee tiers, additional pool configurations, enhanced oracle functionality, protocol-owned liquidity features.

---

## Development Guidelines

- Design new features in isolation.
- Consider gas costs.
- Write comprehensive tests.
- Document thoroughly.
- Conduct security reviews.

**Modifying Core:**  
Be extremely careful—understand implications, test exhaustively, consider migration, and plan for audits.

---

## Testing Architecture

```
test/
├── unit/              # Isolated contract tests
├── integration/       # Multi-contract tests
├── fuzz/              # Property-based tests
└── invariant/         # Invariant tests
```

---

## References

- Original Ekubo Protocol (Starknet)
- Uniswap V3 (concentrated liquidity design)
- Solady (optimized utilities)
- Foundry (testing framework)

---

For implementation details, see source code and inline documentation.

**Last Updated:** November 25, 2025

# API Reference

## Core Interfaces

### IEkuboOracle

The main interface for interacting with the Ekubo Oracle system.

```typescript
interface IEkuboOracle {
  // Get price for a token pair
  getPrice(baseToken: string, quoteToken: string): Promise<PriceData>;
  
  // Get TWAP (Time-Weighted Average Price)
  getTWAP(
    baseToken: string,
    quoteToken: string,
    period: number
  ): Promise<TWAPData>;
  
  // Subscribe to price updates
  subscribe(
    baseToken: string,
    quoteToken: string,
    callback: (price: PriceData) => void
  ): Subscription;
  
  // Get historical prices
  getHistoricalPrices(
    baseToken: string,
    quoteToken: string,
    startTime: number,
    endTime: number
  ): Promise<PriceData[]>;
}
```

### PriceData

```typescript
interface PriceData {
  price: bigint;
  timestamp: number;
  blockNumber: number;
  poolKey: PoolKey;
  liquidity: bigint;
}
```

### TWAPData

```typescript
interface TWAPData {
  twap: bigint;
  startTime: number;
  endTime: number;
  sampleCount: number;
  poolKey: PoolKey;
}
```

### PoolKey

```typescript
interface PoolKey {
  token0: string;
  token1: string;
  fee: bigint;
  tickSpacing: number;
  extension: string;
}
```

### Subscription

```typescript
interface Subscription {
  unsubscribe(): void;
  isActive(): boolean;
}
```

### OracleConfig

```typescript
interface OracleConfig {
  rpcUrl: string;
  contractAddress: string;
  chainId: number;
  pollingInterval?: number;
  maxRetries?: number;
  timeout?: number;
}
```

## Error Types

### OracleError

```typescript
class OracleError extends Error {
  code: ErrorCode;
  details?: Record<string, unknown>;
}

enum ErrorCode {
  INVALID_TOKEN = 'INVALID_TOKEN',
  POOL_NOT_FOUND = 'POOL_NOT_FOUND',
  INSUFFICIENT_LIQUIDITY = 'INSUFFICIENT_LIQUIDITY',
  RPC_ERROR = 'RPC_ERROR',
  TIMEOUT = 'TIMEOUT',
  INVALID_PERIOD = 'INVALID_PERIOD',
}
```

## Usage Examples

### Basic Price Query

```typescript
import { EkuboOracle } from '@ekubo/oracle';

const oracle = new EkuboOracle({
  rpcUrl: 'https://starknet-mainnet.public.blastapi.io',
  contractAddress: '0x...',
  chainId: 1,
});

const price = await oracle.getPrice(
  '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7', // ETH
  '0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8'  // USDC
);

console.log(`Price: ${price.price}`);
```

### TWAP Query

```typescript
const twap = await oracle.getTWAP(
  '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7',
  '0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8',
  3600 // 1 hour period in seconds
);

console.log(`TWAP: ${twap.twap}`);
```

### Price Subscription

```typescript
const subscription = oracle.subscribe(
  '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7',
  '0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8',
  (price) => {
    console.log(`New price: ${price.price} at block ${price.blockNumber}`);
  }
);

// Later, to stop receiving updates
subscription.unsubscribe();
```