# DEVELOPMENT.md

Comprehensive guide for developers working on Ekubo Protocol EVM implementation.

---

## Prerequisites

### Required Tools

```bash
# Foundry (Forge, Cast, Anvil)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Verify installation
forge --version
cast --version
anvil --version
```

### Recommended Tools

```bash
# Slither (static analysis)
pip3 install slither-analyzer

# Solhint (linting)
npm install -g solhint

# Prettier (formatting)
npm install -g prettier prettier-plugin-solidity
```

---

## Initial Setup

```bash
# Clone repository
git clone https://github.com/[org]/2025-11-ekubo.git
cd 2025-11-ekubo

# Install dependencies
forge install

# Build contracts
forge build

# Run tests
forge test
```

---

## Project Structure

```
Ekubo-DAO-Ekubo-EVM/
├── src/                  # Contract source code
│   ├── base/             # Base protocol contracts and logic
│   ├── extensions/       # Optional or extended protocol features
│   ├── interfaces/       # Interface definitions for contracts
│   │   └── extensions/   # Interfaces specific to extensions
│   ├── lens/             # Read-only/view contracts for analytics
│   ├── libraries/        # Shared utility libraries
│   ├── math/             # Math utilities and helpers
│   └── types/            # Custom types and structs
├── test/                 # Test files for all contract modules
│   ├── base/             # Tests for base protocol contracts
│   ├── extensions/       # Tests for extension features
│   ├── lens/             # Tests for lens/view contracts
│   ├── libraries/        # Tests for utility libraries
│   ├── math/             # Tests for math helpers
│   └── types/            # Tests for custom types
├── script/               # Deployment and utility scripts
├── lib/                  # External dependencies (git submodules)
│   ├── forge-std/        # Foundry standard library
│   └── solady/           # Solady utilities
├── foundry.toml          # Foundry configuration file
└── remappings.txt        # Import remappings for Solidity
```

---

## Development Workflow

1. **Create Feature Branch**
    ```bash
    git checkout -b feature/your-feature-name
    ```

2. **Write Code**
    - Follow the style guide in CONTRIBUTING.md

3. **Write Tests**
    - Place unit, integration, fuzz, and invariant tests in the appropriate test folders.

4. **Run Tests**
    ```bash
    forge test
    forge test --match-path test/unit/YourContract.t.sol
    forge test --match-test test_YourFunction
    forge test --gas-report
    forge test -vvvv
    forge coverage
    ```

5. **Check Gas Usage**
    ```bash
    forge test --gas-report
    forge snapshot
    git diff .gas-snapshot
    ```

6. **Static Analysis**
    ```bash
    slither .
    solhint 'src/**/*.sol'
    ```

7. **Format Code**
    ```bash
    forge fmt
    ```

---

## Testing Guidelines

- Use descriptive test names.
- Test happy path, edge cases, and failure cases.
- Use setup functions for common state.
- Utilize Foundry cheatcodes for advanced testing.

---

## Deployment

### Local Testing

```bash
anvil
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
```

### Testnet Deployment

```bash
export RPC_URL="https://sepolia.infura.io/v3/YOUR_KEY"
export PRIVATE_KEY="your_private_key"
forge script script/Deploy.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

### Verification

```bash
forge verify-contract \
    --chain-id 1 \
    --num-of-optimizations 200 \
    --watch \
    --constructor-args $(cast abi-encode "constructor(address)" "0x...") \
    --etherscan-api-key $ETHERSCAN_KEY \
    --compiler-version v0.8.20 \
    CONTRACT_ADDRESS \
    src/Contract.sol:ContractName
```

---

## Debugging

- Use Forge debugger: `forge test --debug test_FunctionName`
- Console logging: `import {console} from "forge-std/console.sol";`
- Detailed traces: `forge test -vvvv`

---

## Common Issues

- **Stack too deep:** Refactor into smaller functions or use structs.
- **Gas too high:** Use gas profiler and optimize.
- **Tests failing randomly:** Check for timestamp, randomness, or external dependencies.

---

## Performance Optimization

- Use `uint256` for storage unless packing.
- Pack storage variables.
- Use `calldata` for function parameters.
- Cache storage variables in memory.
- Use `immutable` for constructor-set variables.
- Use `unchecked` where overflow is impossible.
- Use custom errors instead of strings.

---

## Continuous Integration

- Tests run automatically on every push, pull request, and before merge.
- See `.github/workflows/ci.yml` for details.

---

## Resources

- [Foundry Documentation](https://book.getfoundry.sh/)
- [Solidity Docs](https://docs.soliditylang.org/)
- [Secure Contract Practices](https://consensys.github.io/smart-contract-best-practices/)
- [Secureum](https://www.secureum.xyz/)

---

**Questions?** Open an issue or contact maintainers.

**Last Updated:** November 25, 2025