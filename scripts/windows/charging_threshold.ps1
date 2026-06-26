# https://github.com/sakshiagrwal/monitors/blob/main/charging_threshold.ps1

# Check if ASUSOptimization service exists
if (-not (Get-Service -Name "ASUSOptimization" -ErrorAction SilentlyContinue)) {
    Write-Host "Install 'ASUS System Control Interface' Drivers And Try Again.`n" -ForegroundColor Red
    Exit
}

# Get current charging limit from registry
try {
    $currentThreshold = (Get-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -ErrorAction Stop).ChargingRate
    Write-Host "Current Battery Charging Limit: $currentThreshold%`n" -ForegroundColor Cyan
} catch {
    Write-Host "Error Reading Limit From Registry: $($_.Exception.Message)" -ForegroundColor Red
    Exit
}

# Prompt user for valid charging limit
$validInput = $false
do {
    $chargingThreshold = Read-Host "Enter Battery Charging Limit (10-100)% "
    if ($chargingThreshold -match '^\d+$' -and [int]$chargingThreshold -ge 10 -and [int]$chargingThreshold -le 100) {
        $validInput = $true
    } else {
        Write-Host "Invalid Input. Enter A Number Between 10 and 100.`n" -ForegroundColor Red
    }
} while (-not $validInput)

# Set new charging limit in registry
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -Name ChargingRate -Value $chargingThreshold -ErrorAction Stop
    Write-Host "`nBattery Charging Limit Set To $chargingThreshold% In Registry" -ForegroundColor Green
} catch {
    Write-Host "Error Setting Battery Charging Limit In Registry: $($_.Exception.Message)" -ForegroundColor Red
    Exit
}

# Stop and disable other running ASUS services
Get-Service | Where-Object { $_.Name -like "*ASUS*" -and $_.Name -ne "ASUSOptimization" -and $_.Status -eq 'Running' } | ForEach-Object {
    try {
        Stop-Service -Name $_.Name -Force -ErrorAction Stop
        Set-Service -Name $_.Name -StartupType Disabled -ErrorAction Stop
        Write-Host "`n$($_.Name) Service Stopped And Disabled" -ForegroundColor Green
    } catch {
        Write-Host "Error Stopping $($_.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Restart ASUSOptimization service
try {
    Restart-Service -Name "ASUSOptimization" -ErrorAction Stop
    Write-Host "`nASUSOptimization Service Restarted" -ForegroundColor Green
} catch {
    Write-Host "Error Restarting ASUSOptimization: $($_.Exception.Message)" -ForegroundColor Red
}

# Success message
Write-Host "`nBattery Charging Limit Set To $chargingThreshold%" -ForegroundColor Cyan
