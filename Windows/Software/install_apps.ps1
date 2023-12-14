# Read software URLs from the JSON file
$softwareURLs = Get-Content -Path ".\Windows\Software\install_apps.json" | ConvertFrom-Json

# Define download folder
$downloadFolder = "$Env:UserProfile\Downloads"

# Function to display a countdown message for 5 seconds before exiting
function PauseNull {
    $countdown = 5
    while ($countdown -gt 0) {
        Write-Host -NoNewline "Exiting in $countdown seconds...`r"
        Start-Sleep -Seconds 1
        $countdown--
    }
    exit
}

# Check for admin privileges
$currentPrincipal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Admin privileges required`n" -ForegroundColor Red
    PauseNull
}

# Cache installed apps list
$installedApps = @(Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -and $_.DisplayVersion })

# Function to download software
function DownloadSoftware($appName, $appURL, $appVersion) {
    # Get the file extension from the URL
    $fileExtension = [System.IO.Path]::GetExtension($appURL)
    $filePath = Join-Path -Path $downloadFolder -ChildPath "$appName$fileExtension"

    try {
        foreach ($app in $installedApps) {
            $escapedAppName = [Regex]::Escape($appName)
            if ($app.DisplayName -match "^$escapedAppName" -and $app.DisplayVersion -eq $appVersion) {
                Write-Host "Skipping download: $appName v$appVersion is already installed." -ForegroundColor Yellow
                return $false
            }
        }

        # Additional checks for Telegram and YoutubeDownloader
        if ($appName -eq "Telegram" -or $appName -eq "YoutubeDownloader") {
            if ($appName -eq "Telegram") {
                $appDirectory = "$Env:UserProfile\AppData\Roaming\Telegram Desktop"
                $exeName = "telegram.exe"
            }
            elseif ($appName -eq "YoutubeDownloader") {
                $appDirectory = "C:\Program Files\YoutubeDownloader"
                $exeName = "YoutubeDownloader.exe"
            }

            if (Test-Path -Path $appDirectory -PathType Container) {
                $appVersionInstalled = (Get-Item "$appDirectory\$exeName").VersionInfo.ProductVersion
                if ($appVersionInstalled -eq $appVersion) {
                    Write-Host "Skipping download: $appName v$appVersion is already installed." -ForegroundColor Yellow
                    return $false
                }
            }
        }

        if (-not $appInstalled) {
            Write-Host "Downloading: $appName v$appVersion..." -ForegroundColor Cyan
            curl.exe -o $filePath -LS $appURL
            return $filePath
        }
    }
    catch {
        Write-Host "Error occurred while downloading '$appName': $_" -ForegroundColor Red
    }
    return $false
}

# Function to install software
function InstallSoftware($filePath, $appName) {
    try {
        if (Test-Path $filePath) {
            $extension = [System.IO.Path]::GetExtension($filePath)
            Write-Host "Installing '$appName'" -ForegroundColor Cyan

            if ($extension -eq ".exe") {
                Start-Process -FilePath $filePath -WindowStyle Hidden -ArgumentList '/S' -Wait
            }
            elseif ($extension -eq ".msi") {
                Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$filePath`" /qn" -Wait
            }
            elseif ($extension -eq ".zip") {
                Expand-Archive -LiteralPath $filePath "C:\Program Files\YoutubeDownloader" -Force
            }

            Write-Host "Installation of '$appName' completed successfully." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Error occurred while installing '$appName': $_" -ForegroundColor Red
    }
}

# Download and install software using parallel processing
$softwareURLs | ForEach-Object -Parallel {
    DownloadSoftware -appName $_.appName -appURL $_.url -appVersion $_.version
} | ForEach-Object -Parallel {
    if ($_ -ne $false) {
        InstallSoftware -filePath $_ -appName $($softwareURLs.Where({$_.url -eq ($_.PSObject.Properties.Value)}).appName)
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
