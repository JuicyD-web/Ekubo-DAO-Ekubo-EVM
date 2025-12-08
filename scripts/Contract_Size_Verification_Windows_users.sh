# PowerShell version for Windows users
# Contract Size Verification Script

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Ekubo Protocol - Contract Size Verification" -ForegroundColor Cyan
Write-Host "Maximum Size: 24,576 bytes (24kb)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Build contracts
Write-Host "Building contracts..." -ForegroundColor Yellow
forge build | Select-Object -Last 5
Write-Host ""

# Check sizes
Write-Host "Checking contract sizes..." -ForegroundColor Yellow
forge build --sizes | Out-File -FilePath size_report.txt

# Display report
Write-Host ""
Write-Host "Contract Size Report:" -ForegroundColor Yellow
Write-Host "---------------------"
Get-Content size_report.txt
Write-Host ""

# Parse and check each contract
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Size Verification Results:" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$oversized = 0
$warnings = 0
$maxSize = 24576

$lines = Get-Content size_report.txt
foreach ($line in $lines) {
    if ($line -match "^\s*(\S+)\s+(\d+)") {
        $contract = $matches[1]
        $size = [int]$matches[2]
        
        if ($contract -eq "Contract") { continue }
        
        $percentage = [math]::Round(($size * 100) / $maxSize, 2)
        
        if ($size -gt $maxSize) {
            Write-Host "❌ FAIL: $contract - $size bytes ($percentage%) EXCEEDS LIMIT" -ForegroundColor Red
            $oversized++
        } elseif ($size -gt 22000) {
            Write-Host "⚠️  WARN: $contract - $size bytes ($percentage%) - Close to limit" -ForegroundColor Yellow
            $warnings++
        } else {
            Write-Host "✅ PASS: $contract - $size bytes ($percentage%)" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

if ($oversized -gt 0) {
    Write-Host "❌ FAIL: $oversized contract(s) exceed 24kb limit" -ForegroundColor Red
    exit 1
} elseif ($warnings -gt 0) {
    Write-Host "⚠️  WARNING: $warnings contract(s) close to 24kb limit" -ForegroundColor Yellow
    Write-Host "✅ All contracts within size limit" -ForegroundColor Green
} else {
    Write-Host "✅ PASS: All contracts well within 24kb limit" -ForegroundColor Green
}

Write-Host ""
Write-Host "Size verification complete!" -ForegroundColor Green