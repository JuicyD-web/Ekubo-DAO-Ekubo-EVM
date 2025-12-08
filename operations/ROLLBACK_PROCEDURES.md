# Rollback Procedures

This guide explains how to safely rollback Ekubo Protocol EVM contracts and systems to a previous state.

---

## 1. When to Rollback

- Critical bugs or vulnerabilities in recent upgrade
- Failed upgrade or deployment
- Governance decision to revert changes

---

## 2. Pre-Rollback Checklist

- Assess impact and necessity of rollback
- Notify DAO governance and stakeholders
- Prepare backup of current state and data
- Review previous contract versions and deployment records

---

## 3. Governance Approval

- Submit rollback proposal to Ekubo DAO
- Obtain formal approval via DAO vote

---

## 4. Rollback Execution

- Pause affected contracts if possible
- Redeploy previous contract versions or restore proxy to prior implementation
- Verify contract addresses and logic
- Restore system configuration and permissions

---

## 5. Post-Rollback Actions

- Monitor for issues and confirm system stability
- Announce rollback completion to users and DAO
- Resume normal operations and revenue tracking

---

## 6. Documentation

- Record rollback details in [AUDIT_LOG.md](../governance/AUDIT_LOG.md)
- Update [DEPLOYMENT_REGISTRY.md](../governance/DEPLOYMENT_REGISTRY.md) with rollback info
- Archive rollback proposal and related documents

---

## References

- [AUDIT_LOG.md](../governance/AUDIT_LOG.md)
- [DEPLOYMENT_REGISTRY.md](../governance/DEPLOYMENT_REGISTRY.md)
- [INCIDENT_RESPONSE.md](../security/INCIDENT_RESPONSE.md)

---

**Last Updated:** November 29, 2025