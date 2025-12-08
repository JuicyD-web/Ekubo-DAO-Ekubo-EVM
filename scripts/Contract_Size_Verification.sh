#!/bin/bash
# Contract Size Verification Script
# Verifies that all contracts are within the 24kb (24,576 bytes) Ethereum limit

set -e

echo "================================================"
echo "Ekubo Protocol - Contract Size Verification"
echo "Maximum Size: 24,576 bytes (24kb)"
echo "================================================"
echo ""

# Build contracts
echo "Building contracts..."
forge build 2>&1 | tail -5
echo ""

# Check sizes
echo "Checking contract sizes..."
forge build --sizes > size_report.txt 2>&1

# Display report
echo ""
echo "Contract Size Report:"
echo "---------------------"
cat size_report.txt
echo ""

# Parse and check each contract
echo "================================================"
echo "Size Verification Results:"
echo "================================================"
echo ""

OVERSIZED=0
MAX_SIZE=24576
WARNINGS=0

# Check if report has data
if ! grep -q "Contract" size_report.txt; then
    echo "❌ ERROR: No contract size data found"
    exit 1
fi

# Process each contract line (skip header)
while IFS= read -r line; do
    # Skip empty lines and headers
    if [[ -z "$line" ]] || [[ "$line" =~ ^"Contract" ]] || [[ "$line" =~ ^"=" ]]; then
        continue
    fi
    
    # Extract contract name and size
    CONTRACT=$(echo "$line" | awk '{print $1}')
    SIZE=$(echo "$line" | awk '{print $2}' | sed 's/,//g')
    
    # Skip if SIZE is not a number
    if ! [[ "$SIZE" =~ ^[0-9]+$ ]]; then
        continue
    fi
    
    # Calculate percentage of limit
    PERCENTAGE=$(echo "scale=2; ($SIZE * 100) / $MAX_SIZE" | bc)
    
    # Status indicators
    if [ "$SIZE" -gt "$MAX_SIZE" ]; then
        echo "❌ FAIL: $CONTRACT - $SIZE bytes (${PERCENTAGE}%) EXCEEDS LIMIT"
        OVERSIZED=$((OVERSIZED + 1))
    elif [ "$SIZE" -gt 22000 ]; then
        echo "⚠️  WARN: $CONTRACT - $SIZE bytes (${PERCENTAGE}%) - Close to limit"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "✅ PASS: $CONTRACT - $SIZE bytes (${PERCENTAGE}%)"
    fi
done < <(tail -n +2 size_report.txt)

echo ""
echo "================================================"
echo "Summary:"
echo "================================================"

if [ "$OVERSIZED" -gt 0 ]; then
    echo "❌ FAIL: $OVERSIZED contract(s) exceed 24kb limit"
    echo ""
    echo "Actions required:"
    echo "  1. Enable optimizer with higher runs"
    echo "  2. Split large contracts into libraries"
    echo "  3. Use external functions instead of public"
    echo "  4. Remove unused code"
    echo "  5. Use via-ir compilation"
    exit 1
elif [ "$WARNINGS" -gt 0 ]; then
    echo "⚠️  WARNING: $WARNINGS contract(s) close to 24kb limit"
    echo "Consider optimizing to prevent future issues"
    echo ""
    echo "✅ All contracts within size limit"
else
    echo "✅ PASS: All contracts well within 24kb limit"
fi

echo ""

# Optimization suggestions for large contracts
LARGEST=$(sort -t' ' -k2 -nr size_report.txt | head -2 | tail -1)
if [ -n "$LARGEST" ]; then
    LARGEST_NAME=$(echo "$LARGEST" | awk '{print $1}')
    LARGEST_SIZE=$(echo "$LARGEST" | awk '{print $2}' | sed 's/,//g')
    
    if [ "$LARGEST_SIZE" -gt 20000 ]; then
        echo "Optimization tips for $LARGEST_NAME ($LARGEST_SIZE bytes):"
        echo "  - Current optimizer runs: 200"
        echo "  - Try increasing to 999 for deployment"
        echo "  - Consider enabling via-ir in foundry.toml"
        echo ""
    fi
fi

# Save report with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp size_report.txt "size_report_${TIMESTAMP}.txt"
echo "Report saved: size_report_${TIMESTAMP}.txt"

echo "================================================"
echo "Size verification complete!"