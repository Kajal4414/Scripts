# Read software URLs from the JSON file
$softwareURLs = Get-Content -Path ".\Windows\Software\softwareURLs.json" | ConvertFrom-Json

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
    param($appName, $appURL)

    # Get the file extension from the URL
    $fileExtension = [System.IO.Path]::GetExtension($appURL)

    # Define the file path based on the download folder, software name, and file extension
    $filePath = Join-Path -Path $downloadFolder -ChildPath "$appName$fileExtension"

    # Check if the file already exists at the specified file path
    if (Test-Path -Path $filePath) {
        Write-Host "Skipping downloading: '$appName' already exists in the download folder." -ForegroundColor Yellow
        return
    }

    # Attempt to download the software
    try {
        Write-Host "Downloading '$appName'..." -ForegroundColor Cyan

        # Create a web request to the provided software URL
        $webRequest = [System.Net.WebRequest]::Create($appURL)
        $response = $webRequest.GetResponse()
        $stream = $response.GetResponseStream()
        $fileStream = [System.IO.File]::Create($filePath)

        # Define buffer settings for the download process
        $bufferSize = 8192
        $buffer = New-Object Byte[] $bufferSize
        $bytesInMegabyte = 1MB
        $bytesRead = 0

        # Start downloading in chunks until the entire file is downloaded
        do {
            $read = $stream.Read($buffer, 0, $buffer.Length)
            $fileStream.Write($buffer, 0, $read)
            $bytesRead += $read

            # Calculate download progress and display it
            $megabytesDownloaded = $bytesRead / $bytesInMegabyte
            $totalMegabytes = $response.ContentLength / $bytesInMegabyte
            $percentComplete = ($bytesRead / $response.ContentLength) * 100

            $status = "Downloaded {0:F2} MB of {1:F2} MB" -f $megabytesDownloaded, $totalMegabytes
            Write-Progress -Activity "Downloading '$appName'" -Status $status -PercentComplete $percentComplete
        } while ($read -gt 0)

        # Close streams and response after download completion
        $fileStream.Close()
        $stream.Close()
        $response.Close()

        Write-Host "Downloaded '$appName' successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error occurred while downloading '$appName': $_" -ForegroundColor Red
    }
    finally {
        # Dispose resources in the finally block to ensure cleanup
        $fileStream, $stream, $response | ForEach-Object {
            if ($_ -ne $null) {
                $_.Close()
                $_.Dispose()
            }
        }
    }
}

# Function to install software
function InstallSoftware {
    param($appName, $appVersion)

    # Check if the software is already installed and the version matches
    if (IsAppInstalled $appName $appVersion) {
        Write-Host "Skipping installation: '$appName' version '$appVersion' is already installed." -ForegroundColor Yellow
        return
    }

    # Custom handling for certain apps like YouTube Downloader
    if ($appName -like "Youtube Downloader*") {
        Write-Host "Extracting '$appName' installer to C:\Program Files\YoutubeDownloader..." -ForegroundColor Cyan
        try {
            Expand-Archive -Path "$downloadFolder\$appName" -DestinationPath "C:\Program Files\YoutubeDownloader" -Force
            Write-Host "Installation of '$appName' extracted to C:\Program Files\YoutubeDownloader successfully." -ForegroundColor Green
        }
        catch {
            Write-Host "Error occurred while extracting '$appName' installer: $_" -ForegroundColor Red
        }
        return
    }

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

# Function to check if the software is installed and the version matches
function IsAppInstalled {
    param($appName, $appVersion)

    # Get installed applications from registry with DisplayVersion info
    $x64Apps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion
    $x86Apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion

    # Check if the app with specified version exists in installed apps list
    if ($x64Apps.DisplayVersion -contains $appVersion -or $x86Apps.DisplayVersion -contains $appVersion) {
        return $true
    }
    else {
        return $false
    }
}

# Loop through software URLs, download, and install
foreach ($app in $softwareURLs) {
    DownloadSoftware -appName $app.appName -appURL $app.url
    InstallSoftware -appName $app.appName -appVersion $app.version
}

# Directories for specific software
$idmDirectory = "C:\Program Files (x86)\Internet Download Manager"
$startIsBackDirectory = "C:\Program Files (x86)\StartIsBack"
$vsCodeSettingsDirectory = "$Env:UserProfile\AppData\Roaming\Code\User"
$revoUninstallerDirectory = "C:\ProgramData\VS Revo Group\Revo Uninstaller Pro"

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

# Configuring VS Code settings if directory exists
$vsCodeExtensions = ($softwareURLs | Where-Object { $_.appName -eq "Microsoft Visual Studio Code" }).extensions
$vsCodeSettingsUrl = ($softwareURLs | Where-Object { $_.appName -eq "Microsoft Visual Studio Code" }).jsnUrl
if (Test-Path -Path $vsCodeSettingsDirectory -PathType Container) {
    $configureVSCode = PromptForInputWithDefault "Do you want to configure Visual Studio Code settings and install extensions?" "N"
    if ($configureVSCode -eq "y") {
        Write-Host "Installing extensions for Visual Studio Code..." -ForegroundColor Yellow

        # Loop through each extension and install it
        foreach ($extension in $vsCodeExtensions) {
            code --install-extension $extension
        }

        Write-Host "Configuring Visual Studio Code settings..." -ForegroundColor Cyan

        # Downloading settings file for VS Code
        Invoke-WebRequest -Uri $vsCodeSettingsUrl -OutFile "$vsCodeSettingsDirectory\settings.json"
    }
}

# Activating Revo Uninstaller Pro if directory exists
$revoLicenseUrl = ($softwareURLs | Where-Object { $_.appName -eq "Revo Uninstaller Pro" }).licUrl
if (Test-Path -Path $revoUninstallerDirectory -PathType Container) {
    $activateRevoUninstaller = PromptForInputWithDefault "Do you want to activate Revo Uninstaller Pro?" "N"
    if ($activateRevoUninstaller -eq "y") {
        Write-Host "Activating Revo Uninstaller Pro..." -ForegroundColor Cyan

        # Downloading license file for Revo Uninstaller Pro
        Invoke-WebRequest -Uri $revoLicenseUrl -OutFile "$revoUninstallerDirectory\revouninstallerpro5.lic"
    }
}

# Activating StartIsBack++ if directory exists
$dllFileURL = ($softwareURLs | Where-Object { $_.appName -eq "StartIsBack++" }).dllUrl
if (Test-Path -Path $startIsBackDirectory -PathType Container) {
    $activateStartIsBack = PromptForInputWithDefault "Do you want to activate StartIsBack++?" "N"
    if ($activateStartIsBack -eq "y") {
        Write-Host "Activating StartIsBack++..." -ForegroundColor Cyan

        # Downloading file to activate StartIsBack++
        Invoke-WebRequest -Uri $dllFileURL -OutFile "$startIsBackDirectory\msimg32.dll"
    }
}

# Activating Internet Download Manager if directory exists
$idmActivationURL = ($softwareURLs | Where-Object { $_.appName -eq "Internet Download Manager" }).iasUrl
if (Test-Path -Path $idmDirectory -PathType Container) {
    $activateIDM = PromptForInputWithDefault "Do you want to activate Internet Download Manager?" "N"
    if ($activateIDM -eq "y") {
        Write-Host "Activating Internet Download Manager..." -ForegroundColor Cyan

        # Activating IDM through a web request
        Invoke-RestMethod -Uri $idmActivationURL | Invoke-Expression
    }
}

Write-Host "`nSetup completed successfully." -ForegroundColor Green
PauseNull
