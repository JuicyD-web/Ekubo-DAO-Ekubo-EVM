# FORKS_REGISTRY.md

## Registry of Ekubo Protocol EVM Forks and Derivatives

This registry tracks all known forks, derivatives, and copies of the Ekubo Protocol EVM implementation to ensure license compliance and facilitate communication with licensees.

---

## 📊 How to View All Forks

### GitHub Network View

You can view all public forks of this repository through GitHub:

1. **Network Members Page:** [https://github.com/JuicyD-web/Ekubo-DAO-Ekubo-EVM/network/members](https://github.com/JuicyD-web/Ekubo-DAO-Ekubo-EVM/network/members)
2. **Fork Count:** Displayed at the top of the repository homepage
3. **Insights Tab:** Visit the "Insights" > "Network" tab for a visual representation

### Using GitHub API

You can also fetch fork information programmatically:

```bash
# List all forks (requires GitHub token for pagination)
curl -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/JuicyD-web/Ekubo-DAO-Ekubo-EVM/forks?per_page=100

# Get fork count
curl -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/JuicyD-web/Ekubo-DAO-Ekubo-EVM | jq '.forks_count'
```

---

## 📝 Registered Derivatives and Deployments

This section tracks forks and derivatives that have registered with Ekubo DAO for license compliance.

| Fork/Derivative Name | Repository URL | Operator/Organization | License Tier | Registration Date | Status | Notes |
|---------------------|----------------|----------------------|--------------|-------------------|--------|-------|
| [Example Fork 1]    | https://github.com/... | [Organization Name] | Option 1 (50%) | [YYYY-MM-DD] | ✅ Active | [Notes] |
| [Example Fork 2]    | https://github.com/... | [Organization Name] | Option 3 (10% + $100k) | [YYYY-MM-DD] | ✅ Active | [Notes] |

---

## 🔔 Registration Requirements

### Why Register Your Fork?

Even though forks are public on GitHub, **registration is mandatory** for:

1. **License Compliance** - Ensure you're meeting revenue sharing obligations
2. **Support Access** - Get technical support based on your license tier
3. **Communication** - Receive important updates, security patches, and notifications
4. **Governance Participation** - Participate in protocol governance (if applicable)
5. **Legal Compliance** - Fulfill the registration requirements under Section 4 of the license

### How to Register

If you have forked this repository and plan to deploy or use it:

1. **Create a GitHub Issue**
   - Use the label: `fork-registration`
   - Template: See [Fork Registration Template](#fork-registration-template) below

2. **Provide Required Information**
   - Fork repository URL
   - Organization/individual name
   - Intended use (development, testing, production)
   - Selected license tier (Option 1-4)
   - Expected deployment date
   - Contact information

3. **Submit License Agreement**
   - If selecting Option 2, 3, or 4, sign the license agreement
   - Provide payment information for annual fees

4. **Receive Confirmation**
   - Ekubo DAO will review and confirm registration
   - You'll be added to this registry
   - Receive access to tier-appropriate support channels

---

## 📋 Fork Registration Template

When creating a fork registration issue, use this template:

```markdown
## Fork Registration Request

**Fork Repository URL:** https://github.com/[your-username]/[your-fork-name]

**Organization/Individual Name:** [Your Name or Organization]

**Contact Information:**
- Primary Contact: [Name]
- Email: [email@example.com]
- GitHub Username: [@username]

**Intended Use:**
- [ ] Development/Testing Only
- [ ] Production Deployment
- [ ] Research/Educational

**Selected License Tier:**
- [ ] Option 1: 50% revenue share, $0 annual fee
- [ ] Option 2: 25% revenue share, $50,000/year
- [ ] Option 3: 10% revenue share, $100,000/year
- [ ] Option 4: 5% revenue share, $125,000/year

**Expected Deployment Date:** [YYYY-MM-DD]

**Estimated Annual Revenue:** $[amount] (if applicable)

**Deployment Networks:**
- [ ] Ethereum Mainnet
- [ ] Other EVM chains: [list]
- [ ] Testnet only

**Additional Notes:**
[Any additional information, questions, or special circumstances]

---

By submitting this registration, I acknowledge that:
- I have read and agree to the Ekubo DAO Shared Revenue License 1.0
- I understand the revenue sharing obligations of my selected tier
- I will comply with all reporting and payment requirements
- I will register all production deployments in DEPLOYMENT_REGISTRY.md
```

---

## 🚨 Unregistered Forks

### Compliance Monitoring

The Ekubo DAO actively monitors for:
- Public forks on GitHub
- On-chain deployments
- Protocol usage patterns

### Enforcement

Unregistered forks or deployments that violate license terms may face:
1. **Notice of Violation** - Initial contact requesting registration
2. **Community Alert** - Public notification of non-compliance
3. **Legal Action** - Enforcement of license terms through legal channels
4. **Blacklist** - Exclusion from future protocol updates and support

### Voluntary Compliance

We encourage voluntary compliance. If you have:
- Forked the repository for learning purposes only → Register as "Development/Testing"
- Deployed without registration → Contact us immediately to rectify
- Questions about compliance → Create an issue with label `compliance-question`

---

## 📊 Statistics

This section provides transparency about repository usage:

**Total Public Forks:** [Auto-updated via GitHub API]

**Registered Forks:** 0

**Active Production Deployments:** 0 (see [DEPLOYMENT_REGISTRY.md](./DEPLOYMENT_REGISTRY.md))

**License Tier Distribution:**
- Option 1 (50%): 0
- Option 2 (25% + $50k): 0
- Option 3 (10% + $100k): 0
- Option 4 (5% + $125k): 0

---

## 🔍 Monitoring Tools

### For Ekubo DAO

Scripts to monitor forks and compliance:

```bash
# List all forks with activity
python scripts/monitor_forks.py

# Check for on-chain deployments
python scripts/check_deployments.py

# Generate compliance report
python scripts/generate_compliance_report.py
```

### For Licensees

Self-audit your compliance:

```bash
# Verify your revenue calculations
python scripts/track_revenue.py --verify

# Check reporting status
python scripts/check_reporting_status.py
```

---

## 📞 Contact

### For Fork Registration
- **Email:** aksels.laivenieks@outlook.com
- **GitHub Issue:** Create with label `fork-registration`
- **Response Time:** 2-3 business days

### For Compliance Questions
- **Email:** aksels.laivenieks@outlook.com
- **GitHub Issue:** Create with label `compliance-question`
- **Response Time:** 1-2 business days

---

## 📚 Related Documentation

- **[LICENSE.md](../LICENSE.md)** - Full license terms
- **[DERIVATIVE_COMPLIANCE.md](../DERIVATIVE_COMPLIANCE.md)** - Derivative works guide
- **[DEPLOYMENT_REGISTRY.md](./DEPLOYMENT_REGISTRY.md)** - Track production deployments
- **[REVENUE_SHARING.md](../revenue/REVENUE_SHARING.md)** - Revenue sharing requirements
- **[GOVERNANCE_STRUCTURE.md](./GOVERNANCE.md)** - Governance model

---

**Last Updated:** December 17, 2025  
**Maintained By:** Ekubo DAO  
**Version:** 1.0.0
