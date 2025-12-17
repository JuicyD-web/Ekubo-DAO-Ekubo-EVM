# Verification Scripts

This directory contains automated verification scripts to ensure the Ekubo Protocol meets all quality and compliance requirements.

## Requirements Verified

1. **Test Coverage:** Minimum 80% threshold
2. **Contract Sizes:** All contracts under 24kb (24,576 bytes) Ethereum limit
3. **Fuzz Tests:** Configured with 256 runs

## Scripts

### Unix/Linux/Mac

- **`check_coverage.sh`** - Verifies test coverage meets 80% threshold
- **`check_sizes.sh`** - Verifies all contracts are within 24kb limit
- **`verify_all.sh`** - Runs all verification checks in sequence
- **`view_forks.sh`** - Quick view of repository forks using curl and jq

### Windows

- **`check_coverage.ps1`** - Coverage verification (PowerShell)
- **`check_sizes.ps1`** - Size verification (PowerShell)

### Python

- **`track_revenue.py`** - Automated revenue tracking from on-chain events
- **`monitor_forks.py`** - Monitor and list all repository forks from GitHub

## Usage

### Run All Verifications (Unix/Linux/Mac)

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Run complete verification suite
./scripts/verify_all.sh
```

### Individual Checks (Unix/Linux/Mac)

```bash
# Check coverage only
./scripts/check_coverage.sh

# Check contract sizes only
./scripts/check_sizes.sh
```

### Windows (PowerShell)

```powershell
# Check coverage
.\scripts\check_coverage.ps1

# Check sizes
.\scripts\check_sizes.ps1
```

### Manual Commands

```bash
# Coverage
forge coverage --report summary

# Contract sizes
forge build --sizes

# Run tests with fuzz
forge test -vv
```

## Expected Output

### ✅ Successful Verification

```
================================================
Ekubo Protocol - Complete Verification Suite
================================================

✅ All tests passed
✅ Coverage verification passed (85.2% >= 80%)
✅ Size verification passed (all contracts < 24kb)
✅ Fuzz runs configured: 256

================================================
ALL CHECKS PASSED
================================================
```

### ❌ Failed Verification

```
❌ FAIL: Coverage 75.3% is below 80% threshold
❌ FAIL: Core contract - 25,100 bytes EXCEEDS LIMIT
```

## Configuration

Verification settings are defined in [`foundry.toml`](../foundry.toml):

```toml
[profile.default]
fuzz = { runs = 256 }
coverage_threshold = 80
bytecode_size_limit = 24576
```

## CI/CD Integration

These scripts can be integrated into GitHub Actions or other CI/CD pipelines:

```yaml
- name: Run Verification
  run: ./scripts/verify_all.sh
```

## Troubleshooting

### Coverage Below 80%

1. Add unit tests for untested functions
2. Add integration tests
3. Test edge cases
4. Check for missing test files

### Contract Size Over 24kb

1. Increase optimizer runs in foundry.toml
2. Enable `via_ir` compilation
3. Split large contracts into libraries
4. Use external functions instead of public
5. Remove unused code

### Fuzz Tests Not Running

1. Verify foundry.toml configuration
2. Check test function names start with `testFuzz`
3. Run with `-vvv` for detailed output

## Reports

All scripts generate timestamped reports:

- `coverage_report_YYYYMMDD_HHMMSS.txt`
- `size_report_YYYYMMDD_HHMMSS.txt`

## Requirements

- Foundry (forge, cast)
- bash (for .sh scripts)
- PowerShell 5.1+ (for .ps1 scripts)
- Python 3.8+ (for revenue tracking)
- bc (for bash floating point math)

## Fork Monitoring

### Track Repository Forks

Monitor who has forked the repository for license compliance:

**Quick View (Bash):**
```bash
# Basic view (no token required, but limited)
./scripts/view_forks.sh

# With GitHub token for higher limits
./scripts/view_forks.sh YOUR_GITHUB_TOKEN

# Or using environment variable
export GITHUB_TOKEN="your_github_token"
./scripts/view_forks.sh
```

**Detailed Analysis (Python):**
```bash
# Install dependencies
pip install requests tabulate

# List all forks (basic)
python scripts/monitor_forks.py

# Use GitHub token for higher rate limits
export GITHUB_TOKEN="your_github_token"
python scripts/monitor_forks.py

# Output as JSON
python scripts/monitor_forks.py --output json

# Output as CSV
python scripts/monitor_forks.py --output csv > forks.csv
```

**Features:**
- Lists all public forks with owner, stars, creation date
- Shows fork statistics
- Supports multiple output formats (table, JSON, CSV)
- Respects GitHub API rate limits
- Works with or without GitHub token (token recommended)

**Use Cases:**
- License compliance monitoring
- Identify derivative projects
- Track community engagement
- Export fork data for analysis

See [FORKS_REGISTRY.md](../governance/FORKS_REGISTRY.md) for more information.

---

## Support

For issues with verification scripts:
- Email: aksels.laivenieks@outlook.com
- GitHub Issues: Label `build-system`