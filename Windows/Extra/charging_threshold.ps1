# https://github.com/sakshiagrwal/monitors/blob/main/charging_threshold.ps1

# Check if ASUSOptimization service exists
if (-not (Get-Service -Name "ASUSOptimization" -ErrorAction SilentlyContinue)) {
    Write-Host "Install 'ASUS System Control Interface' drivers and try again." -ForegroundColor Red
    Exit
}

# Get current charging threshold from registry
try {
    $currentThreshold = (Get-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -ErrorAction Stop).ChargingRate
    Write-Host "Current Threshold: $currentThreshold%" -ForegroundColor Cyan
} catch {
    Write-Host "Error reading threshold from registry: $($_.Exception.Message)" -ForegroundColor Red
    Exit
}

# Prompt user for valid charging threshold
$validInput = $false
do {
    $chargingThreshold = Read-Host "Enter Battery Charging Threshold (10-100)%"
    if ($chargingThreshold -match '^\d+$' -and [int]$chargingThreshold -ge 10 -and [int]$chargingThreshold -le 100) {
        $validInput = $true
    } else {
        Write-Host "Invalid input. Enter a number between 10 and 100." -ForegroundColor Red
    }
} while (-not $validInput)

# Set new charging threshold in registry
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -Name ChargingRate -Value $chargingThreshold -ErrorAction Stop
    Write-Host "Charging limit set to $chargingThreshold% in registry." -ForegroundColor Green
} catch {
    Write-Host "Error setting threshold in registry: $($_.Exception.Message)" -ForegroundColor Red
    Exit
}

# Stop and disable other running ASUS services
Get-Service | Where-Object { $_.Name -like "*ASUS*" -and $_.Name -ne "ASUSOptimization" -and $_.Status -eq 'Running' } | ForEach-Object {
    try {
        Stop-Service -Name $_.Name -Force -ErrorAction Stop
        Set-Service -Name $_.Name -StartupType Disabled -ErrorAction Stop
        Write-Host "$($_.Name) stopped and disabled." -ForegroundColor Green
    } catch {
        Write-Host "Error stopping $($_.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Restart ASUSOptimization service
try {
    Restart-Service -Name "ASUSOptimization" -ErrorAction Stop
    Write-Host "ASUSOptimization service restarted." -ForegroundColor Green
} catch {
    Write-Host "Error restarting ASUSOptimization: $($_.Exception.Message)" -ForegroundColor Red
}

# Success message
Write-Host "Battery charging limit set to $chargingThreshold%." -ForegroundColor Cyan
