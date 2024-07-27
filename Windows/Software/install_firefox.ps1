param (
    [switch]$force,
    [switch]$skipHashCheck,
    [switch]$theme,
    [switch]$configs,
    [string]$lang = "en-GB",
    [string]$edition,
    [string]$version
)

function PauseNull {
    Write-Host "Press any key to exit... " -NoNewline
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') | Out-Null
    exit
}

if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Administrator privileges required." -ForegroundColor Red
    PauseNull
}

if (-not (Test-Connection 8.8.8.8 -Count 1 -Quiet)) {
    Write-Host "Error: Internet connection required." -ForegroundColor Red
    PauseNull
}

function DownloadFile($url, $path, $useLSs = $false) {
    curl.exe -o $path $(if ($useLSs) { "-LSs" } else { "-S" }) $url
    Write-Host "Downloaded: $path" -ForegroundColor Green
}

function VerifyHash($file, $hashSource, $remoteFile) {
    $localHash = (Get-FileHash -Path $file -Algorithm SHA512).Hash
    $remoteHash = (Invoke-RestMethod -Uri $hashSource).Split("`n") | Select-String -Pattern $remoteFile | ForEach-Object { $_.Line.Split(" ")[0].Trim() }
    return $localHash -eq $remoteHash
}

function ConfigureFiles($installDir) {
    New-Item -Path "$installDir\distribution" -ItemType Directory -Force | Out-Null
    $files = @(
        @{Name = "policies.json"; Url = "https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Extra/policies.json"; Path = "$installDir\distribution\policies.json" },
        @{Name = "autoconfig.js"; Url = "https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Extra/autoconfig.js"; Path = "$installDir\defaults\pref\autoconfig.js" },
        @{Name = "firefox.cfg"; Url = "https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Extra/firefox.cfg"; Path = "$installDir\firefox.cfg" }
    )
    foreach ($file in $files) {
        if (-not (Test-Path $file.Path)) {
            DownloadFile $file.Url $file.Path $true
        }
    }
}

function main {
    try { $response = Invoke-RestMethod -Uri "https://product-details.mozilla.org/1.0/firefox_versions.json" }
    catch { Write-Host "Failed to fetch JSON data: $_" -ForegroundColor Red; PauseNull }

    $remoteVersion = if ($version) { $version } else { switch ($edition) { "Developer" { $response.FIREFOX_DEVEDITION }; "Enterprise" { $response.FIREFOX_ESR }; default { $response.LATEST_FIREFOX_VERSION } } }
    $downloadUrl = "https://releases.mozilla.org/pub/firefox/releases/$remoteVersion/win64/$lang/Firefox%20Setup%20$remoteVersion.exe"
    $hashSource = "https://ftp.mozilla.org/pub/firefox/releases/$remoteVersion/SHA512SUMS"
    $installDir = "$env:PROGRAMFILES\Mozilla Firefox"
    $setupFile = "$env:TEMP\Firefox Setup $remoteVersion.exe"

    if (Test-Path "$installDir\firefox.exe") {
        $localVersion = (Get-Item "$installDir\firefox.exe").VersionInfo.ProductVersion
        if ($localVersion -eq $remoteVersion -and -not $force) {
            Write-Host "Mozilla Firefox v$remoteVersion is already installed." -ForegroundColor Green
            PauseNull
        }
    }

    Write-Host "Downloading Mozilla Firefox v$remoteVersion setup..." -ForegroundColor Yellow
    DownloadFile $downloadUrl $setupFile

    Write-Host "`nVerifying SHA-512 Hash..." -ForegroundColor Yellow
    if (-not $skipHashCheck -and -not (VerifyHash $setupFile $hashSource "win64/$lang/Firefox Setup $remoteVersion.exe")) {
        Write-Host "SHA-512 Hash verification failed, consider using -skipHashCheck." -ForegroundColor Red
        PauseNull
    } else {
        Write-Host "Verification Successful." -ForegroundColor Green
    }

    Write-Host "`nInstalling Mozilla Firefox..." -ForegroundColor Yellow
    Stop-Process -Name "firefox" -ErrorAction SilentlyContinue

    try { Start-Process -FilePath $setupFile -ArgumentList "/S /MaintenanceService=false" -Wait; Write-Host "Installation Successful." -ForegroundColor Green }
    catch { Write-Host "Error occurred while installing 'Mozilla Firefox $remoteVersion.exe': $_" -ForegroundColor Red; PauseNull }

    Write-Host "`nRemoving unnecessary files..." -ForegroundColor Yellow
    Remove-Item $setupFile -ErrorAction SilentlyContinue
    "crashreporter.exe crashreporter.ini defaultagent.ini defaultagent_localized.ini default-browser-agent.exe maintenanceservice.exe maintenanceservice_installer.exe minidump-analyzer.exe pingsender.exe updater.exe updater.ini update-settings.ini".Split() | ForEach-Object {
        $filePath = "$installDir\$_"
        if (Test-Path $filePath) { Remove-Item $filePath -ErrorAction SilentlyContinue; Write-Host "Removed: $filePath" -ForegroundColor Green }
    }

    if ($configs) { Write-Host "`nConfiguring Firefox Settings..." -ForegroundColor Yellow; ConfigureFiles $installDir }

    if ($theme) {
        Write-Host "`nInstalling Firefox Mod Blur Theme..." -ForegroundColor Yellow
        $profilePath = (Get-Item "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release").FullName
        if (-not $profilePath) { Start-Process "firefox.exe"; Start-Sleep -Seconds 10; Stop-Process -Name "firefox" -Force }
        if ($profilePath -and (Test-Path "$profilePath\chrome")) { Write-Host "Skipping: Firefox Mod Blur Theme Already Installed." -ForegroundColor Green }
        elseif ($profilePath -and -not (Test-Path "$profilePath\chrome") -and (Get-Command "git" -ErrorAction SilentlyContinue)) {
            git clone --depth 1 -q https://github.com/datguypiko/Firefox-Mod-Blur "$profilePath\chrome"
            Get-ChildItem -Path "$profilePath\chrome" -Exclude "ASSETS", "userChrome.css", "userContent.css" -Force | Remove-Item -Force -Recurse
            Write-Host "Installation Successful." -ForegroundColor Green
        }
    }

    Write-Host "`nRelease notes: https://www.mozilla.org/en-US/firefox/$remoteVersion/releasenotes" -ForegroundColor Green
    return 0
}

exit (main)
