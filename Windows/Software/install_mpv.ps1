# Define base URL and paths
$baseUrl = "https://sourceforge.net/projects/mpv-player-windows/files/64bit-v3"
$7zPath = "$env:PROGRAMFILES\7-Zip\7z.exe"
$mpvPath = "$env:PROGRAMFILES\mpv"
$tempPath = "$env:TEMP\mpv.7z"

# Check for administrator privileges
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "`n[ERROR] Administrator privileges are required to run this script." -ForegroundColor Red
    exit
}

# Check if mpv is already installed
$mpvExePath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\mpv.exe" -ErrorAction SilentlyContinue)."(Default)"
if ($mpvExePath -and (Test-Path $mpvExePath)) {
    Write-Host "`n[INFO] MPV $((Get-Item $mpvExePath).VersionInfo.ProductVersion) is already installed at '$(Split-Path -Path $mpvExePath -Parent)'." -ForegroundColor Yellow
    exit
}

# Retrieve download URL for mpv
try {
    $downloadUrl = ([regex]::Match((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Content, "https://.*?download")).Value
}
catch {
    Write-Host "`n[ERROR] Unable to retrieve the download URL. $_" -ForegroundColor Red
    exit
}

# Download mpv archive
try {
    Write-Host "`n[INFO] Downloading MPV from '$downloadUrl' to '$tempPath'..." -ForegroundColor Yellow
    curl.exe -LS $downloadUrl -o $tempPath
    Write-Host "[SUCCESS] Download completed successfully." -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Failed to download the file. $_" -ForegroundColor Red
    exit
}

# Extract and remove mpv archive
Write-Host "`n[INFO] Extracting MPV archive to '$mpvPath'..." -ForegroundColor Yellow
& $7zPath x $tempPath -o"$mpvPath" -y -bso0 -bd
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] An error occurred while extracting the MPV archive." -ForegroundColor Red
    exit 1
}
Remove-Item -Path $tempPath -ErrorAction SilentlyContinue
Write-Host "[SUCCESS] Extraction completed successfully." -ForegroundColor Green

# Add mpv to system environment variable if not already present
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
if (-not ($currentPath -split ';' -contains $mpvPath)) {
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$mpvPath", [System.EnvironmentVariableTarget]::Machine)
    Write-Host "`n[SUCCESS] MPV successfully added to the system PATH." -ForegroundColor Green
}

# Run mpv installer batch file
Write-Host "`n[INFO] Running the MPV installer..." -ForegroundColor Yellow
Start-Process -FilePath "$mpvPath\installer\mpv-install.bat" -Wait -NoNewWindow
