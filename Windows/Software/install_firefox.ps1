param (
    [switch]$force,
    [switch]$skipHashCheck,
    [string]$lang = "en-GB",
    [string]$version
)

# Function to pause and wait for user input
function PauseNull {
    Write-Host "Press any key to exit... " -NoNewline
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') | Out-Null
    exit
}

# Check for admin privileges
$currentPrincipal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Administrator privileges required." -ForegroundColor Red
    PauseNull
}

# Main script execution
function main {
    Write-Host "Starting Firefox installation process..." -ForegroundColor Yellow

    # Attempt to enforce TLS protocol
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Write-Host "TLS protocol set to 'TLS 1.2' for secure communications." -ForegroundColor Green
    }
    catch {
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls
            Write-Warning "TLS protocol set to TLS 1.0, It is outdated and may pose security risks."
        }
        catch {
            Write-Warning "Unable to set TLS protocol, Your Windows version may not support TLS."
        }
    }

    # Attempt to fetch JSON data
    try {
        $response = Invoke-RestMethod -Uri "https://product-details.mozilla.org/1.0/firefox_versions.json"
    }
    catch {
        Write-Host "Failed to fetch JSON data: $_" -ForegroundColor Red
        PauseNull
    }

    # Determine download URL based on provided or latest version
    $remoteVersion = if ($version) { $version } else { $response.LATEST_FIREFOX_VERSION }
    $downloadUrl = "https://releases.mozilla.org/pub/firefox/releases/$remoteVersion/win64/$lang/Firefox%20Setup%20$remoteVersion.exe"
    $hashSource = "https://ftp.mozilla.org/pub/firefox/releases/$remoteVersion/SHA512SUMS"
    $installDir = "$Env:ProgramFiles\Mozilla Firefox"
    $setupFile = "$Env:TEMP\Firefox Setup $remoteVersion.exe"

    # Check if the current version is already installed
    if (Test-Path "$installDir\firefox.exe" -PathType Leaf) {
        $localVersion = (Get-Item "$installDir\firefox.exe").VersionInfo.ProductVersion

        if ($localVersion -eq $remoteVersion) {
            Write-Host "Mozilla Firefox v$remoteVersion is already installed." -ForegroundColor Green

            if ($force) {
                Write-Warning "-force specified, proceeding anyway."
            }
            else {
                PauseNull
            }
        }
    }

    # Download Firefox setup file
    Write-Host "`nDownloading Mozilla Firefox v$remoteVersion setup..." -ForegroundColor Yellow
    curl.exe -o $setupFile -S $downloadUrl
    Write-Host "Downloading successful." -ForegroundColor Green

    # Verify hash if not skipping hash check
    if (-not $skipHashCheck) {
        Write-Host "`nVerifying SHA-512 Hash..." -ForegroundColor Yellow
        $localSHA512 = (Get-FileHash -Path $setupFile -Algorithm SHA512).Hash
        $remoteSHA512 = (Invoke-RestMethod -Uri $hashSource).Split("`n") | Select-String -Pattern "win64/$lang/Firefox Setup $remoteVersion.exe" | ForEach-Object { $_.Line.Split(" ")[0].Trim() }

        if ($localSHA512 -eq $remoteSHA512) {
            Write-Host "SHA-512 Hash verification successful." -ForegroundColor Green
        }
        else {
            Write-Host "SHA-512 Hash verification failed, consider using -skipHashCheck." -ForegroundColor Red
            PauseNull
        }
    }

    # Installation process
    Write-Host "`nInstalling Mozilla Firefox..." -ForegroundColor Yellow
    Stop-Process -Name "firefox" -ErrorAction SilentlyContinue

    try {
        Start-Process -FilePath $setupFile -ArgumentList "/S /MaintenanceService=false" -Wait
        Write-Host "Installation successful." -ForegroundColor Green
    }
    catch {
        Write-Host "Error occurred while installing 'Mozilla Firefox $remoteVersion.exe': $_" -ForegroundColor Red
        PauseNull
    }

    Write-Host "`nRemoving unnecessary files..." -ForegroundColor Yellow

    # Remove Firefox setup file
    if (Test-Path $setupFile -PathType Leaf) {
        Write-Host "Removed: Mozilla Firefox $remoteVersion.exe" -ForegroundColor Green
        Remove-Item $setupFile
    }

    # Remove unnecessary files
    $removeFiles = @(
        "crashreporter.exe",
        "crashreporter.ini",
        "defaultagent.ini",
        "defaultagent_localized.ini",
        "default-browser-agent.exe",
        "maintenanceservice.exe",
        "maintenanceservice_installer.exe",
        "minidump-analyzer.exe",
        "pingsender.exe",
        "updater.exe",
        "updater.ini",
        "update-settings.ini"
    )

    $removeFiles | ForEach-Object {
        $filePath = "$installDir\$_"
        if (Test-Path $filePath -PathType Leaf) {
            Write-Host "Removed: $_" -ForegroundColor Green
            Remove-Item $filePath
        }
    }

    # Configuration settings
    Write-Host "`nConfiguring Mozilla Firefox settings..." -ForegroundColor Yellow

    # Create 'distribution' folder for policies.json
    New-Item -Path $installDir -Name "distribution" -ItemType Directory -Force | Out-Null

    # Write policies.json
    curl.exe -o "$installDir\distribution\policies.json" -LSs "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/policies.json"
    Write-Host "Created: policies.json" -ForegroundColor Green

    # Write autoconfig.js
    curl.exe -o "$installDir\defaults\pref\autoconfig.js" -LSs "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/autoconfig.js"
    Write-Host "Created: autoconfig.js" -ForegroundColor Green

    # Write firefox.cfg
    curl.exe -o "$installDir\firefox.cfg" -LSs "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/firefox.cfg"
    Write-Host "Created: firefox.cfg" -ForegroundColor Green

    # Display release notes URL
    Write-Host "`nRelease notes: https://www.mozilla.org/en-US/firefox/$remoteVersion/releasenotes" -ForegroundColor Green
    return 0
}

exit (main)
