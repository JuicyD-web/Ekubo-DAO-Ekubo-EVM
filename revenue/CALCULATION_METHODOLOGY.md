# CALCULATION_METHODOLOGY.md

## Revenue Calculation Methodology for Ekubo Protocol EVM

This document provides detailed instructions on how to calculate revenue share payments based on your selected license tier under the Ekubo DAO Shared Revenue License 1.0.

**Last Updated:** December 8, 2025

---

## 📊 License Tier Overview

Your revenue share calculation depends on your selected license tier:

| License Tier | Revenue Share | Annual License Fee | Total Annual Cost Formula |
|--------------|---------------|-------------------|---------------------------|
| **Option 1** | 50% | $0 | Revenue × 0.50 |
| **Option 2** | 25% | $50,000 | $50,000 + (Revenue × 0.25) |
| **Option 3** | 10% | $100,000 | $100,000 + (Revenue × 0.10) |
| **Option 4** | 5% | $125,000 | $125,000 + (Revenue × 0.05) |

**See:** [LICENSE_PURCHASE_OPTIONS.md](../LICENSE_PURCHASE_OPTIONS.md) for tier selection guidance

---

## 🎯 Step-by-Step Calculation Process

### Step 1: Identify Your License Tier

Determine which license tier you are operating under:
- **Default (if no tier purchased):** Option 1 (50% revenue share)
- **Purchased tier:** Option 2, 3, or 4

**Example:** You purchased Option 3 license in Q1 2025.

---

### Step 2: Define the Reporting Period

Revenue is calculated **quarterly**:
- **Q1:** January 1 - March 31
- **Q2:** April 1 - June 30
- **Q3:** July 1 - September 30
- **Q4:** October 1 - December 31

**Example:** Calculating for Q2 2025 (April 1 - June 30, 2025)

---

### Step 3: Collect Revenue Data

#### A. What Counts as Revenue? ✅

**Include all protocol-generated income:**
- Trading fees collected from swaps
- Liquidity provider fees (protocol's share only)
- Protocol-owned liquidity earnings
- Flash loan fees
- Administrative fees
- Any other monetized protocol features

#### B. What Does NOT Count as Revenue? ❌

**Exclude the following:**
- User deposits (returned to users)
- Gas fees paid by users (go to validators/miners)
- Operational costs (infrastructure, salaries, marketing)
- Donations or grants received
- Investment capital raised
- TVL (Total Value Locked) - not revenue

**Example Revenue Sources (Q2 2025):**
```
Trading Fees:           10.5 ETH
LP Fees (Protocol):      3.2 ETH
Flash Loan Fees:         1.8 ETH
Other Protocol Income:   0.5 ETH
                       ─────────
Gross Revenue:          16.0 ETH
```

---

### Step 4: Calculate Gross Revenue

Sum all qualifying revenue sources for the quarter.

**Formula:**
```
Gross Revenue = Sum of all protocol-generated income
```

**Example:**
```
Gross Revenue = 10.5 + 3.2 + 1.8 + 0.5 = 16.0 ETH
```

---

### Step 5: Deduct Direct Transaction Costs (Optional)

You may deduct **direct transaction costs** paid by the protocol (not users):
- Gas fees paid by protocol-owned addresses
- On-chain operation costs directly related to revenue generation

**NOT deductible:**
- Infrastructure costs (servers, RPC nodes)
- Development costs
- Marketing costs
- Team salaries

**Formula:**
```
Net Revenue = Gross Revenue - Direct Transaction Costs
```

**Example:**
```
Gross Revenue:              16.0 ETH
Direct Transaction Costs:    0.5 ETH
                           ─────────
Net Revenue:                15.5 ETH
```

---

### Step 6: Calculate Revenue Share Payment

Calculate the payment based on your license tier's revenue share percentage.

#### **Option 1: Standard Revenue Share (50%)**

**Formula:**
```
Revenue Share = Net Revenue × 0.50
```

**Example:**
```
Net Revenue:        15.5 ETH
Revenue Share:      15.5 × 0.50 = 7.75 ETH
Annual Fee:         $0
                   ─────────────────────
Total Q2 Payment:   7.75 ETH + $0
```

**Payments Due:**
- Revenue share: **7.75 ETH**
- License fee: **$0**

---

#### **Option 2: Reduced Share + Annual License (25%)**

**Formula:**
```
Revenue Share = Net Revenue × 0.25
Quarterly License Fee = $50,000 ÷ 4 = $12,500
```

**Example:**
```
Net Revenue:        15.5 ETH
Revenue Share:      15.5 × 0.25 = 3.875 ETH
Quarterly Fee:      $12,500 (or paid annually)
                   ─────────────────────
Total Q2 Payment:   3.875 ETH + $12,500
```

**Payments Due:**
- Revenue share: **3.875 ETH**
- License fee: **$12,500** (if paying quarterly) OR **$0** (if paid annually upfront)

---

#### **Option 3: Minimal Share + Premium License (10%)**

**Formula:**
```
Revenue Share = Net Revenue × 0.10
Quarterly License Fee = $100,000 ÷ 4 = $25,000
```

**Example:**
```
Net Revenue:        15.5 ETH
Revenue Share:      15.5 × 0.10 = 1.55 ETH
Quarterly Fee:      $25,000 (or paid annually)
                   ─────────────────────
Total Q2 Payment:   1.55 ETH + $25,000
```

**Payments Due:**
- Revenue share: **1.55 ETH**
- License fee: **$25,000** (if paying quarterly) OR **$0** (if paid annually upfront)

---

#### **Option 4: Enterprise License (5%)**

**Formula:**
```
Revenue Share = Net Revenue × 0.05
Quarterly License Fee = $125,000 ÷ 4 = $31,250
```

**Example:**
```
Net Revenue:        15.5 ETH
Revenue Share:      15.5 × 0.05 = 0.775 ETH
Quarterly Fee:      $31,250 (or paid annually)
                   ─────────────────────
Total Q2 Payment:   0.775 ETH + $31,250
```

**Payments Due:**
- Revenue share: **0.775 ETH**
- License fee: **$31,250** (if paying quarterly) OR **$0** (if paid annually upfront)

---

## 📋 Comparison of Q2 Payment Example Across All Tiers

**Given:** 15.5 ETH net revenue in Q2

| Tier | Revenue Share | License Fee (Quarterly) | Total ETH | Total USD (@ $3,000/ETH) |
|------|---------------|------------------------|-----------|-------------------------|
| **Option 1** | 7.75 ETH (50%) | $0 | 7.75 ETH | $23,250 |
| **Option 2** | 3.875 ETH (25%) | $12,500 | 3.875 ETH | $24,125 |
| **Option 3** | 1.55 ETH (10%) | $25,000 | 1.55 ETH | $29,650 |
| **Option 4** | 0.775 ETH (5%) | $31,250 | 0.775 ETH | $33,575 |

**Note:** ETH converted to USD at $3,000/ETH for comparison. Actual payments made in ETH + USD license fees.

---

## 💰 Annual Cost Projection Examples

### Scenario A: Low Revenue ($200,000/year or ~67 ETH @ $3,000/ETH)

| Tier | Annual Revenue Share | Annual License Fee | Total Annual Cost | Best? |
|------|---------------------|-------------------|------------------|-------|
| Option 1 | 33.5 ETH ($100,500) | $0 | $100,500 | ✅ |
| Option 2 | 16.75 ETH ($50,250) | $50,000 | $100,250 | ❌ |
| Option 3 | 6.7 ETH ($20,100) | $100,000 | $120,100 | ❌ |
| Option 4 | 3.35 ETH ($10,050) | $125,000 | $135,050 | ❌ |

**Best Choice:** Option 1 (Standard 50% revenue share)

---

### Scenario B: Medium Revenue ($500,000/year or ~167 ETH @ $3,000/ETH)

| Tier | Annual Revenue Share | Annual License Fee | Total Annual Cost | Best? |
|------|---------------------|-------------------|------------------|-------|
| Option 1 | 83.5 ETH ($250,500) | $0 | $250,500 | ❌ |
| Option 2 | 41.75 ETH ($125,250) | $50,000 | $175,250 | ❌ |
| Option 3 | 16.7 ETH ($50,100) | $100,000 | $150,100 | ✅ |
| Option 4 | 8.35 ETH ($25,050) | $125,000 | $150,050 | ✅ |

**Best Choice:** Option 3 or 4 (Option 4 slightly better with better support)

---

### Scenario C: High Revenue ($1,000,000/year or ~333 ETH @ $3,000/ETH)

| Tier | Annual Revenue Share | Annual License Fee | Total Annual Cost | Best? |
|------|---------------------|-------------------|------------------|-------|
| Option 1 | 166.5 ETH ($499,500) | $0 | $499,500 | ❌ |
| Option 2 | 83.25 ETH ($249,750) | $50,000 | $299,750 | ❌ |
| Option 3 | 33.3 ETH ($99,900) | $100,000 | $199,900 | ❌ |
| Option 4 | 16.65 ETH ($49,950) | $125,000 | $174,950 | ✅ |

**Best Choice:** Option 4 (Enterprise License)

---

## 🧮 Detailed Calculation Walkthrough

### Complete Example: Option 3 (10% + $100k/year)

**Quarter:** Q2 2025 (April 1 - June 30)

#### Step 1: Collect Raw Revenue Data

**On-chain transaction analysis:**
```
Swap #1234:   Fee = 0.05 ETH   (April 5)
Swap #1235:   Fee = 0.08 ETH   (April 12)
Swap #1236:   Fee = 0.03 ETH   (April 20)
... [continue for all Q2 swaps]

Total Swap Fees:           10.5 ETH
LP Fees (Protocol Share):   3.2 ETH
Flash Loan Fees:            1.8 ETH
Other Income:               0.5 ETH
```