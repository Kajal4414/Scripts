# 1. Determine Firefox profile path
$profilePath = (Get-Item "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release").FullName

# 2. Create Chrome folder if it doesn't exist
$chromeFolder = Join-Path $profilePath "chrome"
New-Item -Path $chromeFolder -ItemType Directory -Force | Out-Null

# 3. Download theme files directly from GitHub
$downloadUrl = "https://codeload.github.com/datguypiko/Firefox-Mod-Blur/zip/refs/heads/master"
$downloadPath = Join-Path $env:TEMP "Firefox-Mod-Blur.zip"
curl.exe -o $downloadPath -LSs $downloadUrl

# 4. Extract theme files to Chrome folder
Expand-Archive -Path $downloadPath -DestinationPath $chromeFolder -Force

# 5. Delete downloaded theme zip
Remove-Item $downloadPath

# 6. Delete extra mod files, Exclude ASSETS folder, userChrome.css, and userContent.css
Get-ChildItem -Path $chromeFolder -Exclude ASSETS, userChrome.css, userContent.css | Remove-Item -Recurse -Force

# 7. Notify user about required Firefox settings
Write-Output "Theme files installed successfully!"
Write-Output "Please remember to adjust the following settings in Firefox for full effect:"
Write-Output "- Set 'Theme' to Light or Dark in Settings > Appearance."
Write-Output "- Restart Firefox to apply the changes."
Write-Output "Optional: Install MicaForEveryone for additional blur effects (https://github.com/MicaForEveryone)."
