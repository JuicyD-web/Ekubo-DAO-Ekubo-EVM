#!/bin/bash
# Simple script to view forks using curl and jq
# Usage: ./view_forks.sh [GITHUB_TOKEN]

set -e

OWNER="JuicyD-web"
REPO="Ekubo-DAO-Ekubo-EVM"
GITHUB_TOKEN="${1:-${GITHUB_TOKEN}}"

echo "========================================"
echo "Ekubo Protocol EVM - Repository Forks"
echo "========================================"
echo ""

# Set up headers
if [ -n "$GITHUB_TOKEN" ]; then
    AUTH_HEADER="Authorization: Bearer $GITHUB_TOKEN"
else
    AUTH_HEADER=""
    echo "⚠️  No GitHub token provided. Rate limits apply."
    echo "   Set GITHUB_TOKEN env var or pass as argument"
    echo ""
fi

# Get repository info
echo "Fetching repository information..."
if [ -n "$AUTH_HEADER" ]; then
    REPO_INFO=$(curl -s -H "$AUTH_HEADER" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/$OWNER/$REPO")
else
    REPO_INFO=$(curl -s \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/$OWNER/$REPO")
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo ""
    echo "Repository: $OWNER/$REPO"
    echo "Fork Count: $(echo "$REPO_INFO" | grep -o '"forks_count":[0-9]*' | grep -o '[0-9]*')"
    echo "Stars: $(echo "$REPO_INFO" | grep -o '"stargazers_count":[0-9]*' | grep -o '[0-9]*')"
    echo ""
    echo "⚠️  'jq' not installed. Install jq for detailed fork information:"
    echo "   Ubuntu/Debian: sudo apt-get install jq"
    echo "   Mac: brew install jq"
    echo ""
    echo "For detailed fork list, visit:"
    echo "https://github.com/$OWNER/$REPO/network/members"
    exit 0
fi

# Parse and display repo info
FORK_COUNT=$(echo "$REPO_INFO" | jq -r '.forks_count')
STARS=$(echo "$REPO_INFO" | jq -r '.stargazers_count')
WATCHERS=$(echo "$REPO_INFO" | jq -r '.watchers_count')
DESCRIPTION=$(echo "$REPO_INFO" | jq -r '.description // "N/A"')

echo ""
echo "Repository: $OWNER/$REPO"
echo "Description: $DESCRIPTION"
echo "Total Forks: $FORK_COUNT"
echo "Stars: $STARS"
echo "Watchers: $WATCHERS"
echo ""
echo "========================================"
echo ""

if [ "$FORK_COUNT" -eq 0 ]; then
    echo "No forks found."
    exit 0
fi

# Fetch forks
echo "Fetching fork details..."
if [ -n "$AUTH_HEADER" ]; then
    FORKS=$(curl -s -H "$AUTH_HEADER" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/$OWNER/$REPO/forks?per_page=100&sort=newest")
else
    FORKS=$(curl -s \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/$OWNER/$REPO/forks?per_page=100&sort=newest")
fi

# Display forks
echo ""
printf "%-25s %-35s %-8s %-8s %-12s\n" "OWNER" "REPO NAME" "STARS" "FORKS" "CREATED"
echo "=========================================================================================================="

echo "$FORKS" | jq -r '.[] | 
    "\(.owner.login)|\(.name)|\(.stargazers_count)|\(.forks_count)|\(.created_at[0:10])"' | \
while IFS='|' read -r owner name stars forks created; do
    printf "%-25s %-35s %-8s %-8s %-12s\n" "$owner" "$name" "$stars" "$forks" "$created"
done

echo "=========================================================================================================="
echo ""

DISPLAYED=$(echo "$FORKS" | jq '. | length')
echo "Displayed: $DISPLAYED of $FORK_COUNT total forks"

if [ "$DISPLAYED" -lt "$FORK_COUNT" ]; then
    echo ""
    echo "⚠️  Only showing first 100 forks. For complete list:"
    echo "   - Use: python scripts/monitor_forks.py"
    echo "   - Or visit: https://github.com/$OWNER/$REPO/network/members"
fi

echo ""
echo "For more information, see: governance/FORKS_REGISTRY.md"
