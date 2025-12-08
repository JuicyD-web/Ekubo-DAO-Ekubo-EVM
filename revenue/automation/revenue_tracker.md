# Revenue Tracker Guide

This guide explains how to set up and use automation tools for tracking protocol revenue and preparing reports for Ekubo DAO.

---

## 1. Overview

Automated revenue tracking helps ensure accurate, timely, and transparent reporting. The process involves collecting on-chain data, aggregating revenue, calculating shares, and generating reports.

---

## 2. Tools & Prerequisites

- **Node.js or Python** (recommended for scripting)
- **Web3 library** (e.g., ethers.js, web3.py)
- **Access to Ethereum node or RPC provider** (e.g., Infura, Alchemy)
- **Spreadsheet software** (optional, for manual review)
- **Block explorer API** (e.g., Etherscan)

---

## 3. Setup

1. **Install dependencies**  
   - For Node.js:  
     `npm install ethers`
   - For Python:  
     `pip install web3 pandas`

2. **Configure RPC provider**  
   - Obtain an API key from Infura, Alchemy, or similar.

3. **Get contract addresses and ABI**  
   - Identify relevant smart contracts (e.g., AMM, fee collector).

---

## 4. Tracking Revenue (Sample Workflow)

### a. Fetch Events

- Use scripts to fetch relevant events (e.g., Swap, FeeCollected) from the blockchain.

#### Example (Python pseudocode):

```python
from web3 import Web3

w3 = Web3(Web3.HTTPProvider('YOUR_RPC_URL'))
contract = w3.eth.contract(address='CONTRACT_ADDRESS', abi='CONTRACT_ABI')
events = contract.events.FeeCollected.createFilter(fromBlock=START_BLOCK, toBlock=END_BLOCK).get_all_entries()
total_revenue = sum([e['args']['amount'] for e in events])
```

### b. Aggregate and Convert

- Aggregate all revenue sources.
- Convert non-ETH tokens to ETH using oracle prices.

### c. Calculate Ekubo DAO Share

- Apply the 20% share formula.

### d. Generate Reports

- Export results to CSV, Excel, or Markdown using templates from `/revenue/templates/`.

---

## 5. Automation & Scheduling

- Use cron jobs or task schedulers to run scripts periodically (e.g., weekly, monthly, quarterly).
- Store results in a secure location and back up regularly.

---

## 6. Verification

- Cross-check automated results with manual calculations or third-party analytics.
- Document all sources and calculation steps.

---

## 7. Troubleshooting

- Check RPC provider limits and API keys.
- Ensure contract ABI matches deployed contracts.
- Validate data integrity before reporting.

---

## 8. Resources

- [ethers.js documentation](https://docs.ethers.org/)
- [web3.py documentation](https://web3py.readthedocs.io/)
- [Etherscan API](https://docs.etherscan.io/)
- [Ekubo DAO Revenue Templates](../templates/)

---

**Last Updated:** November 29, 2025