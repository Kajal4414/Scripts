# 1. Determine Firefox profile path
$profilePath = (Get-Item "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release").FullName

# 2. Create Chrome folder if it doesn't exist
$chromeFolder = Join-Path $profilePath "chrome"
New-Item -Path $chromeFolder -ItemType Directory -Force | Out-Null

# 3. Download theme files directly from GitHub
$downloadUrl = "https://github.com/datguypiko/Firefox-Mod-Blur/archive/refs/heads/main.zip"
$downloadPath = Join-Path $env:TEMP "Firefox-Mod-Blur.zip"
Invoke-WebRequest $downloadUrl -OutFile $downloadPath

# 4. Extract theme files to Chrome folder
Expand-Archive -Path $downloadPath -DestinationPath $chromeFolder -Force

# 5. Optional: Download and apply acrylic_micaforeveryone.css for enhanced blur effect
$micaCssUrl = "https://github.com/datguypiko/Firefox-Mod-Blur/blob/main/EXTRA%20THEMES/acrylic_micaforeveryone.css"
$micaCssPath = Join-Path $chromeFolder "acrylic_micaforeveryone.css"
Invoke-WebRequest $micaCssUrl -OutFile $micaCssPath

# 6. Notify user about required Firefox settings
Write-Output "Theme files installed successfully!"
Write-Output "Please remember to adjust the following settings in Firefox for full effect:"
Write-Output "- Set 'Theme' to Light or Dark in Settings > Appearance."
Write-Output "- Restart Firefox to apply the changes."
Write-Output "Optional: Install MicaForEveryone for additional blur effects (https://github.com/MicaForEveryone)."
