# PowerShell version for Windows users
# Coverage Verification Script

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Ekubo Protocol - Coverage Verification" -ForegroundColor Cyan
Write-Host "Required Threshold: 80%" -ForegroundColor Cyan
Write-Host "Fuzz Runs: 256" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Run coverage analysis
Write-Host "Running coverage analysis..." -ForegroundColor Yellow
forge coverage --report summary | Out-File -FilePath coverage_report.txt

# Display report
Write-Host ""
Write-Host "Coverage Report:" -ForegroundColor Yellow
Write-Host "----------------"
Get-Content coverage_report.txt
Write-Host ""

# Extract coverage percentage
$coverageLines = Get-Content coverage_report.txt | Select-String "Total"
if ($coverageLines) {
    $coverageLine = $coverageLines[0].ToString()
    $coverage = [regex]::Match($coverageLine, "(\d+\.?\d*)%").Groups[1].Value
    
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "Coverage Result: $coverage%" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    
    if ([double]$coverage -lt 80) {
        Write-Host "❌ FAIL: Coverage $coverage% is below 80% threshold" -ForegroundColor Red
        Write-Host ""
        Write-Host "Actions required:" -ForegroundColor Yellow
        Write-Host "  1. Add more unit tests"
        Write-Host "  2. Add integration tests"
        Write-Host "  3. Ensure all functions are tested"
        exit 1
    } else {
        Write-Host "✅ PASS: Coverage $coverage% meets 80% threshold" -ForegroundColor Green
    }
} else {
    Write-Host "❌ ERROR: Could not extract coverage percentage" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Coverage verification complete!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan