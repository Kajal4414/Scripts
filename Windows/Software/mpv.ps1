# Define URLs and paths
$BaseUrl = "https://sourceforge.net/projects/mpv-player-windows/files/64bit-v3"
$InstallPath = Join-Path -Path $env:PROGRAMFILES -ChildPath "mpv"
$TempPath = Join-Path -Path $env:TEMP -ChildPath "mpv.7z"

# Check for administrative privileges
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Administrator privileges required." -ForegroundColor Red
    exit
}

# Check if mpv is already installed
$MpvPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\mpv.exe" -ErrorAction SilentlyContinue)."(Default)"
if ($MpvPath -and (Test-Path $MpvPath)) {
    Write-Host "Already installed mpv $((Get-Item $MpvPath).VersionInfo.ProductVersion)." -ForegroundColor Green
    exit
}

# Get download URL
$DownloadUrl = ([regex]::Match((Invoke-WebRequest -Uri $BaseUrl -UseBasicParsing).Content, "https://.*?download")).Value
if (-not $DownloadUrl) {
    Write-Host "Error: Could not find download URL." -ForegroundColor Red
    exit
}

# Download and install mpv
Write-Host "`nDownloading mpv..." -ForegroundColor Yellow
try {
    curl.exe -LS -o $TempPath $DownloadUrl
    Write-Host "Download successful." -ForegroundColor Green
    
    Write-Host "`nInstalling mpv..." -ForegroundColor Yellow
    $SevenZipPath = if (Get-Command 7z -ErrorAction SilentlyContinue) { "7z" } else { Join-Path -Path $env:ProgramFiles -ChildPath "7-Zip\7z.exe" }
    if (Test-Path $SevenZipPath) {
        & $SevenZipPath x $TempPath -o"$InstallPath" -y
    } else {
        throw "7z not installed."
    }

    Start-Process -FilePath "$InstallPath\installer\mpv-install.bat" -Wait -NoNewWindow
    
    # Add mpv to system PATH
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
    if (-not ($currentPath -split ';' -contains $InstallPath)) {
        [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$InstallPath", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "`nAdded mpv to system PATH" -ForegroundColor Green
    }
} catch {
    Write-Host "`nError: $_" -ForegroundColor Red
    exit
} finally {
    Remove-Item -Path $TempPath -Force -ErrorAction SilentlyContinue
}
