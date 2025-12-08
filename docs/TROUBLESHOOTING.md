# TROUBLESHOOTING.md

Troubleshooting Guide for Ekubo Protocol EVM Implementation

---

## Common Issues & Solutions

### 1. Deployment Errors

- **Symptom:** Contract deployment fails or reverts.
- **Solution:**  
  - Check for sufficient gas and correct network configuration.
  - Verify constructor arguments and contract ABI.
  - Review error logs for specific revert reasons.

### 2. Transaction Failures

- **Symptom:** Transactions revert or fail to execute.
- **Solution:**  
  - Ensure tokens are approved for contract use.
  - Check for sufficient token balances and liquidity.
  - Confirm deadline and slippage parameters are valid.

### 3. "Stack Too Deep" Errors

- **Symptom:** Solidity compiler error: "Stack too deep."
- **Solution:**  
  - Refactor functions into smaller units.
  - Use structs to group related variables.

### 4. Gas Usage Too High

- **Symptom:** Transactions are expensive or run out of gas.
- **Solution:**  
  - Optimize storage layout and use packing.
  - Use calldata for read-only parameters.
  - Profile with `forge test --gas-report`.

### 5. Test Failures

- **Symptom:** Unit or integration tests fail.
- **Solution:**  
  - Review test setup and expected outcomes.
  - Check for external dependencies (e.g., timestamps, randomness).
  - Use verbose output: `forge test -vvvv`.

### 6. Contract Verification Issues

- **Symptom:** Verification on Etherscan fails.
- **Solution:**  
  - Ensure correct compiler version and optimization settings.
  - Provide accurate constructor arguments.
  - Use Foundry’s verify command and review error messages.

### 7. Integration Problems

- **Symptom:** External apps or scripts cannot interact with contracts.
- **Solution:**  
  - Confirm contract addresses and ABIs.
  - Check RPC provider connectivity.
  - Validate input parameters and function signatures.

### 8. Revenue Tracking Discrepancies

- **Symptom:** Revenue calculations do not match expectations.
- **Solution:**  
  - Cross-check on-chain data with off-chain records.
  - Review calculation methodology and scripts.
  - Audit data sources and aggregation logic.

---

## Additional Resources

- [Foundry Documentation](https://book.getfoundry.sh/)
- [Solidity Docs](https://docs.soliditylang.org/)
- [Ekubo Protocol EVM Documentation](./README.md)
- [Integration Guide](./INTEGRATION_GUIDE.md)

---

## Support

- Open a GitHub issue: https://github.com/Ekubo-DAO/Ekubo-EVM/issues
- Contact maintainers: aksels.laivenieks@outlook.com

---

**Last Updated:** November 29, 2025