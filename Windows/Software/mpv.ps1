# Define variables
$baseUrl = "https://sourceforge.net/projects/mpv-player-windows/files/64bit-v3"
$7zPath = "$env:PROGRAMFILES\7-Zip\7z.exe"
$mpvPath = "$env:PROGRAMFILES\mpv"
$tempPath = "$env:TEMP\mpv.7z"

# Check for administrative privileges
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Administrative privileges are required to run this script." -ForegroundColor Red
    exit
}

# Check if mpv is already installed
$mpvRegPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\mpv.exe" -ErrorAction SilentlyContinue)."(Default)"
if ($mpvRegPath -and (Test-Path $mpvRegPath)) {
    Write-Host "mpv is already installed. Version: $((Get-Item $mpvRegPath).VersionInfo.ProductVersion)." -ForegroundColor Green
    exit
}

# Get download URL
$downloadUrl = ([regex]::Match((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Content, "https://.*?download")).Value
if (-not $downloadUrl) {
    Write-Host "Error: Unable to retrieve the download URL from the source." -ForegroundColor Red
    exit
}

# Download and install mpv
Write-Host "Initiating download of mpv..." -ForegroundColor Yellow
try {
    curl.exe -LS -o $tempPath $downloadUrl
    Write-Host "Download completed successfully." -ForegroundColor Green

    # Extract the file using 7z
    Write-Host "Commencing extraction of mpv..." -ForegroundColor Yellow
    if (Test-Path $7zPath) {
        & $7zPath x $tempPath -o"$mpvPath" -y
    } else {
        Write-Host "Error: 7-Zip is not installed. Please install 7-Zip or manually extract the archive." -ForegroundColor Red
        exit
    }

    # Run the installer
    Write-Host "Starting mpv installer..." -ForegroundColor Yellow
    Start-Process -FilePath "$mpvPath\installer\mpv-install.bat" -Wait -NoNewWindow

    # Add mpv to system PATH
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
    if (-not ($currentPath -split ';' -contains $mpvPath)) {
        [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$mpvPath", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "mpv has been successfully added to the system PATH." -ForegroundColor Green
    }
} catch {
    Write-Host "Error: An exception occurred during the installation process. Details: $_" -ForegroundColor Red
    exit
} finally {
    Remove-Item -Path $tempPath -Force -ErrorAction SilentlyContinue
}
