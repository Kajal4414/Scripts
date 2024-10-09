# Variables
$platformToolsUrl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
$platformToolsPath = "$env:PROGRAMFILES\Android\Platform Tools"
$zipFilePath = "$env:TEMP\platform-tools.zip"

# Check for admin privileges
if (-not ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "`n[ERROR] Admin Privileges Required." -ForegroundColor Red; exit
}

# Fetch version and check internet
try { 
    Write-Host "`n[INFO] Fetching Remote Version..." -ForegroundColor Yellow
    $webContent = Invoke-WebRequest "https://developer.android.com/tools/releases/platform-tools" -UseBasicParsing
    $null = $webContent.Content -match '<h4 id=".*?" data-text="(\d+\.\d+\.\d+)'; $remoteVersion = $Matches[1]
    if (-not (Test-Connection 8.8.8.8 -Count 1 -Quiet)) { throw "Internet connection required" }
} catch { Write-Host "[ERROR] $_" -ForegroundColor Red; exit }

# Check local ADB version
if ($adb = Get-Command "adb" -ErrorAction SilentlyContinue) {
    $localVersion = (adb --version | Select-String "Version (\d+\.\d+\.\d+)-\d+").Matches.Groups[1].Value
    if ($localVersion -eq $remoteVersion) { Write-Host "`n[INFO] ADB v$remoteVersion is up-to-date." -ForegroundColor Yellow; exit }
    Write-Host "`n[INFO] Updating ADB v$localVersion to v$remoteVersion..." -ForegroundColor Yellow
}

# Download and extract platform tools
try {
    Write-Host "`n[INFO] Downloading Platform Tools..." -ForegroundColor Yellow
    curl.exe -L $platformToolsUrl -o $zipFilePath
    Expand-Archive $zipFilePath "$env:PROGRAMFILES\Android" -Force
    Rename-Item "$env:PROGRAMFILES\Android\platform-tools" "Platform Tools"
    Write-Host "[SUCCESS] Extraction Complete." -ForegroundColor Green
} catch { Write-Host "[ERROR] $_" -ForegroundColor Red; exit }

# Update PATH
$path = [System.Environment]::GetEnvironmentVariable("PATH", 'Machine')
if (-not $path.Contains($platformToolsPath)) {
    [System.Environment]::SetEnvironmentVariable("PATH", "$path;$platformToolsPath", 'Machine')
    Write-Host "`n[SUCCESS] Platform Tools added to PATH." -ForegroundColor Green
}

# Cleanup and finish
Remove-Item $zipFilePath -ErrorAction SilentlyContinue
Write-Host "`n[INFO] Platform Tools installed/updated to v$remoteVersion!" -ForegroundColor Green
