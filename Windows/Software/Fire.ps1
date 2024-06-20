param (
    [switch]$Force,
    [switch]$SkipHashCheck,
    [switch]$Theme,
    [switch]$Configs,
    [string]$Lang = "en-GB",
    [string]$Edition,
    [string]$Version
)

function PauseNull {
    Write-Host "Press any key to exit... " -NoNewline
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') | Out-Null
    exit
}

function CheckAdminPrivileges {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Error: Administrator privileges required." -ForegroundColor Red
        PauseNull
    }
}

function CheckInternetConnectivity {
    if (-not (Test-Connection 8.8.8.8 -Count 1 -Quiet)) {
        Write-Host "Error: Internet connection required." -ForegroundColor Red
        PauseNull
    }
}

function DownloadFile($url, $destination) {
    try {
        Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
        Write-Host "Download successful: $destination" -ForegroundColor Green
    } catch {
        Write-Host "Download failed: $_" -ForegroundColor Red
        PauseNull
    }
}

function VerifyHash($filePath, $hashSource) {
    Write-Host "`nVerifying SHA-512 Hash..." -ForegroundColor Yellow
    $localSHA512 = (Get-FileHash -Path $filePath -Algorithm SHA512).Hash
    $remoteSHA512 = (Invoke-RestMethod -Uri $hashSource).Split("`n") | Select-String -Pattern "win64/$Lang/Firefox Setup $Version.exe" | ForEach-Object { $_.Line.Split(" ")[0].Trim() }

    if ($localSHA512 -eq $remoteSHA512) {
        Write-Host "SHA-512 Hash verification successful." -ForegroundColor Green
    } else {
        Write-Host "SHA-512 Hash verification failed, consider using -SkipHashCheck." -ForegroundColor Red
        PauseNull
    }
}

function InstallFirefox($setupFile) {
    Write-Host "`nInstalling Mozilla Firefox..." -ForegroundColor Yellow
    Stop-Process -Name "firefox" -ErrorAction SilentlyContinue

    try {
        Start-Process -FilePath $setupFile -ArgumentList "/S /MaintenanceService=false" -Wait
        Write-Host "Installation successful." -ForegroundColor Green
    } catch {
        Write-Host "Error occurred while installing 'Mozilla Firefox $Version.exe': $_" -ForegroundColor Red
        PauseNull
    }
}

function CleanUp($setupFile, $installDir) {
    Write-Host "`nRemoving unnecessary files..." -ForegroundColor Yellow

    if (Test-Path $setupFile -PathType Leaf) {
        Remove-Item $setupFile -Force
        Write-Host "Removed: Mozilla Firefox $Version.exe" -ForegroundColor Green
    }

    $removeFiles = @(
        "crashreporter.exe", "crashreporter.ini", "defaultagent.ini", "defaultagent_localized.ini",
        "default-browser-agent.exe", "maintenanceservice.exe", "maintenanceservice_installer.exe",
        "minidump-analyzer.exe", "pingsender.exe", "updater.exe", "updater.ini", "update-settings.ini"
    )

    foreach ($file in $removeFiles) {
        $filePath = Join-Path -Path $installDir -ChildPath $file
        if (Test-Path $filePath -PathType Leaf) {
            Remove-Item $filePath -Force
            Write-Host "Removed: $file" -ForegroundColor Green
        }
    }
}

function ConfigureFirefox($installDir) {
    Write-Host "`nConfiguring Mozilla Firefox settings..." -ForegroundColor Yellow

    $distributionDir = Join-Path -Path $installDir -ChildPath "distribution"
    if (-not (Test-Path $distributionDir)) {
        New-Item -Path $distributionDir -ItemType Directory -Force | Out-Null
    }

    $configFiles = @{
        "policies.json" = "https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Extra/policies.json"
        "autoconfig.js" = "https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Extra/autoconfig.js"
        "firefox.cfg" = "https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Extra/firefox.cfg"
    }

    foreach ($file in $configFiles.Keys) {
        $filePath = Join-Path -Path $distributionDir -ChildPath $file
        if (-not (Test-Path $filePath)) {
            DownloadFile -url $configFiles[$file] -destination $filePath
        }
    }
}

function ApplyTheme {
    $profilePath = (Get-Item "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release").FullName
    if (-not (Test-Path "$profilePath\chrome") -and (Get-Command "git" -ErrorAction SilentlyContinue)) {
        Write-Host "`nInstalling 'Firefox Mod Blur' Theme..." -ForegroundColor Yellow
        git clone --depth 1 -q https://github.com/datguypiko/Firefox-Mod-Blur "$profilePath\chrome"
        Remove-Item "$profilePath\chrome\*" -Exclude "ASSETS", "userChrome.css", "userContent.css" -Force -Recurse
        Write-Host "Theme installed at default profile path '$profilePath\chrome'" -ForegroundColor Green
    }
}

function main {
    CheckAdminPrivileges
    CheckInternetConnectivity

    Write-Host "Starting Firefox installation process..." -ForegroundColor Yellow

    try {
        $response = Invoke-RestMethod -Uri "https://product-details.mozilla.org/1.0/firefox_versions.json"
    } catch {
        Write-Host "Failed to fetch JSON data: $_" -ForegroundColor Red
        PauseNull
    }

    $remoteVersion = switch ($Edition) {
        "Developer" { $response.FIREFOX_DEVEDITION }
        "Enterprise" { $response.FIREFOX_ESR }
        default { $response.LATEST_FIREFOX_VERSION }
    }

    $remoteVersion = if ($Version) { $Version } else { $remoteVersion }
    $downloadUrl = "https://releases.mozilla.org/pub/firefox/releases/$remoteVersion/win64/$Lang/Firefox%20Setup%20$remoteVersion.exe"
    $hashSource = "https://ftp.mozilla.org/pub/firefox/releases/$remoteVersion/SHA512SUMS"
    $installDir = "$env:PROGRAMFILES\Mozilla Firefox"
    $setupFile = "$env:TEMP\Firefox Setup $remoteVersion.exe"

    if (Test-Path "$installDir\firefox.exe" -PathType Leaf) {
        $localVersion = (Get-Item "$installDir\firefox.exe").VersionInfo.ProductVersion

        if ($localVersion -eq $remoteVersion) {
            Write-Host "Mozilla Firefox v$remoteVersion is already installed." -ForegroundColor Green

            if ($Force) {
                Write-Warning "-Force specified, proceeding anyway."
            } else {
                PauseNull
            }
        }
    }

    DownloadFile -url $downloadUrl -destination $setupFile

    if (-not $SkipHashCheck) {
        VerifyHash -filePath $setupFile -hashSource $hashSource
    }

    InstallFirefox -setupFile $setupFile
    CleanUp -setupFile $setupFile -installDir $installDir

    if ($Configs) {
        ConfigureFirefox -installDir $installDir
    }

    if ($Theme) {
        ApplyTheme
    }

    Write-Host "`nRelease notes: https://www.mozilla.org/en-US/firefox/$remoteVersion/releasenotes" -ForegroundColor Green
    return 0
}

exit (main)
