# Read software URLs from the JSON file
$softwareURLs = Get-Content -Path ".\Windows\Software\install_apps.json" | ConvertFrom-Json

# Define download folder
$downloadFolder = "$Env:UserProfile\Downloads"

# Log file path
$logFilePath = "C:\Logs\script_log.txt"

# Cache installed apps list
$installedApps = @(Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -and $_.DisplayVersion })

# Function to log messages to a file
function LogMessage($message, $color) {
    $logTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$logTime] $message"
    Add-Content -Path $logFilePath -Value $logLine
    Write-Host $logLine -ForegroundColor $color
}

# Function to download software
function DownloadSoftware($appName, $appURL, $appVersion) {
    $filePath = Join-Path -Path $downloadFolder -ChildPath "$appName$([System.IO.Path]::GetExtension($appURL))"

    try {
        foreach ($app in $installedApps) {
            if ($app.DisplayName -match "^$([Regex]::Escape($appName))" -and $app.DisplayVersion -eq $appVersion) {
                LogMessage "Skipping download: $appName v$appVersion is already installed." -ForegroundColor Yellow
                return $false
            }
        }

        if (-not $appInstalled) {
            LogMessage "Downloading: $appName v$appVersion..." -ForegroundColor Cyan
            curl.exe -o $filePath -LS $appURL
            return $filePath
        }
    }
    catch {
        LogMessage "Error occurred while downloading '$appName': $_" -ForegroundColor Red
    }
    return $false
}

# Function to install software
function InstallSoftware($filePath, $appName) {
    try {
        if (Test-Path $filePath) {
            LogMessage "Installing '$appName'" -ForegroundColor Cyan

            $extension = [System.IO.Path]::GetExtension($filePath)
            if ($extension -eq ".exe") {
                Start-Process -FilePath $filePath -WindowStyle Hidden -ArgumentList '/S' -Wait
            }
            elseif ($extension -eq ".msi") {
                Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$filePath`" /qn" -Wait
            }
            elseif ($extension -eq ".zip") {
                Expand-Archive -LiteralPath $filePath "C:\Program Files\YoutubeDownloader" -Force
            }

            LogMessage "Installation of '$appName' completed successfully." -ForegroundColor Green
        }
    }
    catch {
        LogMessage "Error occurred while installing '$appName': $_" -ForegroundColor Red
    }
}

# Download and install software using foreach loops
foreach ($app in $softwareURLs) {
    $downloadResult = DownloadSoftware -appName $app.appName -appURL $app.url -appVersion $app.version
    if ($downloadResult -ne $false) {
        InstallSoftware -filePath $downloadResult -appName $app.appName
    }
}

# Function to prompt for input with default value
function PromptForInputWithDefault($message, $defaultValue) {
    $userInput = ""
    while ($userInput -ne "y" -and $userInput -ne "n") {
        $userInput = Read-Host "$message (Y/N, Default: $defaultValue)"
        if ($userInput -ne "y" -and $userInput -ne "n" -and $userInput -ne "") {
            LogMessage "Invalid input. Please enter 'Y' to confirm or 'N' to cancel. (Default: $defaultValue)" -ForegroundColor Red
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
        LogMessage "Installing extensions for Visual Studio Code..." -ForegroundColor Yellow

        # Loop through each extension and install it
        foreach ($extension in $vsCodeExtensions) {
            code --install-extension $extension
        }

        LogMessage "Configuring Visual Studio Code settings..." -ForegroundColor Cyan

        # Downloading settings file for VS Code
        curl.exe -o "$Env:UserProfile\AppData\Roaming\Code\User\settings.json" -LS $vsCodeSettingsUrl
    }
}

# Activating Revo Uninstaller Pro
$revoLicenseUrl = ($softwareURLs | Where-Object { $_.appName -eq "Revo Uninstaller Pro" }).licUrl
if (Test-Path -Path "C:\ProgramData\VS Revo Group\Revo Uninstaller Pro" -PathType Container) {
    $activateRevoUninstaller = PromptForInputWithDefault "Do you want to activate Revo Uninstaller Pro?" "N"
    if ($activateRevoUninstaller -eq "y") {
        LogMessage "Activating Revo Uninstaller Pro..." -ForegroundColor Cyan

        # Downloading license file for Revo Uninstaller Pro
        curl.exe -o "C:\ProgramData\VS Revo Group\Revo Uninstaller Pro\revouninstallerpro5.lic" -LS $revoLicenseUrl
    }
}

# Activating StartIsBack++
$dllFileURL = ($softwareURLs | Where-Object { $_.appName -eq "StartIsBack++" }).dllUrl
if (Test-Path -Path "C:\Program Files (x86)\StartIsBack" -PathType Container) {
    $activateStartIsBack = PromptForInputWithDefault "Do you want to activate StartIsBack++?" "N"
    if ($activateStartIsBack -eq "y") {
        LogMessage "Activating StartIsBack++..." -ForegroundColor Cyan

        # Downloading file to activate StartIsBack++
        curl.exe -o "C:\Program Files (x86)\StartIsBack\msimg32.dll" -LS $dllFileURL
    }
}

# Activating Internet Download Manager
$idmActivationURL = ($softwareURLs | Where-Object { $_.appName -eq "Internet Download Manager" }).iasUrl
if (Test-Path -Path "C:\Program Files (x86)\Internet Download Manager" -PathType Container) {
    $activateIDM = PromptForInputWithDefault "Do you want to activate Internet Download Manager?" "N"
    if ($activateIDM -eq "y") {
        LogMessage "Activating Internet Download Manager..." -ForegroundColor Cyan

        # Activating IDM through a web request
        Invoke-RestMethod -Uri $idmActivationURL | Invoke-Expression
    }
}

LogMessage "`nSetup completed successfully." -ForegroundColor Green
PauseNull
