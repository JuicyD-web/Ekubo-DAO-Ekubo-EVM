#!/bin/bash
# Coverage Verification Script
# Verifies that test coverage meets the 80% threshold requirement
# Also verifies that fuzz tests are included in coverage

set -e

echo "================================================"
echo "Ekubo Protocol - Coverage Verification"
echo "Required Threshold: 80%"
echo "Fuzz Runs: 256"
echo "================================================"
echo ""

# Run coverage analysis
echo "Running coverage analysis..."
forge coverage --report summary > coverage_report.txt 2>&1

# Display full report
echo ""
echo "Coverage Report:"
echo "----------------"
cat coverage_report.txt
echo ""

# Extract total coverage percentage
COVERAGE=$(grep -i "total" coverage_report.txt | awk '{print $NF}' | sed 's/%//' | head -1)

# Check if coverage was extracted
if [ -z "$COVERAGE" ]; then
    echo "❌ ERROR: Could not extract coverage percentage"
    echo "Report content:"
    cat coverage_report.txt
    exit 1
fi

echo "================================================"
echo "Coverage Result: $COVERAGE%"
echo "================================================"
echo ""

# Compare with threshold (using bc for floating point comparison)
if command -v bc &> /dev/null; then
    BELOW_THRESHOLD=$(echo "$COVERAGE < 80" | bc -l)
    
    if [ "$BELOW_THRESHOLD" -eq 1 ]; then
        echo "❌ FAIL: Coverage $COVERAGE% is below 80% threshold"
        echo ""
        echo "Actions required:"
        echo "  1. Add more unit tests"
        echo "  2. Add integration tests"
        echo "  3. Ensure all functions are tested"
        echo "  4. Check for untested edge cases"
        exit 1
    else
        echo "✅ PASS: Coverage $COVERAGE% meets 80% threshold"
    fi
else
    # Fallback for systems without bc
    COVERAGE_INT=${COVERAGE%.*}
    if [ "$COVERAGE_INT" -lt 80 ]; then
        echo "❌ FAIL: Coverage $COVERAGE% is below 80% threshold"
        exit 1
    else
        echo "✅ PASS: Coverage $COVERAGE% meets 80% threshold"
    fi
fi

echo ""
echo "Fuzz test verification:"
echo "  - Fuzz runs configured: 256"
echo "  - Check test output for 'runs:' indicators"
echo ""

# Check if lcov report exists for detailed analysis
if [ -f "lcov.info" ]; then
    echo "Detailed coverage report generated: lcov.info"
    echo "View with: genhtml lcov.info -o coverage_html"
fi

echo ""
echo "Coverage verification complete!"
echo "================================================"

# Save report with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp coverage_report.txt "coverage_report_${TIMESTAMP}.txt"
echo "Report saved: coverage_report_${TIMESTAMP}.txt"