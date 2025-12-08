# DEPLOYMENT.md

Deployment Guide for Ekubo Protocol EVM Implementation

---

## Prerequisites

- Ensure all compliance and governance requirements are met (see [COMPLIANCE_CHECKLIST.md](../governance/COMPLIANCE_CHECKLIST.md)).
- Review and test all contracts thoroughly.
- Prepare deployment scripts and configuration files.

---

## Deployment Steps

### 1. Configure Environment

- Set up environment variables for RPC URLs, private keys, and API keys.
- Example:
  ```bash
  export RPC_URL="https://mainnet.infura.io/v3/YOUR_KEY"
  export PRIVATE_KEY="your_private_key"
  ```

### 2. Build Contracts

```bash
forge build
```

### 3. Run Pre-Deployment Tests

```bash
forge test
forge coverage
slither .
```

### 4. Deploy Contracts

- Use Foundry script or deployment tool:
  ```bash
  forge script script/Deploy.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
  ```

### 5. Verify Contracts

- Verify on Etherscan or relevant block explorer:
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

### 6. Record Deployment

- Add deployment details to [DEPLOYMENT_REGISTRY.md](../governance/DEPLOYMENT_REGISTRY.md).
- Include network, contract addresses, operator, and deployment date.

### 7. Post-Deployment Checklist

- Confirm contract addresses and initial state.
- Announce deployment to community and DAO.
- Begin revenue tracking and reporting.

---

## Troubleshooting

- Check for failed transactions and review error logs.
- Ensure sufficient gas and correct network configuration.
- Validate contract initialization and permissions.

---

## References

- [Foundry Documentation](https://book.getfoundry.sh/)
- [DEPLOYMENT_REGISTRY.md](../governance/DEPLOYMENT_REGISTRY.md)
- [COMPLIANCE_CHECKLIST.md](../governance/COMPLIANCE_CHECKLIST.md)

---

**Last Updated:** November 29, 2025