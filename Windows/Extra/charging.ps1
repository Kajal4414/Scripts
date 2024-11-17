$currentThreshold = (Get-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -ErrorAction Stop).ChargingRate
$chargingThreshold = 40

if ($currentThreshold -ne $chargingThreshold) {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" -Name ChargingRate -Value $chargingThreshold -ErrorAction Stop
    Restart-Service -Name "ASUSOptimization" -ErrorAction Stop
    Write-Host "`nBattery Charging Limit updated to $chargingThreshold% and ASUSOptimization service restarted." -ForegroundColor Green
} else {
    Write-Host "`nBattery Charging Limit is already set to $chargingThreshold%. No changes made." -ForegroundColor Yellow
}
