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

# Function to check admin privileges
function TestAdmin {
    $currentPrincipal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to download software
function DownloadSoftware {
    param($appName, $appURL)

    $filePath = Join-Path -Path $downloadFolder -ChildPath $appName

    if (Test-Path -Path $filePath) {
        Write-Host "Skipped: '$appName' already exists." -ForegroundColor Yellow
        return
    }

    if (-not (TestAdmin)) {
        Write-Host "Error: Administrator privileges required." -ForegroundColor Red
        exit
    }

    try {
        Write-Host "Downloading '$appName'" -ForegroundColor Cyan

        $webRequest = [System.Net.WebRequest]::Create($appURL)
        $response = $webRequest.GetResponse()
        $stream = $response.GetResponseStream()
        $fileStream = [System.IO.File]::Create($filePath)

        $bufferSize = 8192
        $buffer = New-Object Byte[] $bufferSize
        $bytesInMegabyte = 1MB
        $bytesRead = 0

        do {
            $read = $stream.Read($buffer, 0, $buffer.Length)
            $fileStream.Write($buffer, 0, $read)
            $bytesRead += $read

            $megabytesDownloaded = $bytesRead / $bytesInMegabyte
            $totalMegabytes = $response.ContentLength / $bytesInMegabyte
            $percentComplete = ($bytesRead / $response.ContentLength) * 100

            $status = "Downloaded {0:F2} MB of {1:F2} MB" -f $megabytesDownloaded, $totalMegabytes
            Write-Progress -Activity "Downloading '$appName'" -Status $status -PercentComplete $percentComplete
        } while ($read -gt 0)

        $fileStream.Close()
        $stream.Close()
        $response.Close()
    }
    catch {
        Write-Host "Error: downloading '$appName' $_" -ForegroundColor Red
    }
    finally {
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
    DownloadSoftware -appName $app.Key -appURL $app.Value
    InstallSoftware -appName $app.Key
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
        $userInput = Read-Host "$message (y/n, default: '$defaultValue')"
        if ($userInput -ne "y" -and $userInput -ne "n" -and $userInput -ne "") {
            Write-Host "Invalid input. Please enter 'y' or 'n'." -ForegroundColor Red
        }
        elseif ($userInput -eq "") {
            $userInput = $defaultValue
        }
    }
    return $userInput
}

# Configuring VS Code settings if directory exists
if (Test-Path -Path $vsCodeSettingsDirectory -PathType Container) {
    $configureVSCode = PromptForInputWithDefault "Do you want to configure Visual Studio Code settings?" "n"
    if ($configureVSCode -eq "y") {
        Write-Host "Configuring Visual Studio Code settings..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/C/Users/Admin/AppData/Roaming/Code/User/settings.json" -OutFile "$vsCodeSettingsDirectory\settings.json"
    }
}

# Activating Revo Uninstaller Pro if directory exists
if (Test-Path -Path $revoUninstallerDirectory -PathType Container) {
    $activateRevoUninstaller = PromptForInputWithDefault "Do you want to activate Revo Uninstaller Pro?" "n"
    if ($activateRevoUninstaller -eq "y") {
        Write-Host "Activating Revo Uninstaller Pro..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/revouninstallerpro5.lic" -OutFile "$revoUninstallerDirectory\revouninstallerpro5.lic"
    }
}

# Activating StartIsBack++ if directory exists
if (Test-Path -Path $startIsBackDirectory -PathType Container) {
    $activateStartIsBack = PromptForInputWithDefault "Do you want to activate StartIsBack++?" "n"
    if ($activateStartIsBack -eq "y") {
        Write-Host "Activating StartIsBack++..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/msimg32.dll" -OutFile "$startIsBackDirectory\msimg32.dll"
    }
}

# Activating Internet Download Manager if directory exists
if (Test-Path -Path $idmDirectory -PathType Container) {
    $activateIDM = PromptForInputWithDefault "Do you want to activate Internet Download Manager?" "n"
    if ($activateIDM -eq "y") {
        Write-Host "Activating Internet Download Manager..." -ForegroundColor Cyan
        Invoke-RestMethod -Uri "https://massgrave.dev/ias" | Invoke-Expression
    }
}

Write-Host "`nSetup completed." -ForegroundColor Green
