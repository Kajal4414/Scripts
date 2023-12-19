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

# # Check for admin privileges
# $currentPrincipal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
# if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
#     Write-Host "Error: Administrator privileges required." -ForegroundColor Red
#     PauseNull
# }

# Main script execution
function main {
    Write-Host "Starting Firefox installation process...`n"

    # # Attempt to enforce TLS protocol
    # try {
    #     [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    #     Write-Host "Info: TLS protocol set to TLS 1.2, which is secure and recommended." -ForegroundColor Green
    # }
    # catch {
    #     [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls
    #     Write-Warning "Warning: TLS protocol set to TLS 1.0, It is outdated and may pose security risks." -ForegroundColor Green
    # }

    # Attempt to fetch JSON data
    try {
        $response = Invoke-RestMethod -Uri "https://product-details.mozilla.org/1.0/firefox_versions.json"
        Write-Host "Info: Successfully fetched JSON data." -ForegroundColor Green
    }
    catch {
        Write-Host "Error: Failed to fetch JSON data. Check internet connection and try again." -ForegroundColor Red
        PauseNull
    }

    # Determine download URL based on provided or latest version
    $remoteVersion = if ($version) { $version } else { $response.LATEST_FIREFOX_VERSION }
    $downloadUrl = "https://releases.mozilla.org/pub/firefox/releases/$remoteVersion/win64/$lang/Firefox%20Setup%20$remoteVersion.exe"
    $hashSource = "https://ftp.mozilla.org/pub/firefox/releases/$remoteVersion/SHA512SUMS"
    $installDir = "$Env:ProgramFiles\Mozilla Firefox"

    # Check if the current version is already installed
    if (Test-Path "$installDir\firefox.exe" -PathType Leaf) {
        $localVersion = (Get-Item "$installDir\firefox.exe").VersionInfo.ProductVersion

        if ($localVersion -eq $remoteVersion) {
            Write-Host "Info: Mozilla Firefox $remoteVersion is already installed." -ForegroundColor Green

            if ($force) {
                Write-Warning "Warning: -force specified, proceeding anyway."
            }
            else {
                PauseNull
            }
        }
    }

    # Download Firefox setup file
    Write-Host "Info: Downloading Mozilla Firefox v$remoteVersion setup..." -ForegroundColor Green
    $setupFile = "$Env:TEMP\Firefox Setup $remoteVersion.exe"
    # Invoke-WebRequest -Uri $downloadUrl -OutFile $setupFile

    # Verify hash if not skipping hash check
    if (-not $skipHashCheck) {
        $localSHA512 = (Get-FileHash -Path $setupFile -Algorithm SHA512).Hash
        $remoteSHA512 = (Invoke-RestMethod -Uri $hashSource).Split("`n") | Select-String -Pattern "win64/$lang/Firefox Setup $remoteVersion.exe" | ForEach-Object { $_.Line.Split(" ")[0].Trim() }

        if ($localSHA512 -eq $remoteSHA512) {
            Write-Host "Info: Hash verification successful. The downloaded file matches the expected hash." -ForegroundColor Green
            Write-Host "Local Hash: " $localSHA512 -ForegroundColor Yellow
            Write-Host "Remote Hash: " $remoteSHA512 -ForegroundColor Blue
        }
        else {
            Write-Host "Error: The hash of the downloaded file does not match the expected hash." -ForegroundColor Red
            PauseNull
        }
    }

    # Installation process
    Write-Host "Info: Installing Mozilla Firefox..." -ForegroundColor Green
    # Stop-Process -Name "firefox" -ErrorAction SilentlyContinue

    try {
        # Start-Process -FilePath $setupFile -ArgumentList "/S /MaintenanceService=false" -Wait
        Write-Host "Info: Installation of Mozilla Firefox completed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error: Failed to download the setup file." -ForegroundColor Red
        PauseNull
    }

    Write-Host "`nRemoving unnecessary files..." -ForegroundColor Green

    # Remove Firefox setup file
    if (Test-Path $setupFile -PathType Leaf) {
        Write-Host "Info: Removing $setupFile" -ForegroundColor Green
        # Remove-Item $setupFile
    }

    # Remove specific files
    $removeFiles = @(
        "crashreporter.exe",
        "crashreporter.ini",
        "defaultagent.ini",
        "defaultagent_localized.ini",
        "default-browser-agent.exe",
        "maintenanceservice.exe",
        "maintenanceservice_installer.exe",
        "pingsender.exe",
        "updater.exe",
        "updater.ini",
        "update-settings.ini"
    )

    $removeFiles | ForEach-Object {
        $filePath = "$installDir\$_"
        if (Test-Path $filePath -PathType Leaf) {
            Write-Host "Info: Removing file: $_" -ForegroundColor Green
            Remove-Item $filePath
        }
    }

#     # Configuration settings
#     Write-Host "`nConfiguring Mozilla Firefox settings..." -ForegroundColor Green

#     # Define policies.json content
#     New-Item -Path $installDir -Name "distribution" -ItemType Directory -Force | Out-Null # Create 'distribution' folder for policies.json
#     $policiesJson = @{
#         policies = @{
#             DisableAppUpdate         = $true
#             DisableTelemetry         = $true
#             DisableFirefoxStudies    = $true
#             DisablePocket            = $true
#             DisableFormHistory       = $true
#             DisableFirefoxAccounts   = $true
#             DisableFeedbackCommands  = $true
#             EnableTrackingProtection = @{
#                 Value = "always"
#             }
#             Extensions               = @{
#                 Install = @(
#                     "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/11423598-latest.xpi"
#                 )
#             }
#         }
#     }

#     # Define autoconfig.js content
#     $autoConfig = @"
# pref("general.config.filename", "firefox.cfg");
# pref("general.config.obscure_value", 0);
# "@

#     # Define firefox.cfg content
#     $firefoxConfig = @"
# defaultPref("app.shield.optoutstudies.enabled", false)
# defaultPref("datareporting.healthreport.uploadEnabled", false)
# defaultPref("browser.newtabpage.activity-stream.feeds.section.topstories", false)
# defaultPref("browser.newtabpage.activity-stream.feeds.topsites", false)
# defaultPref("dom.security.https_only_mode", true)
# defaultPref("browser.uidensity", 1)
# defaultPref("full-screen-api.transition-duration.enter", "0 0")
# defaultPref("full-screen-api.transition-duration.leave", "0 0")
# defaultPref("full-screen-api.warning.timeout", 0)
# defaultPref("nglayout.enable_drag_images", false)
# defaultPref("reader.parse-on-load.enabled", false)
# defaultPref("browser.tabs.firefox-view", false)
# defaultPref("browser.tabs.tabmanager.enabled", false)
# lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false)
# lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false)
# "@

#     # Convert policies to JSON and write to file
#     $policiesJson | ConvertTo-Json -Depth 5 | Set-Content -Path "$installDir\distribution\policies.json"
#     Write-Host "Info: Created policies.json at '$installDir\distribution\policies.json'" -ForegroundColor Green

#     # Write autoconfig.js
#     $autoConfig | Set-Content -Path "$installDir\defaults\pref\autoconfig.js"
#     Write-Host "Info: Created autoconfig.js at '$installDir\defaults\pref\autoconfig.js'" -ForegroundColor Green

#     # Write firefox.cfg
#     $firefoxConfig | Set-Content -Path "$installDir\firefox.cfg"
#     Write-Host "Info: Created firefox.cfg at '$installDir\firefox.cfg'" -ForegroundColor Green

#     # Display release notes URL
#     $remoteVersion = if ($version) { $version } else { "latest" }
#     Write-Host "`nRelease notes: https://www.mozilla.org/en-US/firefox/$remoteVersion/releasenotes" -ForegroundColor Green
#     return 0
}

exit (main)
