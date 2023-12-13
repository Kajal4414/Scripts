# Read software URLs from the JSON file
$softwareURLs = Get-Content -Path ".\Windows\Software\install_apps.json" | ConvertFrom-Json

# Define download folder
$downloadFolder = "$Env:UserProfile\Downloads"

# Function to pause and wait for user input
function PauseNull {
    Write-Host "Press any key to exit... " -NoNewline
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') | Out-Null
    exit
}

# Function to check admin privileges
function TestAdmin {
    $currentPrincipal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check for admin privileges
if (-not (TestAdmin)) {
    Write-Host "Error: Admin privileges required" -ForegroundColor Red
    PauseNull
}

# Function to download software
function DownloadSoftware {
    param($appName, $appURL, $appVersion)

    # Define the file path based on the download folder, software name, and file extension
    $filePath = Join-Path -Path $downloadFolder -ChildPath "$appName.exe"

    try {
        # Check if the app is already installed
        $appInstalled = $false
        $x64Apps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion
        $x86Apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion
        $installedApps = ($x64Apps + $x86Apps) | Where-Object { $null -ne $_.DisplayName } | Sort-Object DisplayName -Unique

        foreach ($app in $installedApps) {
            $escapedAppName = [Regex]::Escape($appName)
            if ($app.DisplayName -match "^$escapedAppName" -and $app.DisplayVersion -eq $appVersion) {
                Write-Host "Skipping download: $appName v$appVersion is already installed." -ForegroundColor Yellow
                return $false # Indicates that the download is skipped
            }
        }

        if (-not $appInstalled) {
            Write-Host "Downloading '$appName'..." -ForegroundColor Cyan
            # Download the software using cURL
            curl.exe -o $filePath -LS $appURL
            return $true # Indicates that the download is performed
        }
    }
    catch {
        Write-Host "Error occurred while downloading '$appName': $_" -ForegroundColor Red
    }
    return $false # Indicates that an error occurred during the download process
}

# Function to install software
function InstallSoftware {
    param($appName)

    # Check for installer path existence
    $installerPath = Join-Path -Path $downloadFolder -ChildPath "$appName.*"
    if (-not (Test-Path -Path $installerPath)) {
        Write-Host "Skipped: '$appName' installer not found." -ForegroundColor Yellow
        return
    }

    # Regular installation process
    Write-Host "Installing '$appName'" -ForegroundColor Cyan
    try {
        Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait -ErrorAction Stop
        Write-Host "Installation of '$appName' completed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error occurred while installing '$appName': $_" -ForegroundColor Red
    }
}

# Loop through software URLs, download, and install
foreach ($app in $softwareURLs) {
    $downloadResult = DownloadSoftware -appName $app.appName -appURL $app.url -appVersion $app.version
    if ($downloadResult) {
        InstallSoftware -appName $app.appName
    }
}

# Function to prompt for input with default value
function PromptForInputWithDefault($message, $defaultValue) {
    $userInput = ""
    while ($userInput -ne "y" -and $userInput -ne "n") {
        $userInput = Read-Host "$message (Y/N, Default: $defaultValue)"
        if ($userInput -ne "y" -and $userInput -ne "n" -and $userInput -ne "") {
            Write-Host "Invalid input. Please enter 'Y' to confirm or 'N' to cancel. (Default: $defaultValue)" -ForegroundColor Red
        }
        elseif ($userInput -eq "") {
            $userInput = $defaultValue
        }
    }
    return $userInput
}

# Configuring VS Code
$vsCodeExtensions = ($softwareURLs | Where-Object { $_.appName -eq "Microsoft Visual Studio Code" }).extensions
$vsCodeSettingsUrl = ($softwareURLs | Where-Object { $_.appName -eq "Microsoft Visual Studio Code" }).jsnUrl
if (Test-Path -Path "$Env:UserProfile\AppData\Roaming\Code\User" -PathType Container) {
    $configureVSCode = PromptForInputWithDefault "Do you want to configure Visual Studio Code settings and install extensions?" "N"
    if ($configureVSCode -eq "y") {
        Write-Host "Installing extensions for Visual Studio Code..." -ForegroundColor Yellow

        # Loop through each extension and install it
        foreach ($extension in $vsCodeExtensions) {
            code --install-extension $extension
        }

        Write-Host "Configuring Visual Studio Code settings..." -ForegroundColor Cyan

        # Downloading settings file for VS Code
        curl.exe -o "$Env:UserProfile\AppData\Roaming\Code\User\settings.json" -LS $vsCodeSettingsUrl
    }
}

# Activating Revo Uninstaller Pro
$revoLicenseUrl = ($softwareURLs | Where-Object { $_.appName -eq "Revo Uninstaller Pro" }).licUrl
if (Test-Path -Path "C:\ProgramData\VS Revo Group\Revo Uninstaller Pro" -PathType Container) {
    $activateRevoUninstaller = PromptForInputWithDefault "Do you want to activate Revo Uninstaller Pro?" "N"
    if ($activateRevoUninstaller -eq "y") {
        Write-Host "Activating Revo Uninstaller Pro..." -ForegroundColor Cyan

        # Downloading license file for Revo Uninstaller Pro
        curl.exe -o "C:\ProgramData\VS Revo Group\Revo Uninstaller Pro\revouninstallerpro5.lic" -LS $revoLicenseUrl
    }
}

# Activating StartIsBack++
$dllFileURL = ($softwareURLs | Where-Object { $_.appName -eq "StartIsBack++" }).dllUrl
if (Test-Path -Path "C:\Program Files (x86)\StartIsBack" -PathType Container) {
    $activateStartIsBack = PromptForInputWithDefault "Do you want to activate StartIsBack++?" "N"
    if ($activateStartIsBack -eq "y") {
        Write-Host "Activating StartIsBack++..." -ForegroundColor Cyan

        # Downloading file to activate StartIsBack++
        curl.exe -o "C:\Program Files (x86)\StartIsBack\msimg32.dll" -LS $dllFileURL
    }
}

# Activating Internet Download Manager
$idmActivationURL = ($softwareURLs | Where-Object { $_.appName -eq "Internet Download Manager" }).iasUrl
if (Test-Path -Path "C:\Program Files (x86)\Internet Download Manager" -PathType Container) {
    $activateIDM = PromptForInputWithDefault "Do you want to activate Internet Download Manager?" "N"
    if ($activateIDM -eq "y") {
        Write-Host "Activating Internet Download Manager..." -ForegroundColor Cyan

        # Activating IDM through a web request
        Invoke-RestMethod -Uri $idmActivationURL | Invoke-Expression
    }
}

Write-Host "`nSetup completed successfully." -ForegroundColor Green
PauseNull
