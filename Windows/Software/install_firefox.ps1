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
    $setupFile = "$Env:TEMP\Firefox Setup $remoteVersion.exe"
    $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri $downloadUrl -OutFile $setupFile
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

    # Define policies.json content (https://mozilla.github.io/policy-templates)
    $policiesJson = @{
        "policies" = @{
            "DisableTelemetry"         = $true
            "DisableFirefoxStudies"    = $true
            "DisablePocket"            = $true
            "DisableFormHistory"       = $true
            "DisableFirefoxAccounts"   = $true
            "DisableSync"              = $true
            "OverrideFirstRunPage"     = ""
            "DisableAppUpdate"         = $true
            "EnableTrackingProtection" = @{
                "Value"  = $true
                "Locked" = $true
            }
            "Extensions"               = @{
                "Install" = @(
                    "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi",
                    "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
                    "https://addons.mozilla.org/firefox/downloads/latest/fastforwardteam/latest.xpi",
                    "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi"
                )
            }
            "PopupBlocking"            = @{
                "Default" = $true
                "Locked"  = $true
            }
            "Cookies"                  = @{
                "Behavior" = "reject-tracker"
                "Locked"   = $true
            }
            "DontCheckDefaultBrowser"  = $true
            "NetworkPrediction"        = $false
            "SearchSuggestEnabled"     = $false
            "DisableSecurityBypass"    = @{
                "SafeBrowsing" = $true
            }
            "SanitizeOnShutdown"       = @{
                "Cache"        = $true
                "Downloads"    = $true
                "FormData"     = $true
                "History"      = $true
                "Sessions"     = $true
                "SiteSettings" = $true
                "OfflineApps"  = $true
                "Locked"       = $true
            }
        }
    }

    # Define autoconfig.js content (https://support.mozilla.org/en-us/kb/customizing-firefox-using-autoconfig)
    $autoConfig = @"
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
"@

    # Define firefox.cfg content (https://support.mozilla.org/en-us/kb/about-config-editor-firefox)
    $firefoxConfig = @"
`nlockPref("app.shield.optoutstudies.enabled", false);
lockPref("datareporting.healthreport.uploadEnabled", false);
lockPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
lockPref("browser.newtabpage.activity-stream.feeds.topsites", false);
lockPref("dom.security.https_only_mode", true);
lockPref("browser.uidensity", 1);
lockPref("full-screen-api.transition-duration.enter", "0 0");
lockPref("full-screen-api.transition-duration.leave", "0 0");
lockPref("full-screen-api.warning.timeout", 0);
lockPref("nglayout.enable_drag_images", false);
lockPref("reader.parse-on-load.enabled", false);
lockPref("browser.tabs.firefox-view", false);
lockPref("browser.tabs.tabmanager.enabled", false);
lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
lockPref("datareporting.healthreport.service.enabled", false);
lockPref("datareporting.policy.dataSubmissionEnabled", false);
lockPref("toolkit.telemetry.enabled", false);
lockPref("toolkit.telemetry.unified", false);
lockPref("toolkit.telemetry.archive.enabled", false);
lockPref("toolkit.telemetry.newProfilePing.enabled", false);
lockPref("toolkit.telemetry.shutdownPingSender.enabled", false);
lockPref("toolkit.telemetry.updatePing.enabled", false);
lockPref("toolkit.telemetry.bhrPing.enabled", false);
lockPref("toolkit.telemetry.firstShutdownPing.enabled", false);
lockPref("browser.ping-centre.telemetry", false);
lockPref("extensions.pocket.enabled", false);
lockPref("browser.newtabpage.activity-stream.feeds.telemetry", false);
lockPref("browser.newtabpage.activity-stream.telemetry", false);
lockPref("browser.newtabpage.activity-stream.feeds.snippets", false);
lockPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
lockPref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
lockPref("network.predictor.enabled", false);
lockPref("network.prefetch-next", false);
lockPref("network.http.speculative-parallel-limit", 0);
lockPref("browser.search.suggest.enabled", false);
lockPref("browser.urlbar.suggest.searches", false);
lockPref("extensions.getAddons.cache.enabled", false);
lockPref("extensions.htmlaboutaddons.recommendations.enabled", false);
lockPref("dom.push.enabled", false);
"@

    # Convert policies to JSON and write to file
    $policiesJson | ConvertTo-Json -Depth 5 -Compress | Set-Content -Path "$installDir\distribution\policies.json"
    Write-Host "Created: policies.json" -ForegroundColor Green

    # Write autoconfig.js
    $autoConfig | Set-Content -Path "$installDir\defaults\pref\autoconfig.js"
    Write-Host "Created: autoconfig.js" -ForegroundColor Green

    # Write firefox.cfg
    $firefoxConfig | Set-Content -Path "$installDir\firefox.cfg"
    Write-Host "Created: firefox.cfg" -ForegroundColor Green

    # Display release notes URL
    Write-Host "`nRelease notes: https://www.mozilla.org/en-US/firefox/$remoteVersion/releasenotes" -ForegroundColor Green
    return 0
}

exit (main)
