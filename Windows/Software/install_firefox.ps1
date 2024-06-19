param (
    [switch]$force,
    [switch]$skipHashCheck,
    [switch]$theme,
    [switch]$configs,
    [string]$lang = "en-GB",
    [string]$edition,
    [string]$version
)

# Function to pause and wait for user input
function PauseNull {
    Write-Host "Press any key to exit... " -NoNewline
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') | Out-Null
    exit
}

# Check for admin privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Administrator privileges required." -ForegroundColor Red
    PauseNull
}

# Check for internet connectivity
if (-not (Test-Connection 8.8.8.8 -Count 1 -Quiet)) {
    Write-Host "Error: Internet connection required." -ForegroundColor Red
    PauseNull
}

# Main script execution
function main {
    Write-Host "Starting Firefox installation process..." -ForegroundColor Yellow

    # Attempt to fetch JSON data
    try {
        $response = Invoke-RestMethod -Uri "https://product-details.mozilla.org/1.0/firefox_versions.json"
    }
    catch {
        Write-Host "Failed to fetch JSON data: $_" -ForegroundColor Red
        PauseNull
    }

    # Determine the version to download based on the specified edition
    $remoteVersion = switch ($edition) {
        "Developer" { $response.FIREFOX_DEVEDITION }
        "Enterprise" { $response.FIREFOX_ESR }
        default { $response.LATEST_FIREFOX_VERSION }
    }

    # Use the specified version if provided, otherwise use the determined version
    $remoteVersion = if ($version) { $version } else { $remoteVersion }

    # Define download URL and file paths
    $downloadUrl = "https://releases.mozilla.org/pub/firefox/releases/$remoteVersion/win64/$lang/Firefox%20Setup%20$remoteVersion.exe"
    $hashSource = "https://ftp.mozilla.org/pub/firefox/releases/$remoteVersion/SHA512SUMS"
    $installDir = "$env:PROGRAMFILES\Mozilla Firefox"
    $setupFile = "$env:TEMP\Firefox Setup $remoteVersion.exe"

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
    if ($configs) {
        Write-Host "`nConfiguring Mozilla Firefox settings..." -ForegroundColor Yellow

        # Create 'distribution' folder for policies.json
        New-Item -Path $installDir -Name "distribution" -ItemType Directory -Force | Out-Null

        # Write policies.json
        $policyFile = "$installDir\distribution\policies.json"
        if (-not (Test-Path $policyFile)) {
            curl.exe -o $policyFile -LSs "https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Extra/policies.json"
            Write-Host "Created: policies.json" -ForegroundColor Green
        }

        # Write autoconfig.js
        $autoconfigFile = "$installDir\defaults\pref\autoconfig.js"
        if (-not (Test-Path $autoconfigFile)) {
            curl.exe -o $autoconfigFile -LSs "https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Extra/autoconfig.js"
            Write-Host "Created: autoconfig.js" -ForegroundColor Green
        }

        # Write firefox.cfg
        $firefoxCfgFile = "$installDir\firefox.cfg"
        if (-not (Test-Path $firefoxCfgFile)) {
            curl.exe -o $firefoxCfgFile -LSs "https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Extra/firefox.cfg"
            Write-Host "Created: firefox.cfg" -ForegroundColor Green
        }
    }

    # Firefox Theme
    if ($theme) {
        $profilePath = (Get-Item "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release").FullName
        if (-not (Test-Path "$profilePath\chrome") -and (Get-Command "git" -ErrorAction SilentlyContinue)) {
            Write-Host "`nInstalling 'Firefox Mod Blur' Theme..." -ForegroundColor Yellow
            git clone --depth 1 -q https://github.com/datguypiko/Firefox-Mod-Blur "$profilePath\chrome"
            Remove-Item "$profilePath\chrome\*" -Exclude "ASSETS", "userChrome.css", "userContent.css" -Force -Recurse
            Write-Host "Theme installed at default profile path '$profilePath\chrome'" -ForegroundColor Green
        }
    }

    # Display release notes URL
    Write-Host "`nRelease notes: https://www.mozilla.org/en-US/firefox/$remoteVersion/releasenotes" -ForegroundColor Green
    return 0
}

exit (main)
