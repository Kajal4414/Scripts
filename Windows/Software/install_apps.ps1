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
            $result = curl.exe -o $filePath -LS $appURL
            if ($LASTEXITCODE -ne 0) {
                throw "Download failed for '$appName'. Exit code: $LASTEXITCODE"
            }
            return $filePath
        }
    }
    catch [System.Net.WebException] {
        LogMessage "Network issue encountered while downloading '$appName': $_" -ForegroundColor Red
    }
    catch [System.UnauthorizedAccessException] {
        LogMessage "Access rights issue encountered while downloading '$appName': $_" -ForegroundColor Red
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

# Function to configure Visual Studio Code
function ConfigureVSCode($extensions, $settingsUrl) {
    try {
        $vsCodeUserFolder = "$Env:UserProfile\AppData\Roaming\Code\User"

        if (Test-Path -Path $vsCodeUserFolder -PathType Container) {
            $configureVSCode = PromptForInputWithDefault "Do you want to configure Visual Studio Code settings and install extensions?" "N"
            if ($configureVSCode -eq "y") {
                LogMessage "Installing extensions for Visual Studio Code..." -ForegroundColor Yellow

                foreach ($extension in $extensions) {
                    code --install-extension $extension
                }

                LogMessage "Configuring Visual Studio Code settings..." -ForegroundColor Cyan

                curl.exe -o "$vsCodeUserFolder\settings.json" -LS $settingsUrl
            }
        }
    }
    catch {
        LogMessage "Error occurred while configuring Visual Studio Code: $_" -ForegroundColor Red
    }
}

# Function to activate software
function ActivateSoftware($appName, $targetPath, $fileUrl) {
    try {
        if (Test-Path -Path $targetPath -PathType Container) {
            $activateSoftware = PromptForInputWithDefault "Do you want to activate $appName?" "N"
            if ($activateSoftware -eq "y") {
                LogMessage "Activating $appName..." -ForegroundColor Cyan

                curl.exe -o "$targetPath\$fileUrl" -LS $fileUrl
            }
        }
    }
    catch {
        LogMessage "Error occurred while activating $appName: $_" -ForegroundColor Red
    }
}

# Configure VS Code
$vsCodeInfo = $softwareURLs | Where-Object { $_.appName -eq "Microsoft Visual Studio Code" }
ConfigureVSCode -extensions $vsCodeInfo.extensions -settingsUrl $vsCodeInfo.jsnUrl

# Activate Revo Uninstaller Pro
ActivateSoftware -appName "Revo Uninstaller Pro" -targetPath "C:\ProgramData\VS Revo Group\Revo Uninstaller Pro" -fileUrl ($softwareURLs | Where-Object { $_.appName -eq "Revo Uninstaller Pro" }).licUrl

# Activate StartIsBack++
ActivateSoftware -appName "StartIsBack++" -targetPath "C:\Program Files (x86)\StartIsBack" -fileUrl ($softwareURLs | Where-Object { $_.appName -eq "StartIsBack++" }).dllUrl

# Activate Internet Download Manager
ActivateSoftware -appName "Internet Download Manager" -targetPath "C:\Program Files (x86)\Internet Download Manager" -fileUrl ($softwareURLs | Where-Object { $_.appName -eq "Internet Download Manager" }).iasUrl

LogMessage "`nSetup completed successfully." -ForegroundColor Green
PauseNull
