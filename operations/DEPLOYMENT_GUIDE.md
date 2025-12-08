# Deployment Guide

This guide explains how to deploy the Ekubo Protocol EVM implementation.

---

## Prerequisites

- Review and complete the [Pre-deployment Compliance Checklist](../governance/COMPLIANCE_CHECKLIST.md).
- Ensure all contracts are tested and audited.
- Prepare deployment scripts and configuration files.
- Obtain RPC URL and private key for the target network.

---

## Deployment Steps

### 1. Configure Environment

Set environment variables for RPC URL and private key:
```bash
export RPC_URL="https://mainnet.infura.io/v3/YOUR_KEY"
export PRIVATE_KEY="your_private_key"
```

### 2. Build Contracts

```bash
forge build
```

### 3. Run Tests

```bash
forge test
forge coverage
```

### 4. Deploy Contracts

Use Foundry deployment script:
```bash
forge script script/Deploy.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

### 5. Verify Contracts

Verify contracts on Etherscan or relevant block explorer:
```bash
forge verify-contract \
  --chain-id 1 \
  --etherscan-api-key $ETHERSCAN_KEY \
  CONTRACT_ADDRESS \
  src/Contract.sol:ContractName
```

### 6. Record Deployment

Add deployment details to [DEPLOYMENT_REGISTRY.md](../governance/DEPLOYMENT_REGISTRY.md), including network, contract addresses, operator, and deployment date.

### 7. Post-Deployment

- Confirm contract addresses and initial state.
- Announce deployment to the community and DAO.
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