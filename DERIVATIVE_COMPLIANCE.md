# Ekubo Protocol EVM - Derivative Compliance

This repository contains an EVM implementation of the Ekubo Protocol, originally developed for Starknet.

## License Compliance

This derivative work is licensed under the **Ekubo DAO Shared Revenue License 1.0** (see LICENSE file).

### Revenue Sharing Obligation

As a derivative of the original Ekubo Protocol:
- **50% of protocol revenue** must be paid to the Ekubo DAO
- This obligation applies to all deployments and uses of this code
- Revenue includes all fees, profits, and income derived from operating this protocol

**Payment Details:**
- Payment address: [Ekubo DAO][0x8F29e2b3c67467CF6B1920d9876e378E3B7A0595]
- Payment frequency: [quarterly]
- Revenue calculation methodology: [All protocol fees, profits, and income generated from transactions, swaps, liquidity provision, and any other monetized features of the protocol, net of direct transaction costs (e.g., gas fees paid by the protocol)]
- Reporting requirements: [Operators must submit a detailed quarterly report to Ekubo DAO, including total protocol revenue, calculation methodology, payment confirmation, and supporting transaction data. Reports should be sent via the official DAO contact channel and/or uploaded to the designated repository or portal]

### Attribution

**Original Work**: Ekubo Protocol (Starknet Implementation)  
**Original Authors**: Ekubo DAO and contributors  
**Original Repository**: https://github.com/EkuboProtocol/core (if public)  
**Original License**: Ekubo DAO Shared Revenue License 1.0  
**Fork Date**: November 2025

### Modifications from Original

This EVM implementation includes significant adaptations:

1. **Language Translation**: Cairo → Solidity
2. **Platform Adaptation**: Starknet → EVM-compatible chains
3. **Architecture Changes**:
   - EVM-specific storage patterns
   - Gas optimization for EVM
   - Solidity security patterns
   - EVM-compatible math operations

4. **Dependencies**:
   - Uses Solady for optimized utilities
   - Uses Foundry for testing/deployment
   - See THIRD_PARTY_LICENSES.md for details

### Compliance Verification

Operators deploying this code must:
1. Register deployment with Ekubo DAO
2. Implement revenue tracking
3. Submit quarterly revenue reports
4. Make timely payments (50% of revenue)
5. Maintain attribution in all user-facing documentation

### Questions & Governance

**License Compliance Questions:**
- Ekubo DAO: [aksels.laivenieks@outlook.com]

**This Repository Maintainers:**
- GitHub Issues: https://github.com/Ekubo-DAO/Ekubo-EVM/issues
- Email: [aksels.laivenieks@outlook.com]

## Disclaimer

This compliance document is provided for transparency. It does not modify or supersede the terms of the Ekubo DAO Shared Revenue License 1.0. In case of conflict, the LICENSE file governs.

---

**Last Updated**: November 25, 2025  
**Review Schedule**: Quarterly or upon license updates