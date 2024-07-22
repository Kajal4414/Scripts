# Function to pause and wait for user input
function PauseNull {
    Write-Host "Press any key to exit..." -NoNewline
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') | Out-Null
    exit
}

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Administrator privileges required." -ForegroundColor Red
    PauseNull
}

# Define URLs and paths
$BaseUrl = "https://sourceforge.net/projects/mpv-player-windows/files/64bit-v3"
$TempPath = Join-Path -Path $env:TEMP -ChildPath "mpv.7z"
$InstallPath = Join-Path -Path $env:PROGRAMFILES -ChildPath "MPV"

# Check if mpv is already installed
$MpvPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\mpv.exe" -ErrorAction SilentlyContinue)."(Default)"
if ($MpvPath -and (Test-Path $MpvPath)) {
    Write-Host "Already installed mpv $((Get-Item $MpvPath).VersionInfo.ProductVersion)." -ForegroundColor Green
    PauseNull
}

# Get download URL
$DownloadUrl = ([regex]::Match((Invoke-WebRequest -Uri $BaseUrl -UseBasicParsing).Content, "https://.*?download")).Value
if (-not $DownloadUrl) {
    Write-Host "Error: Could not find download URL." -ForegroundColor Red
    PauseNull
}

# Download and install mpv
Write-Host "`nDownloading mpv..." -ForegroundColor Yellow
try {
    curl.exe -LS -o $TempPath $DownloadUrl
    Write-Host "Download successful." -ForegroundColor Green
    Write-Host "`nInstalling mpv..." -ForegroundColor Yellow
    if (Get-Command 7z -ErrorAction SilentlyContinue) {
        & 7z x $TempPath -o"$InstallPath" -y
    } elseif (Get-Command nanazipg -ErrorAction SilentlyContinue) {
        & nanazipg x $TempPath -o"$InstallPath" -y
    } else {
        throw "Neither 7z nor NanaZip is installed."
    }
    Start-Process -FilePath "$InstallPath\installer\mpv-install.bat" -Wait -NoNewWindow
    [System.Environment]::SetEnvironmentVariable("PATH", "$env:PATH;$InstallPath", [System.EnvironmentVariableTarget]::User)
} catch {
    Write-Host "`nError: $_" -ForegroundColor Red
    PauseNull
} finally {
    Remove-Item -Path $TempPath -Force -ErrorAction SilentlyContinue
}
