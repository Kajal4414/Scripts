# Get current charging limit from registry
$currentThreshold = (Get-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -ErrorAction Stop).ChargingRate
Write-Host "Current Battery Charging Limit: $currentThreshold%`n" -ForegroundColor Cyan

# Charging threshold to be set
$chargingThreshold = 40

# Check if the current threshold is already 40
if ($currentThreshold -ne $chargingThreshold) {
    # Set charging threshold in registry
    Set-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -Name ChargingRate -Value $chargingThreshold -ErrorAction Stop
    Write-Host "`nBattery Charging Limit Set To $chargingThreshold% In Registry" -ForegroundColor Green

    # Restart ASUSOptimization service
    Restart-Service -Name "ASUSOptimization" -ErrorAction Stop
    Write-Host "`nASUSOptimization Service Restarted" -ForegroundColor Green
} else {
    Write-Host "`nNo changes made. Battery Charging Limit is already set to $chargingThreshold%." -ForegroundColor Yellow
}
