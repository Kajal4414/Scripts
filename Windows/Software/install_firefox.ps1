param (
    [switch]$force,
    [switch]$skip_hash_check,
    [string]$lang = "en-GB",
    [string]$version
)

Add-Type -AssemblyName System.Web.Extensions

$web_client = New-Object System.Net.WebClient
$serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$hash_algorithm = New-Object -TypeName System.Security.Cryptography.SHA512CryptoServiceProvider

function Convert-To-Json($item) {
    return $serializer.Serialize($item)
}

function Get-SHA512($file) {
    $hash = [System.BitConverter]::ToString($hash_algorithm.ComputeHash([System.IO.File]::ReadAllBytes($file)))
    $ret = @{
        "Algorithm" = "SHA512"
        "Path"      = $file
        "Hash"      = $hash.Replace("-", "")
    }
    return $ret
}

function Get-SHA512Hash($source, $file_name) {
    try {
        $response = $web_client.DownloadString($source)
    }
    catch [System.Management.Automation.MethodInvocationException] {
        $host.UI.WriteErrorLine("Error: Unable to fetch hash data from $source. Consider using -skip_hash_check.")
        exit 1
    }

    $response = $response.split("`n")

    foreach ($line in $response) {
        $split_line = $line.Split(" ", 2)
        $hash = $split_line[0]
        $current_file_name = $split_line[1].Trim()

        if ($null -ne $hash -and $null -ne $current_file_name) {
            if ($current_file_name -eq $file_name) {
                return $hash
            }
        }
    }
    return $null
}

function PauseNull {
    Write-Host "Press any key to exit... " -NoNewline
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') | Out-Null
    exit
}

function Test-Admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function main() {
    Write-Host "Starting Firefox installation process...`n"
    if (-not (Test-Admin)) {
        $host.UI.WriteErrorLine("Error: Administrator privileges required.")
        PauseNull
    }

    # Attempt to enforce TLS protocol
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Write-Host "Info: TLS protocol set to TLS 1.2"
    }
    catch {
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls
            Write-Host "Info: TLS protocol set to TLS 1.0"
        }
        catch {
            Write-Warning "Warning: Unable to set TLS protocol. Your Windows version may not support this protocol."
        }
    }

    try {
        $response = $web_client.DownloadString("https://product-details.mozilla.org/1.0/firefox_versions.json")
        Write-Host "Info: Successfully fetched JSON data."
    }
    catch [System.Management.Automation.MethodInvocationException] {
        $host.UI.WriteErrorLine("Error: Failed to fetch JSON data. Check internet connection and try again.")
        PauseNull
    }

    # Determine download URL based on provided or latest version
    $firefox = $serializer.DeserializeObject($response)
    $remote_version = if ($version) { $version } else { $firefox["LATEST_FIREFOX_VERSION"] }
    $download_url = "https://releases.mozilla.org/pub/firefox/releases/$remote_version/win64/$lang/Firefox%20Setup%20$remote_version.exe"
    $install_dir = "$Env:PROGRAMFILES\Mozilla Firefox"
    $hash_source = "https://ftp.mozilla.org/pub/firefox/releases/$remote_version/SHA512SUMS"

    # Check if the current version is already installed
    if (Test-Path "$install_dir\firefox.exe" -PathType Leaf) {
        $local_version = (Get-Item "$install_dir\firefox.exe").VersionInfo.ProductVersion

        if ($local_version -eq $remote_version) {
            Write-Host "Info: Mozilla Firefox $remote_version is already installed."

            if ($force) {
                Write-Warning "Warning: -force specified, proceeding anyway."
            }
            else {
                PauseNull
            }
        }
    }

    # Download Firefox setup file
    Write-Host "Info: Downloading Mozilla Firefox $remote_version setup..."
    $setup_file = "$Env:TEMP\Firefox Setup $remote_version.exe"
    $web_client.DownloadFile($download_url, $setup_file)

    # Verify hash if not skipping hash check
    if (-not $skip_hash_check) {
        $local_SHA512 = (Get-SHA512 -file $setup_file).Hash
        $remote_SHA512 = Get-SHA512Hash -source $hash_source -file_name "win64/$lang/Firefox Setup $remote_version.exe"

        if ($local_SHA512 -ne $remote_SHA512) {
            $host.UI.WriteErrorLine("Error: The hash of the downloaded file does not match the expected hash.")
            PauseNull
        }
        else {
            Write-Host "Info: Hash verification successful. The downloaded file matches the expected hash."
        }
    }

    # Installation process
    Write-Host "Info: Installing Mozilla Firefox..."
    Stop-Process -Name "firefox" -ErrorAction SilentlyContinue

    try {
        Start-Process -FilePath $setup_file -ArgumentList "/S /MaintenanceService=false" -Wait
        Write-Host "Info: Installation of Mozilla Firefox completed successfully."
    }
    catch [System.InvalidOperationException] {
        $host.UI.WriteErrorLine("Error: Failed to download the setup file.")
        PauseNull
    }

    Write-Host "`nRemoving unnecessary files..."
    # Remove Firefox setup file
    if (Test-Path $setup_file -PathType Leaf) {
        Write-Host "Info: Removing Firefox Setup $remote_version.exe"
        Remove-Item $setup_file
    }

    # Remove specific files
    $remove_files = @(
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

    foreach ($file in $remove_files) {
        $filePath = "$install_dir\$file"
        if (Test-Path $filePath -PathType Leaf) {
            Write-Host "Info: Removing file: $file"
            Remove-Item $filePath
        }
    }

    # Configuration settings
    Write-Host "`nConfiguring Mozilla Firefox settings..."
    # Create policies.json
    Write-Host "Info: Created policies.json at '$install_dir\distribution\policies.json'"
    (New-Item -Path "$install_dir" -Name "distribution" -ItemType "directory" -Force) 2>&1 > $null
    $policies = Convert-To-Json(@{
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
    Write-Host "Info: Created autoconfig.js at '$install_dir\defaults\pref\autoconfig.js'"
    $autoconfig = @"
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
"@

    # Create firefox.cfg
    Write-Host "Info: Created firefox.cfg at '$install_dir\firefox.cfg'"
    $firefox_config = @"
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
    Set-Content -Path "$install_dir\distribution\policies.json" -Value $policies
    Set-Content -Path "$install_dir\defaults\pref\autoconfig.js" -Value $autoconfig
    Set-Content -Path "$install_dir\firefox.cfg" -Value $firefox_config
    Write-Host "`nRelease notes: https://www.mozilla.org/en-US/firefox/$remote_version/releasenotes"
    return 0
}

exit (main)
