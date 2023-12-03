param (
    [switch]$force,
    [switch]$skipHashCheck,
    [string]$lang = "en-GB",
    [string]$version
)

# Load necessary assemblies
Add-Type -AssemblyName System.Web.Extensions

# Create required objects
$webClient = New-Object System.Net.WebClient
$serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$hashAlgorithm = New-Object -TypeName System.Security.Cryptography.SHA512CryptoServiceProvider

# Function to convert an item to JSON
function ConvertToJson($item) {
    return $serializer.Serialize($item)
}

# Function to calculate SHA512 hash of a file
function GetSHA512($file) {
    $hash = [System.BitConverter]::ToString($hashAlgorithm.ComputeHash([System.IO.File]::ReadAllBytes($file)))
    return @{
        "Algorithm" = "SHA512"
        "Path"      = $file
        "Hash"      = $hash.Replace("-", "")
    }
}

# Function to retrieve SHA512 hash from a source
function GetSHA512Hash($source, $fileName) {
    try {
        $response = $webClient.DownloadString($source)
    }
    catch [System.Management.Automation.MethodInvocationException] {
        Write-Host "Error: Unable to fetch hash data from $source. Consider using -skipHashCheck." -ForegroundColor Red
        exit 1
    }

    $response = $response -split "`n"

    foreach ($line in $response) {
        $splitLine = $line.Split(" ", 2)
        $hash = $splitLine[0]
        $currentFileName = $splitLine[1].Trim()

        if ($null -ne $hash -and $null -ne $currentFileName) {
            if ($currentFileName -eq $fileName) {
                return $hash
            }
        }
    }
    return $null
}

# Function to pause and wait for user input
function PauseNull {
    Write-Host "Press any key to exit... " -NoNewline
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') | Out-Null
    exit
}

# Function to check for admin privileges
function TestAdmin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Main function
function main {
    Write-Host "Starting Firefox installation process...`n"

    if (-not (TestAdmin)) {
        Write-Host "Error: Administrator privileges required." -ForegroundColor Red
        PauseNull
    }

    # Attempt to enforce TLS protocol
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Write-Host "Info: TLS protocol set to TLS 1.2" -ForegroundColor Green
    }
    catch {
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls
            Write-Host "Info: TLS protocol set to TLS 1.0" -ForegroundColor Green
        }
        catch {
            Write-Warning "Warning: Unable to set TLS protocol. Your Windows version may not support this protocol."
        }
    }

    try {
        $response = $webClient.DownloadString("https://product-details.mozilla.org/1.0/firefox_versions.json")
        Write-Host "Info: Successfully fetched JSON data." -ForegroundColor Green
    }
    catch [System.Management.Automation.MethodInvocationException] {
        Write-Host "Error: Failed to fetch JSON data. Check internet connection and try again." -ForegroundColor Red
        PauseNull
    }

    # Determine download URL based on provided or latest version
    $firefox = $serializer.DeserializeObject($response)
    $remoteVersion = if ($version) { $version } else { $firefox["LATEST_FIREFOX_VERSION"] }
    $downloadUrl = "https://releases.mozilla.org/pub/firefox/releases/$remoteVersion/win64/$lang/Firefox%20Setup%20$remoteVersion.exe"
    $installDir = "$Env:PROGRAMFILES\Mozilla Firefox"
    $hashSource = "https://ftp.mozilla.org/pub/firefox/releases/$remoteVersion/SHA512SUMS"

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
    Write-Host "Info: Downloading Mozilla Firefox $remoteVersion setup..." -ForegroundColor Green
    $setupFile = "$Env:TEMP\Firefox Setup $remoteVersion.exe"
    $webClient.DownloadFile($downloadUrl, $setupFile)

    # Verify hash if not skipping hash check
    if (-not $skipHashCheck) {
        $localSHA512 = (GetSHA512 -file $setupFile).Hash
        $remoteSHA512 = GetSHA512Hash -source $hashSource -fileName "win64/$lang/Firefox Setup $remoteVersion.exe"

        if ($localSHA512 -ne $remoteSHA512) {
            Write-Host "Error: The hash of the downloaded file does not match the expected hash." -ForegroundColor Red
            PauseNull
        }
        else {
            Write-Host "Info: Hash verification successful. The downloaded file matches the expected hash." -ForegroundColor Green
        }
    }

    # Installation process
    Write-Host "Info: Installing Mozilla Firefox..." -ForegroundColor Green
    Stop-Process -Name "firefox" -ErrorAction SilentlyContinue

    try {
        Start-Process -FilePath $setupFile -ArgumentList "/S /MaintenanceService=false" -Wait
        Write-Host "Info: Installation of Mozilla Firefox completed successfully." -ForegroundColor Green
    }
    catch [System.InvalidOperationException] {
        Write-Host "Error: Failed to download the setup file." -ForegroundColor Red
        PauseNull
    }

    Write-Host "`nRemoving unnecessary files..." -ForegroundColor Green
    # Remove Firefox setup file
    if (Test-Path $setupFile -PathType Leaf) {
        Write-Host "Info: Removing Firefox Setup $remoteVersion.exe" -ForegroundColor Green
        Remove-Item $setupFile
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

    foreach ($file in $removeFiles) {
        $filePath = "$installDir\$file"
        if (Test-Path $filePath -PathType Leaf) {
            Write-Host "Info: Removing file: $file" -ForegroundColor Green
            Remove-Item $filePath
        }
    }

    # Configuration settings
    Write-Host "`nConfiguring Mozilla Firefox settings..." -ForegroundColor Green
    # Create policies.json
    Write-Host "Info: Created policies.json at '$installDir\distribution\policies.json'" -ForegroundColor Green
    (New-Item -Path "$installDir" -Name "distribution" -ItemType "directory" -Force) > $null
    $policies = ConvertToJson(@{
            policies = @{
                DisableAppUpdate     = $true
                OverrideFirstRunPage = ""
                Extensions           = @{
                    Install = @(
                        "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/11423598-latest.xpi"
                    )
                }
            }
        })

    # Create autoconfig.js
    Write-Host "Info: Created autoconfig.js at '$installDir\defaults\pref\autoconfig.js'" -ForegroundColor Green
    $autoConfig = @"
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
"@

    # Create firefox.cfg
    Write-Host "Info: Created firefox.cfg at '$installDir\firefox.cfg'" -ForegroundColor Green
    $firefoxConfig = @"
defaultPref("app.shield.optoutstudies.enabled", false)
defaultPref("datareporting.healthreport.uploadEnabled", false)
defaultPref("browser.newtabpage.activity-stream.feeds.section.topstories", false)
defaultPref("browser.newtabpage.activity-stream.feeds.topsites", false)
defaultPref("dom.security.https_only_mode", true)
defaultPref("browser.uidensity", 1)
defaultPref("full-screen-api.transition-duration.enter", "0 0")
defaultPref("full-screen-api.transition-duration.leave", "0 0")
defaultPref("full-screen-api.warning.timeout", 0)
defaultPref("nglayout.enable_drag_images", false)
defaultPref("reader.parse-on-load.enabled", false)
defaultPref("browser.tabs.firefox-view", false)
defaultPref("browser.tabs.tabmanager.enabled", false)
lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false)
lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false)
"@

    # Write configuration files
    Set-Content -Path "$installDir\distribution\policies.json" -Value $policies
    Set-Content -Path "$installDir\defaults\pref\autoconfig.js" -Value $autoConfig
    Set-Content -Path "$installDir\firefox.cfg" -Value $firefoxConfig
    Write-Host "`nRelease notes: https://www.mozilla.org/en-US/firefox/$remoteVersion/releasenotes" -ForegroundColor Green
    return 0
}

exit (main)
