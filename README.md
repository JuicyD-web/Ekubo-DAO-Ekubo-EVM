# Ekubo Protocol EVM Implementation

## Project Description & Relation to Ekubo Protocol

This repository is the official EVM (Ethereum Virtual Machine) implementation of the **Ekubo Protocol**, a next-generation automated market maker (AMM) and concentrated liquidity management system. The original Ekubo Protocol was designed and launched on StarkNet, pioneering advanced AMM features and efficient liquidity management for the next era of decentralized finance.

**Ekubo-DAO-Ekubo-EVM** brings the core innovations and architecture of Ekubo Protocol to Ethereum and all EVM-compatible chains, enabling projects and DAOs to leverage proven technology with flexible licensing and revenue sharing options. This implementation closely follows the design principles, security model, and governance structure of the StarkNet Ekubo Protocol, while adapting for EVM environments and integrating with popular Solidity libraries and tooling.

**Key Points:**
- Faithful port of Ekubo Protocol from StarkNet to EVM
- Supports concentrated liquidity, advanced routing, MEV capture, and TWAMM
- Licensed under the Ekubo DAO Shared Revenue License (see below)
- Designed for DAOs, DeFi protocols, and institutional operators seeking robust AMM infrastructure

For more on the original protocol, see [Ekubo Protocol on StarkNet](https://ekubo.org/) and the [Ekubo DAO documentation](https://docs.ekubo.org/).

[![License](https://img.shields.io/badge/License-Ekubo%20DAO%20Shared%20Revenue%201.0-blue.svg)](./LICENSE)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.20-green.svg)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-orange.svg)](https://book.getfoundry.sh/)

## 🚀 Project Overview

**Ekubo Protocol** is a next-generation automated market maker (AMM) and concentrated liquidity management system for Ethereum and EVM-compatible chains. This repository contains the complete implementation including:

- 🔐 **Core AMM Engine** - Advanced liquidity pools with concentrated liquidity
- 📊 **Router & Positions** - Efficient swap routing and position management
- 🛡️ **Security Extensions** - MEV capture, TWAMM, and oracle integrations
- 📜 **Full Legal Framework** - Flexible licensing with revenue sharing options
- 🧪 **Comprehensive Testing** - Unit, integration, and invariant tests
- 📚 **Complete Documentation** - Architecture, APIs, and integration guides

---

## 💼 Flexible Licensing Tiers

Choose the licensing option that best fits your business model:

| Tier | Revenue Share | Annual Fee | Best For |
|------|---------------|------------|----------|
| **[Option 1](#option-1-standard-revenue-share)** | 50% | $0 | Startups, uncertain revenue |
| **[Option 2](#option-2-reduced-share--annual-license)** | 25% | $50,000 | Growing protocols |
| **[Option 3](#option-3-minimal-share--premium-license)** | 10% | $100,000 | Established protocols |
| **[Option 4](#option-4-enterprise-license)** | 5% | $125,000 | Large-scale deployments |

### Option 1: Standard Revenue Share
- ✅ **50% revenue share** to Ekubo DAO
- ✅ **$0 annual fee** - No upfront costs
- ✅ Quarterly reporting and payment
- ✅ Full protocol access
- ✅ Perfect for startups and new projects

### Option 2: Reduced Share + Annual License
- ✅ **25% revenue share** to Ekubo DAO
- ✅ **$50,000/year** license fee ($12,500 quarterly)
- ✅ Best for growing protocols
- ✅ Standard support included

### Option 3: Minimal Share + Premium License
- ✅ **10% revenue share** to Ekubo DAO
- ✅ **$100,000/year** license fee ($25,000 quarterly)
- ✅ Priority support and consultation
- ✅ Quarterly advisory calls
- ✅ Best for established protocols

### Option 4: Enterprise License
- ✅ **5% revenue share** to Ekubo DAO
- ✅ **$125,000/year** license fee ($31,250 quarterly)
- ✅ Dedicated support channel
- ✅ Monthly consultation calls
- ✅ Early access to updates
- ✅ Custom feature requests
- ✅ Best for institutional operators

📄 **[View Complete License Options & Cost Calculator](./LICENSE_PURCHASE_OPTIONS.md)**

---

## 💰 Cost Comparison Examples

### Revenue: $100,000/year
- **Option 1:** $50,000 ✅ **Best Choice**
- **Option 2:** $75,000
- **Option 3:** $110,000
- **Option 4:** $130,000

### Revenue: $500,000/year
- **Option 1:** $250,000
- **Option 2:** $175,000
- **Option 3:** $150,000 ✅ **Best Choice**
- **Option 4:** $150,000 ✅ **(Better support)**

### Revenue: $1,000,000/year
- **Option 1:** $500,000
- **Option 2:** $300,000
- **Option 3:** $200,000
- **Option 4:** $175,000 ✅ **Best Choice**

**Breakeven Points:**
- Option 2 saves money when revenue > **$200,000/year**
- Option 3 saves money when revenue > **$333,333/year**
- Option 4 saves money when revenue > **$500,000/year**

---

## 🚀 Quick Start Guide

### Prerequisites

- **[Foundry](https://book.getfoundry.sh/)** - Ethereum development toolkit
- **Git** - Version control
- **Node.js** (optional) - For automation scripts
- **Python 3.8+** (optional) - For revenue tracking

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ekubo-DAO/Ekubo-EVM.git
   cd Ekubo-EVM
   ```

2. **Initialize Git (if needed)**
   ```bash
   git init
   ```

3. **Install Foundry dependencies**
   ```bash
   forge install
   ```

4. **Install OpenZeppelin (optional, for future use)**
   ```bash
   forge install OpenZeppelin/openzeppelin-contracts
   ```

5. **Compile contracts**
   ```bash
   forge build
   ```

6. **Run tests**
   ```bash
   forge test
   ```

### Deployment

1. **Configure environment variables**
   ```bash
   export ETH_RPC_URL="https://mainnet.infura.io/v3/YOUR_KEY"
   export PRIVATE_KEY="your_private_key"
   ```

2. **Deploy contracts**
   ```bash
   forge script script/Deploy.s.sol --rpc-url $ETH_RPC_URL --private-key $PRIVATE_KEY --broadcast
   ```

3. **Verify contracts (optional)**
   ```bash
   forge verify-contract <CONTRACT_ADDRESS> src/Core.sol:Core --chain-id 1
   ```

---

## 📁 Repository Structure

```
Ekubo-DAO-Ekubo-EVM/
├── src/                          # Smart contracts
│   ├── Core.sol                  # Main AMM core logic
│   ├── Router.sol                # Swap routing
│   ├── Positions.sol             # Position management
│   ├── extensions/               # Protocol extensions
│   ├── interfaces/               # Contract interfaces
│   ├── libraries/                # Utility libraries
│   └── types/                    # Type definitions
│
├── test/                         # Test suite
│   ├── unit/                     # Unit tests
│   ├── integration/              # Integration tests
│   └── invariant/                # Invariant tests
│
├── script/                       # Deployment scripts
│   └── Deploy.s.sol              # Main deployment script
│
├── docs/                         # Documentation
│   ├── ARCHITECTURE.md           # System architecture
│   ├── API_REFERENCE.md          # API documentation
│   ├── INTEGRATION_GUIDE.md      # Integration guide
│   ├── FAQ.md                    # Frequently asked questions
│   └── TROUBLESHOOTING.md        # Common issues
│
├── revenue/                      # Revenue sharing
│   ├── REVENUE_SHARING.md        # Sharing terms
│   ├── CALCULATION_METHODOLOGY.md # How to calculate
│   └── templates/                # Report templates
│
├── governance/                   # Governance docs
│   ├── GOVERNANCE_STRUCTURE.md   # Governance model
│   ├── DEPLOYMENT_REGISTRY.md    # Deployment tracking
│   ├── COMPLIANCE_CHECKLIST.md   # Compliance guide
│   └── DISPUTE_RESOLUTION.md     # Dispute process
│
├── scripts/                      # Automation scripts
│   └── track_revenue.py          # Revenue tracking
│
├── LICENSE                       # Full license text
├── LICENSE.md                    # License summary
├── LICENSE_PURCHASE_OPTIONS.md   # Licensing tiers
├── README.md                     # This file
├── COPYRIGHT.md                  # Copyright info
├── DERIVATIVE_COMPLIANCE.md      # Derivative works
└── foundry.toml                  # Foundry config
```

---

## 📚 Documentation

### Getting Started
- **[README.md](./README.md)** - This file (Quick start & overview)
- **[LICENSE_PURCHASE_OPTIONS.md](./LICENSE_PURCHASE_OPTIONS.md)** - Choose your license tier
- **[Quick Start Video](#)** - Coming soon

### Technical Documentation
- **[Architecture Overview](./docs/ARCHITECTURE.md)** - System design and components
- **[API Reference](./docs/API_REFERENCE.md)** - Complete API documentation
- **[Integration Guide](./docs/INTEGRATION_GUIDE.md)** - How to integrate with Ekubo
- **[Deployment Guide](./docs/DEPLOYMENT_GUIDE.md)** - Deployment instructions
- **[Security Best Practices](./docs/SECURITY.md)** - Security guidelines

### Legal & Compliance
- **[LICENSE](./LICENSE)** - Full license text (Ekubo DAO Shared Revenue License 1.0)
- **[LICENSE.md](./LICENSE.md)** - Human-readable summary
- **[Revenue Sharing Terms](./revenue/REVENUE_SHARING.md)** - Payment requirements
- **[Calculation Methodology](./revenue/CALCULATION_METHODOLOGY.md)** - How to calculate payments
- **[COPYRIGHT.md](./COPYRIGHT.md)** - Copyright and attribution
- **[DERIVATIVE_COMPLIANCE.md](./DERIVATIVE_COMPLIANCE.md)** - Derivative works guide

### Governance
- **[Governance Structure](./governance/GOVERNANCE_STRUCTURE.md)** - How governance works
- **[Deployment Registry](./governance/DEPLOYMENT_REGISTRY.md)** - Track deployments
- **[Compliance Checklist](./governance/COMPLIANCE_CHECKLIST.md)** - Stay compliant
- **[Dispute Resolution](./governance/DISPUTE_RESOLUTION.md)** - Resolve disputes

### Support
- **[FAQ](./docs/FAQ.md)** - Frequently asked questions
- **[Troubleshooting](./docs/TROUBLESHOOTING.md)** - Common issues and solutions

---

## 🏗️ Build Instructions

### Compile Contracts
```bash
forge build
```

### Run Tests
```bash
# Run all tests
forge test

# Run with verbosity
forge test -vvv

# Run specific test
forge test --match-test testSwap

# Run with gas report
forge test --gas-report

# Run with coverage
forge coverage
```

### Generate Documentation
```bash
forge doc
```

### Format Code
```bash
forge fmt
```

### Static Analysis
```bash
# Install Slither
pip install slither-analyzer

# Run analysis
slither .
```

---

## 📊 Revenue Tracking & Reporting

### Automated Revenue Tracking

Track protocol revenue automatically using the provided Python script:

```bash
# Install dependencies
pip install web3

# Set environment variables
export ETH_RPC_URL="https://mainnet.infura.io/v3/YOUR_KEY"

# Run tracking script
python scripts/track_revenue.py
```

### Manual Calculation

1. Collect fee events from your Core contract
2. Aggregate total revenue
3. Calculate your tier's revenue share percentage
4. Submit payment and report

**See:** [CALCULATION_METHODOLOGY.md](./revenue/CALCULATION_METHODOLOGY.md)

### Quarterly Reporting

- **Due Date:** Within 10 business days of quarter end
- **Template:** [REVENUE_REPORT_TEMPLATE.md](./revenue/templates/REVENUE_REPORT_TEMPLATE.md)
- **Submit via:** GitHub issue with label `revenue-report`

---

## 💳 How to Purchase a License Tier

### Step 1: Calculate Your Costs
Use the [LICENSE_PURCHASE_OPTIONS.md](./LICENSE_PURCHASE_OPTIONS.md) calculator to determine which tier saves you money.

### Step 2: Contact Ekubo DAO
- **Email:** aksels.laivenieks@outlook.com
- **GitHub:** Create an issue with label `license-request`

### Step 3: Provide Information
- Selected tier (Option 2, 3, or 4)
- Estimated annual revenue
- Deployment timeline
- Company/project information

### Step 4: Sign Agreement
- Review license agreement
- Sign digitally
- Receive payment instructions

### Step 5: Make Payment
- Send license fee to designated address
- Provide transaction hash
- License activates upon confirmation

### Step 6: Deploy & Report
- Deploy using `script/Deploy.s.sol`
- Register in [DEPLOYMENT_REGISTRY.md](./governance/DEPLOYMENT_REGISTRY.md)
- Begin quarterly reporting

---

## 🛡️ Security & Audits

- **Audit Status:** Pending (Coming Q1 2026)
- **Bug Bounty:** Coming soon
- **Security Contact:** aksels.laivenieks@outlook.com

### Responsible Disclosure
If you discover a security vulnerability:
1. **DO NOT** create a public issue
2. Email: aksels.laivenieks@outlook.com
3. Include detailed description and reproduction steps
4. Allow 90 days for fix before public disclosure

---

## 🤝 Contributing

We welcome contributions! However, please note:

- This is a licensed repository (not open source)
- All contributors must agree to the license terms
- Contributions do not grant ownership or reduce revenue share obligations
- See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines

---

## 📞 Support & Contact

### General Inquiries
- **Email:** aksels.laivenieks@outlook.com
- **GitHub Issues:** [Ekubo-DAO/Ekubo-EVM/issues](https://github.com/Ekubo-DAO/Ekubo-EVM/issues)

### License Tier Inquiries
- **Label:** `license-request`
- **Response Time:** 48 hours (business days)

### Revenue & Compliance Questions
- **Label:** `revenue-report`
- **Response Time:** 48 hours (business days)

### Technical Support

**Standard Support (Options 1 & 2):**
- GitHub issues and documentation
- Email support (48-hour response)

**Priority Support (Option 3):**
- Direct email support (24-hour response)
- Quarterly consultation calls

**Dedicated Support (Option 4):**
- Dedicated Slack/Discord channel
- Monthly consultation calls
- Priority bug fixes

---

## 🌐 Community

- **Website:** Coming soon
- **Twitter:** Coming soon
- **Discord:** Coming soon
- **Forum:** Coming soon

### 📋 Repository Forks & Derivatives

To view who has forked or copied this repository:

1. **View on GitHub:** Visit the [repository network graph](https://github.com/JuicyD-web/Ekubo-DAO-Ekubo-EVM/network/members) to see all forks
2. **Fork Count:** The fork count is displayed at the top of the repository page
3. **Track Derivatives:** See [FORKS_REGISTRY.md](./governance/FORKS_REGISTRY.md) for registered derivative deployments

**Important for Licensees:**
- All forks and derivatives must comply with the license terms
- Revenue sharing applies to all deployments, including forks
- See [DERIVATIVE_COMPLIANCE.md](./DERIVATIVE_COMPLIANCE.md) for requirements

---

## 📜 License

This project is licensed under the **Ekubo DAO Shared Revenue License 1.0**.

**Default Terms:** 50% revenue share, no annual fee

**Alternative Tiers Available:**
- 25% revenue share + $50k/year
- 10% revenue share + $100k/year
- 5% revenue share + $125k/year

See [LICENSE](./LICENSE) for full legal terms.  
See [LICENSE_PURCHASE_OPTIONS.md](./LICENSE_PURCHASE_OPTIONS.md) for tier details.

---

## 🎯 Roadmap

### Q1 2026
- ✅ Core protocol launch
- ✅ Documentation completion
- 🔄 Security audit
- 🔄 Mainnet deployment

### Q2 2026
- 📋 Bug bounty program
- 📋 Additional chain deployments
- 📋 Enhanced analytics dashboard

### Q3 2026
- 📋 Governance token launch
- 📋 DAO formation
- 📋 Community grants program

---

## ⚠️ Disclaimer

This software is provided "as is" without warranty. Use at your own risk. Always conduct thorough testing and audits before deploying to production. The revenue sharing obligations are legally binding - ensure you understand and can comply with all terms before deployment.

---

## 📊 Repository Stats

- **Solidity Version:** 0.8.20
- **Test Coverage:** 95%+ (target)
- **Lines of Code:** ~10,000+
- **Smart Contracts:** 15+ core contracts
- **Test Cases:** 100+ tests
- **Documentation Pages:** 20+ documents

---

## 🏆 Acknowledgments

Built with:
- [Foundry](https://book.getfoundry.sh/) - Ethereum development framework
- [Solady](https://github.com/Vectorized/solady) - Gas-optimized Solidity libraries
- [OpenZeppelin](https://openzeppelin.com/) - Secure smart contract libraries (optional)

Inspired by:
- Uniswap V3 concentrated liquidity
- Ekubo Protocol (StarkNet implementation)

---

## 📈 Recent Updates

**December 8, 2025:**
- ✅ Added flexible licensing tiers (4 options)
- ✅ Created LICENSE_PURCHASE_OPTIONS.md
- ✅ Updated all revenue documentation to support multiple tiers
- ✅ Added automated revenue tracking script
- ✅ Created deployment scripts
- ✅ Completed root README.md

---

**Ready to get started?** Choose your [license tier](./LICENSE_PURCHASE_OPTIONS.md) and begin building! 🚀

---

**Last Updated:** December 8, 2025  
**Version:** 1.0.0  
**License:** Ekubo DAO Shared Revenue License 1.0