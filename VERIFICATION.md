# Verification & Compliance Requirements

This document outlines the technical requirements and verification procedures for the Ekubo Protocol EVM implementation.

## 📊 Requirements Summary

| Requirement | Threshold | Verification Method | Status |
|-------------|-----------|---------------------|--------|
| **Test Coverage** | ≥ 80% | `forge coverage` | ✅ Configured |
| **Contract Size** | < 24kb | `forge build --sizes` | ✅ Configured |
| **Fuzz Runs** | 256 | `foundry.toml` | ✅ Set |
| **Optimizer Runs** | 200 | `foundry.toml` | ✅ Set |

## 🔍 Quick Verification

Run all checks:
```bash
./scripts/verify_all.sh
```

Or individually:
```bash
# Coverage
./scripts/check_coverage.sh

# Sizes
./scripts/check_sizes.sh

# Manual
forge test && forge coverage && forge build --sizes
```

## 📋 Detailed Requirements

### 1. Test Coverage: 80% Minimum

**Why:** Ensures code quality and reduces bugs

**Verification:**
```bash
forge coverage --report summary
```

**Expected Output:**
```
Total: 85.2%
```

**Configuration:** [`foundry.toml`](foundry.toml)
```toml
coverage_threshold = 80
```

### 2. Contract Size: 24kb Limit

**Why:** Ethereum enforces 24,576 byte contract size limit

**Verification:**
```bash
forge build --sizes
```

**Expected Output:**
```
Contract    Size (bytes)
Core        18,234       ✅
Router      21,456       ✅
Positions   15,678       ✅
```

**Configuration:** [`foundry.toml`](foundry.toml)
```toml
bytecode_size_limit = 24576
```

### 3. Fuzz Testing: 256 Runs

**Why:** Property-based testing finds edge cases

**Verification:**
```bash
forge test --match-test testFuzz -vv
```

**Expected Output:**
```
[PASS] testFuzzSwap(uint256) (runs: 256, μ: 48932, ~: 48932)
```

**Configuration:** [`foundry.toml`](foundry.toml)
```toml
fuzz = { runs = 256 }
```

## 🛠️ Optimization Tips

### If Coverage < 80%

1. **Add unit tests:**
   ```solidity
   function testSpecificFunction() public {
       // Test implementation
   }
   ```

2. **Add fuzz tests:**
   ```solidity
   function testFuzz_SpecificFunction(uint256 amount) public {
       // Fuzz test implementation
   }
   ```

3. **Add integration tests:**
   ```solidity
   function testIntegration_CompleteFlow() public {
       // End-to-end test
   }
   ```

### If Contract Size > 24kb

1. **Increase optimizer runs:**
   ```toml
   optimizer_runs = 999
   ```

2. **Enable via-ir:**
   ```toml
   via_ir = true
   ```

3. **Extract to libraries:**
   ```solidity
   library ComplexLogic {
       function doStuff() internal { }
   }
   ```

4. **Use external functions:**
   ```solidity
   function publicFn() external { }  // Smaller bytecode
   ```

## 📈 CI/CD Integration

Add to `.github/workflows/test.yml`:

```yaml
- name: Verify Requirements
  run: |
    forge test
    forge coverage --report summary
    forge build --sizes
    ./scripts/verify_all.sh
```

## 📞 Support

Issues with verification:
- **Email:** aksels.laivenieks@outlook.com
- **GitHub:** Label `build-system`

## ✅ Pre-Deployment Checklist

Before deploying to mainnet:

- [ ] All tests pass (`forge test`)
- [ ] Coverage ≥ 80% (`./scripts/check_coverage.sh`)
- [ ] All contracts < 24kb (`./scripts/check_sizes.sh`)
- [ ] Fuzz tests run 256 times
- [ ] No compiler warnings
- [ ] Security audit completed
- [ ] Gas optimization reviewed

---

**Last Updated:** December 8, 2025