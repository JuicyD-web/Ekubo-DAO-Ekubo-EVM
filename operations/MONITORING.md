# Monitoring Guide

This guide explains how to monitor Ekubo Protocol EVM deployments for health, performance, and security.

---

## What to Monitor

- **Contract Events:** Track swaps, liquidity changes, and protocol-specific events.
- **Transaction Activity:** Monitor transaction volume, gas usage, and failed transactions.
- **Revenue Tracking:** Verify fee collection and revenue reporting.
- **Security Alerts:** Watch for unusual activity, failed calls, or suspicious transactions.
- **Performance Metrics:** Monitor latency, throughput, and resource usage.

---

## Tools & Services

- **Block Explorers:** Etherscan, Blockscout for real-time contract and transaction monitoring.
- **Analytics Dashboards:** Dune Analytics, Nansen, or custom dashboards for protocol metrics.
- **Alerting Services:** Forta, OpenZeppelin Defender, or custom scripts for automated alerts.
- **Log Aggregation:** Use tools like Grafana, Prometheus, or ELK stack for advanced monitoring.

---

## Setting Up Monitoring

1. **Subscribe to Contract Events**
   - Use Web3 libraries (ethers.js, web3.py) to listen for relevant events.
   - Example (ethers.js):
     ```javascript
     contract.on("Swap", (sender, tokenIn, tokenOut, amountIn, amountOut) => {
       // Handle event
     });
     ```

2. **Automate Revenue Checks**
   - Schedule scripts to aggregate and verify protocol revenue.
   - Compare on-chain data with reported figures.

3. **Configure Alerts**
   - Set thresholds for abnormal activity (e.g., large withdrawals, failed transactions).
   - Integrate with email, Slack, or Discord for notifications.

4. **Regular Audits**
   - Periodically review contract state, balances, and event logs.
   - Document findings and address anomalies.

---

## Incident Response

- Follow the [INCIDENT_RESPONSE.md](../security/INCIDENT_RESPONSE.md) procedure for any detected issues.

---

## Reporting

- Archive monitoring logs and reports for compliance and governance review.
- Share critical findings with the DAO and community as needed.

---

## References

- [Foundry Documentation](https://book.getfoundry.sh/)
- [INCIDENT_RESPONSE.md](../security/INCIDENT_RESPONSE.md)

---

**Last Updated:** November 29, 2025