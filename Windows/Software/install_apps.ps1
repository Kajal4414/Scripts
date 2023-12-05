# Define software URLs with splatting for better readability
$softwareURLs = @{
    "7-Zip v23.01 x64.exe"                 = "https://www.7-zip.org/a/7z2301-x64.exe"
    "BleachBit v4.6.0 x64.exe"             = "https://download.bleachbit.org/BleachBit-4.6.0-setup.exe"
    "Chrome vLatest x64.exe"               = "https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe"
    "Git v2.43.0 x64.exe"                  = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
    "IDM v6.42 Build 2 x86.exe"            = "https://mirror2.internetdownloadmanager.com/idman642build2.exe?v=lt&filename=idman642build2.exe"
    "IntelliJ IDEA v2023.2.5 x64.exe"      = "https://download-cdn.jetbrains.com/idea/ideaIC-2023.2.5.exe"
    "JDK v21.0.1 x64.exe"                  = "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe"
    "K-Lite Codec Pack v17.9.4 x64.exe"    = "https://files2.codecguide.com/K-Lite_Codec_Pack_1794_Full.exe"
    "Notepad++ v8.6 x64.exe"               = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6/npp.8.6.Installer.x64.exe"
    "ProtonVPN v3.2.7 x64.exe"             = "https://protonvpn.com/download/ProtonVPN_v3.2.7.exe"
    "Node.js v20.10.0 x64.exe"             = "https://nodejs.org/dist/v20.10.0/node-v20.10.0-x64.msi"
    "PyCharm v2023.2.5 x64.exe"            = "https://download-cdn.jetbrains.com/python/pycharm-community-2023.2.5.exe"
    "Python v3.12.0 x64.exe"               = "https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe"
    "Revo Uninstaller Pro vLatest x64.exe" = "https://download.revouninstaller.com/download/RevoUninProSetup.exe"
    "StartIsBack vLatest x86.exe"          = "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe"
    "Telegram vLatest x64.exe"             = "https://telegram.org/dl/desktop/win64"
    "Visual Studio Code v1.84.2 x64.exe"   = "https://az764295.vo.msecnd.net/stable/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/VSCodeSetup-x64-1.84.2.exe"
    "VLC v3.0.20 x64.exe"                  = "https://mirror.kku.ac.th/videolan/vlc/3.0.20/win64/vlc-3.0.20-win64.exe"
    "Youtube Downloader v1.10.8 x64.zip"   = "https://github.com/Tyrrrz/YoutubeDownloader/releases/download/1.10.8/YoutubeDownloader.zip"
}

# Define download folder
$downloadFolder = "$Env:UserProfile\Downloads"

# Function to check if software is already installed
function CheckIfInstalled {
    param($appName)

    $x64Apps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName
    $x86Apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName

    $appNamePrefix = $appName -replace 'v.*$' # Remove text after 'v' in $appName
    $installedApps = $x64Apps.DisplayName + $x86Apps.DisplayName  # Combine all display names

    foreach ($installedApp in $installedApps) {
        if ($installedApp -like "*$appNamePrefix*") {
            # Check if the app name is contained within any display name
            return $true
        }
    }
    return $false
}

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

    # Define the file path based on the download folder and software name
    $filePath = Join-Path -Path $downloadFolder -ChildPath $appName

    # Check if the file already exists at the specified file path
    if (Test-Path -Path $filePath) {
        Write-Host "Skipping: '$appName' already exists in the download folder." -ForegroundColor Yellow
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
    param($appName)

    if ($appName -like "Youtube Downloader*") {
        Write-Host "Extracting '$appName' installer to C:\Program Files\YoutubeDownloader..." -ForegroundColor Cyan
        Expand-Archive -Path "$downloadFolder\$appName" -DestinationPath "C:\Program Files\YoutubeDownloader" -Force
        return
    }

    $installerPath = Join-Path -Path $downloadFolder -ChildPath "$appName"
    if (-not (Test-Path -Path $installerPath)) {
        Write-Host "Skipped: '$appName' installer not found." -ForegroundColor Yellow
        return
    }

    Write-Host "Installing '$appName'" -ForegroundColor Cyan
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
}

# Loop through software URLs, download, and install
foreach ($app in $softwareURLs.GetEnumerator()) {
    $appName = $app.Key
    $appURL = $app.Value

    if (-not (CheckIfInstalled -appName $appName)) {
        DownloadSoftware -appName $appName -appURL $appURL
        InstallSoftware -appName $appName
    }
    else {
        Write-Host "'$appName' is already installed." -ForegroundColor Yellow
    }
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
if (Test-Path -Path $vsCodeSettingsDirectory -PathType Container) {
    $configureVSCode = PromptForInputWithDefault "Do you want to configure Visual Studio Code settings and install extensions?" "N"
    if ($configureVSCode -eq "y") {
        Write-Host "Installing extensions for Visual Studio Code..." -ForegroundColor Yellow

        # List of VS Code extensions to install
        $extensions = @(
            "Catppuccin.catppuccin-vsc",
            "Catppuccin.catppuccin-vsc-icons",
            "dbaeumer.vscode-eslint",
            "eamodio.gitlens",
            "esbenp.prettier-vscode",
            "GitHub.github-vscode-theme",
            "jock.svg",
            "ms-python.black-formatter",
            "ms-python.pylint",
            "ms-python.python",
            "ms-python.vscode-pylance",
            "ms-vscode.makefile-tools",
            "ms-vscode.powershell",
            "PKief.material-icon-theme",
            "redhat.java",
            "redhat.vscode-xml",
            "redhat.vscode-yaml",
            "ritwickdey.LiveServer",
            "shd101wyy.markdown-preview-enhanced",
            "VisualStudioExptTeam.intellicode-api-usage-examples",
            "VisualStudioExptTeam.vscodeintellicode",
            "vscjava.vscode-java-debug",
            "vscjava.vscode-java-dependency",
            "vscjava.vscode-java-pack",
            "vscjava.vscode-java-test",
            "vscjava.vscode-maven"
        )

        # Loop through each extension and install it
        foreach ($extension in $extensions) {
            # Install VS Code extension
            code --install-extension $extension
        }

        Write-Host "Configuring Visual Studio Code settings..." -ForegroundColor Cyan

        # Downloading settings file for VS Code
        Invoke-WebRequest -Uri "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/C/Users/Admin/AppData/Roaming/Code/User/settings.json" -OutFile "$vsCodeSettingsDirectory\settings.json"
    }
}

# Activating Revo Uninstaller Pro if directory exists
if (Test-Path -Path $revoUninstallerDirectory -PathType Container) {
    $activateRevoUninstaller = PromptForInputWithDefault "Do you want to activate Revo Uninstaller Pro?" "N"
    if ($activateRevoUninstaller -eq "y") {
        Write-Host "Activating Revo Uninstaller Pro..." -ForegroundColor Cyan

        # Downloading license file for Revo Uninstaller Pro
        Invoke-WebRequest -Uri "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/revouninstallerpro5.lic" -OutFile "$revoUninstallerDirectory\revouninstallerpro5.lic"
    }
}

# Activating StartIsBack++ if directory exists
if (Test-Path -Path $startIsBackDirectory -PathType Container) {
    $activateStartIsBack = PromptForInputWithDefault "Do you want to activate StartIsBack++?" "N"
    if ($activateStartIsBack -eq "y") {
        Write-Host "Activating StartIsBack++..." -ForegroundColor Cyan

        # Downloading file to activate StartIsBack++
        Invoke-WebRequest -Uri "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/msimg32.dll" -OutFile "$startIsBackDirectory\msimg32.dll"
    }
}

# Activating Internet Download Manager if directory exists
if (Test-Path -Path $idmDirectory -PathType Container) {
    $activateIDM = PromptForInputWithDefault "Do you want to activate Internet Download Manager?" "N"
    if ($activateIDM -eq "y") {
        Write-Host "Activating Internet Download Manager..." -ForegroundColor Cyan

        # Activating IDM through a web request
        Invoke-RestMethod -Uri "https://massgrave.dev/ias" | Invoke-Expression
    }
}

Write-Host "`nSetup completed successfully." -ForegroundColor Green
PauseNull
