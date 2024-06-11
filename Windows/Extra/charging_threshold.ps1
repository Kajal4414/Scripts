# https://github.com/sakshiagrwal/monitors/blob/main/charging_threshold.ps1

# Check if ASUSOptimization service exists
if (-not (Get-Service -Name "ASUSOptimization" -ErrorAction SilentlyContinue)) {
    Write-Host "ASUSOptimization service does not exist. Install the 'ASUS System Control Interface v3' drivers and try again."
    Exit
}

# Set the battery charging threshold to 80%
reg add "HKLM\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" /v ChargingRate /t REG_DWORD /d 80 /f

# Get all ASUS services except ASUSOptimization and disable them
Get-Service | Where-Object { $_.Name -like "*ASUS*" -and $_.Name -ne "ASUSOptimization" } | ForEach-Object {
    Set-Service -Name $_.Name -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Host "Disabled $($_.Name)"
}

# Restart the ASUSOptimization service
Restart-Service -Name "ASUSOptimization"

# Print a message indicating the battery charging threshold has been set
Write-Host "Battery charging threshold set to 80%."
