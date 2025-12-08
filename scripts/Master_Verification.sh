#!/bin/bash
# Master Verification Script
# Runs all verification checks: coverage, size, and fuzz tests

set -e

echo "================================================"
echo "Ekubo Protocol - Complete Verification Suite"
echo "================================================"
echo ""
echo "This script will verify:"
echo "  1. Test coverage meets 80% threshold"
echo "  2. All contracts within 24kb size limit"
echo "  3. Fuzz tests configured with 256 runs"
echo ""
echo "================================================"
echo ""

# Track overall status
OVERALL_STATUS=0

# 1. Run tests first
echo "Step 1: Running all tests..."
echo "================================================"
if forge test -vv; then
    echo "✅ All tests passed"
else
    echo "❌ Some tests failed"
    OVERALL_STATUS=1
fi
echo ""

# 2. Check coverage
echo "Step 2: Verifying coverage (80% threshold)..."
echo "================================================"
if bash scripts/check_coverage.sh; then
    echo "✅ Coverage verification passed"
else
    echo "❌ Coverage verification failed"
    OVERALL_STATUS=1
fi
echo ""

# 3. Check contract sizes
echo "Step 3: Verifying contract sizes (24kb limit)..."
echo "================================================"
if bash scripts/check_sizes.sh; then
    echo "✅ Size verification passed"
else
    echo "❌ Size verification failed"
    OVERALL_STATUS=1
fi
echo ""

# 4. Verify fuzz configuration
echo "Step 4: Verifying fuzz configuration..."
echo "================================================"
FUZZ_RUNS=$(grep -A 1 "\[profile.default\]" foundry.toml | grep "fuzz" | grep -oP "runs = \K\d+")

if [ "$FUZZ_RUNS" == "256" ]; then
    echo "✅ Fuzz runs configured: 256"
else
    echo "❌ Fuzz runs not properly configured (found: $FUZZ_RUNS, expected: 256)"
    OVERALL_STATUS=1
fi
echo ""

# 5. Run sample fuzz test
echo "Running sample fuzz tests..."
if forge test --match-test testFuzz -vv 2>&1 | grep -q "runs: 256"; then
    echo "✅ Fuzz tests running with 256 runs"
else
    echo "⚠️  Warning: Could not verify fuzz run count"
fi
echo ""

# Final summary
echo "================================================"
echo "Verification Summary"
echo "================================================"
echo ""

if [ $OVERALL_STATUS -eq 0 ]; then
    echo "✅ ALL CHECKS PASSED"
    echo ""
    echo "Summary:"
    echo "  ✅ All tests passing"
    echo "  ✅ Coverage >= 80%"
    echo "  ✅ All contracts < 24kb"
    echo "  ✅ Fuzz runs = 256"
    echo ""
    echo "Repository is ready for deployment!"
else
    echo "❌ SOME CHECKS FAILED"
    echo ""
    echo "Please review the errors above and fix issues before deployment."
    exit 1
fi

echo "================================================"
echo "Verification complete!"
echo "================================================"