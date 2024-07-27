# Define variables
$baseUrl = "https://sourceforge.net/projects/mpv-player-windows/files/64bit-v3"
$7zPath = "$env:PROGRAMFILES\7-Zip\7z.exe"
$mpvPath = "$env:PROGRAMFILES\mpv"
$tempPath = "$env:TEMP\mpv.7z"

# Check for administrative privileges
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Administrator privileges required." -ForegroundColor Red
    exit
}

# Check if mpv is already installed
$mpvRegPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\mpv.exe" -ErrorAction SilentlyContinue)."(Default)"
if ($MpvPath -and (Test-Path $MpvPath)) {
    Write-Host "Already installed mpv $((Get-Item $MpvPath).VersionInfo.ProductVersion)." -ForegroundColor Green
    exit
}

# Get download URL
$downloadUrl = ([regex]::Match((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Content, "https://.*?download")).Value
if (-not $downloadUrl) {
    Write-Host "Error: Could not find download URL." -ForegroundColor Red
    exit
}

# Download and install mpv
Write-Host "`nDownloading mpv..." -ForegroundColor Yellow
try {
    curl.exe -LS -o $tempPath $downloadUrl
    Write-Host "Download successful." -ForegroundColor Green
    
    # Extract the file using 7z
    Write-Host "`nInstalling mpv..." -ForegroundColor Yellow
    if (Test-Path $7zPath) {
        & $7zPath x $tempPath -o"$InstallPath" -y
    } else {
        throw "7-Zip is not installed. Please install it and then run the script again."
    }

    # Run the installer
    Start-Process -FilePath "$InstallPath\installer\mpv-install.bat" -Wait -NoNewWindow
    
    # Add mpv to system PATH
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
    if (-not ($currentPath -split ';' -contains $InstallPath)) {
        [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$mpvPath", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "`nAdded mpv to system PATH" -ForegroundColor Green
    }
} catch {
    Write-Host "`nError: $_" -ForegroundColor Red
    exit
} finally {
    Remove-Item -Path $tempPath -Force -ErrorAction SilentlyContinue
}
