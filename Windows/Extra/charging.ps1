# Get current charging limit from registry
$currentThreshold = (Get-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -ErrorAction Stop).ChargingRate
Write-Host "Current Battery Charging Limit: $currentThreshold%`n" -ForegroundColor Cyan

# Charging threshold
$chargingThreshold = 40

# Set charging threshold in registry
Set-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -Name ChargingRate -Value $chargingThreshold -ErrorAction Stop
Write-Host "`nBattery Charging Limit Set To $chargingThreshold% In Registry" -ForegroundColor Green

# Restart ASUSOptimization service
Restart-Service -Name "ASUSOptimization" -ErrorAction Stop
Write-Host "`nASUSOptimization Service Restarted" -ForegroundColor Green
