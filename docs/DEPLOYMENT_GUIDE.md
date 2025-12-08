# Deployment Guide

## Overview

This guide provides comprehensive instructions for deploying the Ekubo Protocol EVM contracts. It covers all deployment scripts, configuration options, and best practices for mainnet and testnet deployments.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Deployment Scripts](#deployment-scripts)
4. [Deployment Order](#deployment-order)
5. [Network Configuration](#network-configuration)
6. [Verification](#verification)
7. [Post-Deployment](#post-deployment)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| Foundry | Latest | Smart contract development framework |
| Node.js | >= 18.0 | JavaScript runtime |
| Git | >= 2.0 | Version control |

### Installation

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Verify installation
forge --version
cast --version
anvil --version
```

### Dependencies

```bash
# Clone repository
git clone https://github.com/ekubo/ekubo-evm.git
cd ekubo-evm

# Install dependencies
forge install

# Build contracts
forge build
```

---

## Environment Setup

### Environment Variables

Create a `.env` file in the project root:

```bash
# .env

# Network RPC URLs
MAINNET_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
ARBITRUM_RPC_URL=https://arb-mainnet.g.alchemy.com/v2/YOUR_API_KEY
BASE_RPC_URL=https://mainnet.base.org

# Private Keys (DO NOT COMMIT)
DEPLOYER_PRIVATE_KEY=0x...
ADMIN_PRIVATE_KEY=0x...

# Etherscan API Keys for Verification
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY
ARBISCAN_API_KEY=YOUR_ARBISCAN_API_KEY
BASESCAN_API_KEY=YOUR_BASESCAN_API_KEY

# Deployment Configuration
PROTOCOL_FEE_RECIPIENT=0x...
INITIAL_ADMIN=0x...
WETH_ADDRESS=0x...
```

### Load Environment

```bash
# Load environment variables
source .env

# Or use direnv
direnv allow
```

---

## Deployment Scripts

### Script Directory Structure

```
script/
├── Deploy.s.sol              # Main deployment orchestrator
├── DeployCore.s.sol          # Core contract deployment
├── DeployPositionManager.s.sol # Position manager deployment
├── DeployRouter.s.sol        # Router deployment
├── DeployQuoter.s.sol        # Quoter deployment
├── DeployOracle.s.sol        # Oracle deployment
├── DeployHooks.s.sol         # Hook contracts deployment
├── ConfigureProtocol.s.sol   # Post-deployment configuration
├── VerifyContracts.s.sol     # Contract verification
└── helpers/
    ├── BaseScript.s.sol      # Base script utilities
    ├── Constants.sol         # Deployment constants
    └── NetworkConfig.sol     # Network-specific configuration
```

### Base Script

All deployment scripts inherit from `BaseScript.s.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

abstract contract BaseScript is Script {
    // Deployment addresses storage
    struct DeploymentAddresses {
        address core;
        address positionManager;
        address router;
        address quoter;
        address oracle;
        address weth;
        address admin;
        address feeRecipient;
    }

    DeploymentAddresses public addresses;

    modifier broadcast() {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }

    function loadConfig() internal {
        addresses.weth = vm.envAddress("WETH_ADDRESS");
        addresses.admin = vm.envAddress("INITIAL_ADMIN");
        addresses.feeRecipient = vm.envAddress("PROTOCOL_FEE_RECIPIENT");
    }

    function saveDeployment(string memory name, address addr) internal {
        string memory chainId = vm.toString(block.chainid);
        string memory path = string.concat(
            "deployments/",
            chainId,
            "/",
            name,
            ".json"
        );
        
        string memory json = vm.serializeAddress("deployment", "address", addr);
        vm.writeJson(json, path);
        
        console2.log("%s deployed at: %s", name, addr);
    }

    function loadDeployment(string memory name) internal view returns (address) {
        string memory chainId = vm.toString(block.chainid);
        string memory path = string.concat(
            "deployments/",
            chainId,
            "/",
            name,
            ".json"
        );
        
        string memory json = vm.readFile(path);
        return vm.parseJsonAddress(json, ".address");
    }
}
```

---

### DeployCore.s.sol

Deploys the core pool contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {Core} from "../src/Core.sol";
import {console2} from "forge-std/console2.sol";

contract DeployCore is BaseScript {
    function run() external broadcast returns (address) {
        loadConfig();

        console2.log("Deploying Core contract...");
        console2.log("Admin:", addresses.admin);
        console2.log("Fee Recipient:", addresses.feeRecipient);

        // Deploy Core
        Core core = new Core(addresses.admin, addresses.feeRecipient);

        // Verify deployment
        require(address(core) != address(0), "Core deployment failed");
        require(core.owner() == addresses.admin, "Owner mismatch");

        addresses.core = address(core);
        saveDeployment("Core", address(core));

        return address(core);
    }
}
```

**Usage:**

```bash
# Deploy to local network
forge script script/DeployCore.s.sol --rpc-url http://localhost:8545 --broadcast

# Deploy to Sepolia testnet
forge script script/DeployCore.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify

# Deploy to mainnet
forge script script/DeployCore.s.sol --rpc-url $MAINNET_RPC_URL --broadcast --verify --slow
```

---

### DeployPositionManager.s.sol

Deploys the Position Manager NFT contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {PositionManager} from "../src/PositionManager.sol";
import {ICore} from "../src/interfaces/ICore.sol";
import {console2} from "forge-std/console2.sol";

contract DeployPositionManager is BaseScript {
    function run() external broadcast returns (address) {
        loadConfig();

        // Load Core address from previous deployment
        address coreAddress = loadDeployment("Core");
        require(coreAddress != address(0), "Core not deployed");

        console2.log("Deploying PositionManager...");
        console2.log("Core:", coreAddress);
        console2.log("WETH:", addresses.weth);

        // Deploy PositionManager
        PositionManager positionManager = new PositionManager(
            ICore(coreAddress),
            addresses.weth
        );

        // Verify deployment
        require(address(positionManager) != address(0), "Deployment failed");
        require(
            address(positionManager.core()) == coreAddress,
            "Core address mismatch"
        );

        addresses.positionManager = address(positionManager);
        saveDeployment("PositionManager", address(positionManager));

        return address(positionManager);
    }
}
```

**Usage:**

```bash
# Requires Core to be deployed first
forge script script/DeployPositionManager.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify
```

---

### DeployRouter.s.sol

Deploys the Swap Router contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {SwapRouter} from "../src/SwapRouter.sol";
import {ICore} from "../src/interfaces/ICore.sol";
import {console2} from "forge-std/console2.sol";

contract DeployRouter is BaseScript {
    function run() external broadcast returns (address) {
        loadConfig();

        // Load Core address
        address coreAddress = loadDeployment("Core");
        require(coreAddress != address(0), "Core not deployed");

        console2.log("Deploying SwapRouter...");
        console2.log("Core:", coreAddress);
        console2.log("WETH:", addresses.weth);

        // Deploy SwapRouter
        SwapRouter router = new SwapRouter(
            ICore(coreAddress),
            addresses.weth
        );

        // Verify deployment
        require(address(router) != address(0), "Deployment failed");

        addresses.router = address(router);
        saveDeployment("SwapRouter", address(router));

        return address(router);
    }
}
```

**Usage:**

```bash
forge script script/DeployRouter.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify
```

---

### DeployQuoter.s.sol

Deploys the Quoter contract for swap simulations.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {Quoter} from "../src/Quoter.sol";
import {ICore} from "../src/interfaces/ICore.sol";
import {console2} from "forge-std/console2.sol";

contract DeployQuoter is BaseScript {
    function run() external broadcast returns (address) {
        loadConfig();

        // Load Core address
        address coreAddress = loadDeployment("Core");
        require(coreAddress != address(0), "Core not deployed");

        console2.log("Deploying Quoter...");
        console2.log("Core:", coreAddress);

        // Deploy Quoter
        Quoter quoter = new Quoter(ICore(coreAddress));

        // Verify deployment
        require(address(quoter) != address(0), "Deployment failed");

        addresses.quoter = address(quoter);
        saveDeployment("Quoter", address(quoter));

        return address(quoter);
    }
}
```

**Usage:**

```bash
forge script script/DeployQuoter.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify
```

---

### DeployOracle.s.sol

Deploys the Oracle extension contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {Oracle} from "../src/Oracle.sol";
import {ICore} from "../src/interfaces/ICore.sol";
import {console2} from "forge-std/console2.sol";

contract DeployOracle is BaseScript {
    // Default observation cardinality
    uint16 constant INITIAL_CARDINALITY = 144; // ~24 hours at 10 min blocks

    function run() external broadcast returns (address) {
        loadConfig();

        // Load Core address
        address coreAddress = loadDeployment("Core");
        require(coreAddress != address(0), "Core not deployed");

        console2.log("Deploying Oracle...");
        console2.log("Core:", coreAddress);
        console2.log("Initial Cardinality:", INITIAL_CARDINALITY);

        // Deploy Oracle
        Oracle oracle = new Oracle(ICore(coreAddress), INITIAL_CARDINALITY);

        // Verify deployment
        require(address(oracle) != address(0), "Deployment failed");

        addresses.oracle = address(oracle);
        saveDeployment("Oracle", address(oracle));

        return address(oracle);
    }
}
```

**Usage:**

```bash
forge script script/DeployOracle.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify
```

---

### Deploy.s.sol (Full Deployment)

Orchestrates the complete deployment of all contracts.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {DeployCore} from "./DeployCore.s.sol";
import {DeployPositionManager} from "./DeployPositionManager.s.sol";
import {DeployRouter} from "./DeployRouter.s.sol";
import {DeployQuoter} from "./DeployQuoter.s.sol";
import {DeployOracle} from "./DeployOracle.s.sol";
import {console2} from "forge-std/console2.sol";

contract Deploy is BaseScript {
    function run() external {
        console2.log("Starting full deployment...");
        console2.log("Chain ID:", block.chainid);
        console2.log("Deployer:", msg.sender);
        console2.log("");

        // Deploy Core
        console2.log("=== Deploying Core ===");
        DeployCore deployCore = new DeployCore();
        addresses.core = deployCore.run();
        console2.log("");

        // Deploy Position Manager
        console2.log("=== Deploying PositionManager ===");
        DeployPositionManager deployPM = new DeployPositionManager();
        addresses.positionManager = deployPM.run();
        console2.log("");

        // Deploy Router
        console2.log("=== Deploying SwapRouter ===");
        DeployRouter deployRouter = new DeployRouter();
        addresses.router = deployRouter.run();
        console2.log("");

        // Deploy Quoter
        console2.log("=== Deploying Quoter ===");
        DeployQuoter deployQuoter = new DeployQuoter();
        addresses.quoter = deployQuoter.run();
        console2.log("");

        // Deploy Oracle
        console2.log("=== Deploying Oracle ===");
        DeployOracle deployOracle = new DeployOracle();
        addresses.oracle = deployOracle.run();
        console2.log("");

        // Print summary
        _printSummary();
    }

    function _printSummary() internal view {
        console2.log("========================================");
        console2.log("         DEPLOYMENT SUMMARY             ");
        console2.log("========================================");
        console2.log("Core:            ", addresses.core);
        console2.log("PositionManager: ", addresses.positionManager);
        console2.log("SwapRouter:      ", addresses.router);
        console2.log("Quoter:          ", addresses.quoter);
        console2.log("Oracle:          ", addresses.oracle);
        console2.log("========================================");
    }
}
```

**Usage:**

```bash
# Full deployment to testnet
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify

# Full deployment to mainnet (with confirmation)
forge script script/Deploy.s.sol --rpc-url $MAINNET_RPC_URL --broadcast --verify --slow
```

---

### ConfigureProtocol.s.sol

Post-deployment configuration script.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {ICore} from "../src/interfaces/ICore.sol";
import {console2} from "forge-std/console2.sol";

contract ConfigureProtocol is BaseScript {
    // Configuration parameters
    uint8 constant DEFAULT_PROTOCOL_FEE = 10; // 10% of swap fees

    function run() external broadcast {
        loadConfig();

        address coreAddress = loadDeployment("Core");
        ICore core = ICore(coreAddress);

        console2.log("Configuring protocol...");
        console2.log("Core:", coreAddress);

        // Set default protocol fee
        // Note: This would be done per-pool in production
        console2.log("Default protocol fee:", DEFAULT_PROTOCOL_FEE, "%");

        // Grant roles if using access control
        _configureRoles(core);

        // Set fee recipient
        _configureFees(core);

        console2.log("Configuration complete!");
    }

    function _configureRoles(ICore core) internal {
        console2.log("Configuring roles...");
        
        // Example: Grant operator role to router
        address router = loadDeployment("SwapRouter");
        // core.grantRole(OPERATOR_ROLE, router);
        
        console2.log("Roles configured");
    }

    function _configureFees(ICore core) internal {
        console2.log("Configuring fees...");
        console2.log("Fee recipient:", addresses.feeRecipient);
        
        // Set fee recipient if needed
        // core.setFeeRecipient(addresses.feeRecipient);
        
        console2.log("Fees configured");
    }
}
```

**Usage:**

```bash
forge script script/ConfigureProtocol.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast
```

---

### DeployHooks.s.sol

Deploys custom hook contracts.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {ICore} from "../src/interfaces/ICore.sol";
import {console2} from "forge-std/console2.sol";

// Import hook implementations
// import {TWAMMHook} from "../src/hooks/TWAMMHook.sol";
// import {LimitOrderHook} from "../src/hooks/LimitOrderHook.sol";
// import {DynamicFeeHook} from "../src/hooks/DynamicFeeHook.sol";

contract DeployHooks is BaseScript {
    function run() external broadcast {
        loadConfig();

        address coreAddress = loadDeployment("Core");
        require(coreAddress != address(0), "Core not deployed");

        console2.log("Deploying Hook contracts...");
        console2.log("Core:", coreAddress);

        // Deploy TWAMM Hook
        // _deployTWAMMHook(coreAddress);

        // Deploy Limit Order Hook
        // _deployLimitOrderHook(coreAddress);

        // Deploy Dynamic Fee Hook
        // _deployDynamicFeeHook(coreAddress);

        console2.log("Hook deployment complete!");
    }

    function _deployTWAMMHook(address core) internal {
        console2.log("Deploying TWAMM Hook...");
        
        // TWAMMHook hook = new TWAMMHook(ICore(core));
        // saveDeployment("TWAMMHook", address(hook));
        
        // console2.log("TWAMM Hook:", address(hook));
    }

    function _deployLimitOrderHook(address core) internal {
        console2.log("Deploying Limit Order Hook...");
        
        // LimitOrderHook hook = new LimitOrderHook(ICore(core));
        // saveDeployment("LimitOrderHook", address(hook));
        
        // console2.log("Limit Order Hook:", address(hook));
    }

    function _deployDynamicFeeHook(address core) internal {
        console2.log("Deploying Dynamic Fee Hook...");
        
        // DynamicFeeHook hook = new DynamicFeeHook(ICore(core));
        // saveDeployment("DynamicFeeHook", address(hook));
        
        // console2.log("Dynamic Fee Hook:", address(hook));
    }
}
```

**Usage:**

```bash
forge script script/DeployHooks.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify
```

---

### helpers/NetworkConfig.sol

Network-specific configuration helper.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library NetworkConfig {
    struct Config {
        address weth;
        address usdc;
        address usdt;
        uint256 chainId;
        string name;
    }

    // Ethereum Mainnet
    function mainnet() internal pure returns (Config memory) {
        return Config({
            weth: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            usdc: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            usdt: 0xdAC17F958D2ee523a2206206994597C13D831ec7,
            chainId: 1,
            name: "Ethereum Mainnet"
        });
    }

    // Sepolia Testnet
    function sepolia() internal pure returns (Config memory) {
        return Config({
            weth: 0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14,
            usdc: 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238,
            usdt: address(0), // No official USDT on Sepolia
            chainId: 11155111,
            name: "Sepolia Testnet"
        });
    }

    // Arbitrum One
    function arbitrum() internal pure returns (Config memory) {
        return Config({
            weth: 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1,
            usdc: 0xaf88d065e77c8cC2239327C5EDb3A432268e5831,
            usdt: 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9,
            chainId: 42161,
            name: "Arbitrum One"
        });
    }

    // Base
    function base() internal pure returns (Config memory) {
        return Config({
            weth: 0x4200000000000000000000000000000000000006,
            usdc: 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913,
            usdt: address(0),
            chainId: 8453,
            name: "Base"
        });
    }

    // Get config by chain ID
    function getConfig(uint256 chainId) internal pure returns (Config memory) {
        if (chainId == 1) return mainnet();
        if (chainId == 11155111) return sepolia();
        if (chainId == 42161) return arbitrum();
        if (chainId == 8453) return base();
        revert("Unsupported chain");
    }
}
```

---

### helpers/Constants.sol

Deployment constants.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library Constants {
    // Fee tiers (in hundredths of a bip)
    uint24 constant FEE_LOWEST = 100;    // 0.01%
    uint24 constant FEE_LOW = 500;       // 0.05%
    uint24 constant FEE_MEDIUM = 3000;   // 0.30%
    uint24 constant FEE_HIGH = 10000;    // 1.00%

    // Tick spacings
    int24 constant TICK_SPACING_LOWEST = 1;
    int24 constant TICK_SPACING_LOW = 10;
    int24 constant TICK_SPACING_MEDIUM = 60;
    int24 constant TICK_SPACING_HIGH = 200;

    // Protocol fees (percentage of swap fee)
    uint8 constant PROTOCOL_FEE_DEFAULT = 10;  // 10%
    uint8 constant PROTOCOL_FEE_MAX = 50;      // 50%

    // Oracle
    uint16 constant ORACLE_CARDINALITY_DEFAULT = 144;
    uint16 constant ORACLE_CARDINALITY_MAX = 65535;

    // Timeouts
    uint256 constant DEPLOYMENT_TIMEOUT = 1 hours;
}
```

---

## Deployment Order

The contracts must be deployed in the following order due to dependencies:

```
┌─────────────────────────────────────────────────────────────┐
│                    Deployment Order                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Core                                                    │
│     └── No dependencies                                     │
│                                                             │
│  2. PositionManager                                         │
│     └── Depends on: Core, WETH                              │
│                                                             │
│  3. SwapRouter                                              │
│     └── Depends on: Core, WETH                              │
│                                                             │
│  4. Quoter                                                  │
│     └── Depends on: Core                                    │
│                                                             │
│  5. Oracle                                                  │
│     └── Depends on: Core                                    │
│                                                             │
│  6. Hooks (Optional)                                        │
│     └── Depends on: Core                                    │
│                                                             │
│  7. Configuration                                           │
│     └── Depends on: All contracts deployed                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Deployment Commands (In Order)

```bash
# 1. Deploy Core
forge script script/DeployCore.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify

# 2. Deploy PositionManager
forge script script/DeployPositionManager.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify

# 3. Deploy SwapRouter
forge script script/DeployRouter.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify

# 4. Deploy Quoter
forge script script/DeployQuoter.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify

# 5. Deploy Oracle
forge script script/DeployOracle.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify

# 6. Configure Protocol
forge script script/ConfigureProtocol.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast
```

### Or Deploy All at Once

```bash
forge script script/Deploy.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify
```

---

## Network Configuration

### Supported Networks

| Network | Chain ID | RPC Variable | Block Explorer |
|---------|----------|--------------|----------------|
| Ethereum Mainnet | 1 | `MAINNET_RPC_URL` | etherscan.io |
| Sepolia Testnet | 11155111 | `SEPOLIA_RPC_URL` | sepolia.etherscan.io |
| Arbitrum One | 42161 | `ARBITRUM_RPC_URL` | arbiscan.io |
| Base | 8453 | `BASE_RPC_URL` | basescan.org |
| Localhost | 31337 | `http://localhost:8545` | N/A |

### WETH Addresses

| Network | WETH Address |
|---------|--------------|
| Ethereum Mainnet | `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` |
| Sepolia | `0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14` |
| Arbitrum One | `0x82aF49447D8a07e3bd95BD0d56f35241523fBab1` |
| Base | `0x4200000000000000000000000000000000000006` |

### Gas Configuration

```bash
# For mainnet deployment with specific gas settings
forge script script/Deploy.s.sol \
    --rpc-url $MAINNET_RPC_URL \
    --broadcast \
    --verify \
    --gas-price 30gwei \
    --priority-gas-price 2gwei \
    --slow
```

---

## Verification

### Automatic Verification

Verification happens automatically with `--verify` flag:

```bash
forge script script/Deploy.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify \
    --etherscan-api-key $ETHERSCAN_API_KEY
```

### Manual Verification

If automatic verification fails:

```bash
# Verify Core
forge verify-contract \
    --chain sepolia \
    --constructor-args $(cast abi-encode "constructor(address,address)" $ADMIN $FEE_RECIPIENT) \
    $CORE_ADDRESS \
    src/Core.sol:Core \
    --etherscan-api-key $ETHERSCAN_API_KEY

# Verify PositionManager
forge verify-contract \
    --chain sepolia \
    --constructor-args $(cast abi-encode "constructor(address,address)" $CORE_ADDRESS $WETH_ADDRESS) \
    $POSITION_MANAGER_ADDRESS \
    src/PositionManager.sol:PositionManager \
    --etherscan-api-key $ETHERSCAN_API_KEY

# Verify SwapRouter
forge verify-contract \
    --chain sepolia \
    --constructor-args $(cast abi-encode "constructor(address,address)" $CORE_ADDRESS $WETH_ADDRESS) \
    $ROUTER_ADDRESS \
    src/SwapRouter.sol:SwapRouter \
    --etherscan-api-key $ETHERSCAN_API_KEY
```

### Verification Script

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {console2} from "forge-std/console2.sol";

contract VerifyContracts is BaseScript {
    function run() external view {
        console2.log("Verifying deployments...");

        // Load all deployed addresses
        address core = loadDeployment("Core");
        address positionManager = loadDeployment("PositionManager");
        address router = loadDeployment("SwapRouter");
        address quoter = loadDeployment("Quoter");
        address oracle = loadDeployment("Oracle");

        // Verify contracts exist
        require(core.code.length > 0, "Core not deployed");
        require(positionManager.code.length > 0, "PositionManager not deployed");
        require(router.code.length > 0, "SwapRouter not deployed");
        require(quoter.code.length > 0, "Quoter not deployed");
        require(oracle.code.length > 0, "Oracle not deployed");

        console2.log("All contracts verified!");
        console2.log("");
        console2.log("Core:", core);
        console2.log("PositionManager:", positionManager);
        console2.log("SwapRouter:", router);
        console2.log("Quoter:", quoter);
        console2.log("Oracle:", oracle);
    }
}
```

---

## Post-Deployment

### Create Initial Pools

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {ICore} from "../src/interfaces/ICore.sol";
import {PoolKey} from "../src/types/PoolKey.sol";
import {console2} from "forge-std/console2.sol";

contract CreateInitialPools is BaseScript {
    function run() external broadcast {
        loadConfig();

        address coreAddress = loadDeployment("Core");
        ICore core = ICore(coreAddress);

        console2.log("Creating initial pools...");

        // Create ETH/USDC pool (0.3% fee)
        _createPool(
            core,
            addresses.weth,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, // USDC
            3000,
            60,
            79228162514264337593543950336 // 1:1 initial price
        );

        // Create ETH/USDT pool (0.3% fee)
        _createPool(
            core,
            addresses.weth,
            0xdAC17F958D2ee523a2206206994597C13D831ec7, // USDT
            3000,
            60,
            79228162514264337593543950336
        );

        console2.log("Initial pools created!");
    }

    function _createPool(
        ICore core,
        address token0,
        address token1,
        uint24 fee,
        int24 tickSpacing,
        uint160 sqrtPriceX96
    ) internal {
        // Ensure token0 < token1
        if (token0 > token1) {
            (token0, token1) = (token1, token0);
        }

        PoolKey memory poolKey = PoolKey({
            token0: token0,
            token1: token1,
            fee: fee,
            tickSpacing: tickSpacing,
            hooks: address(0)
        });

        int24 tick = core.initialize(poolKey, sqrtPriceX96);
        console2.log("Pool created at tick:", tick);
    }
}
```

### Transfer Ownership

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./helpers/BaseScript.s.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {console2} from "forge-std/console2.sol";

contract TransferOwnership is BaseScript {
    function run() external broadcast {
        loadConfig();

        address newOwner = vm.envAddress("NEW_OWNER");
        require(newOwner != address(0), "Invalid new owner");

        console2.log("Transferring ownership to:", newOwner);

        // Transfer Core ownership
        address coreAddress = loadDeployment("Core");
        Ownable(coreAddress).transferOwnership(newOwner);
        console2.log("Core ownership transferred");

        console2.log("Ownership transfer complete!");
        console2.log("New owner must call acceptOwnership() on each contract");
    }
}
```

---

## Troubleshooting

### Common Issues

#### 1. Insufficient Gas

```bash
# Increase gas limit
forge script script/Deploy.s.sol \
    --rpc-url $RPC_URL \
    --broadcast \
    --gas-estimate-multiplier 130
```

#### 2. Nonce Issues

```bash
# Reset nonce
cast nonce $DEPLOYER_ADDRESS --rpc-url $RPC_URL

# Force specific nonce
forge script script/Deploy.s.sol \
    --rpc-url $RPC_URL \
    --broadcast \
    --sender $DEPLOYER_ADDRESS
```

#### 3. Contract Size Limit

```bash
# Enable optimizer with more runs
forge build --optimize --optimizer-runs 200

# Or use via-ir compilation
forge build --via-ir
```

#### 4. Verification Failures

```bash
# Flatten contract for manual verification
forge flatten src/Core.sol > Core_flat.sol

# Check compiler version matches
forge verify-contract \
    --compiler-version v0.8.26+commit.8a97fa7a \
    ...
```

#### 5. RPC Timeout

```bash
# Increase timeout
forge script script/Deploy.s.sol \
    --rpc-url $RPC_URL \
    --broadcast \
    --timeout 120
```

### Debug Mode

```bash
# Run with verbose output
forge script script/Deploy.s.sol \
    --rpc-url $RPC_URL \
    -vvvv

# Dry run without broadcasting
forge script script/Deploy.s.sol \
    --rpc-url $RPC_URL \
    --sender $DEPLOYER_ADDRESS
```

### Simulation

```bash
# Simulate on fork
forge script script/Deploy.s.sol \
    --fork-url $MAINNET_RPC_URL \
    -vvvv
```

---

## Security Checklist

Before mainnet deployment:

- [ ] All tests passing (`forge test`)
- [ ] Code audited by reputable firm
- [ ] Environment variables secured (not committed)
- [ ] Multi-sig wallet for admin
- [ ] Timelock configured for sensitive operations
- [ ] Emergency pause mechanism tested
- [ ] Gas costs estimated and acceptable
- [ ] Deployment simulated on fork
- [ ] Team reviewed deployment plan
- [ ] Monitoring and alerting configured

---

## References

- [Foundry Book](https://book.getfoundry.sh/)
- [Forge Script Documentation](https://book.getfoundry.sh/tutorials/solidity-scripting)
- [Contract Verification](https://book.getfoundry.sh/forge/deploying#verifying-a-pre-existing-contract)
- [API Reference](./API_REFERENCE.md)
- [Integration Guide](./INTEGRATION_GUIDE.md)

---

**Last Updated:** December 7, 2025