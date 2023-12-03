$softwareURLs = @{
    "7-Zip v23.01 x64"                 = "https://www.7-zip.org/a/7z2301-x64.exe"
    "BleachBit v4.6.0 x64"             = "https://download.bleachbit.org/BleachBit-4.6.0-setup.exe"
    "Chrome vLatest x64"               = "https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe"
    "Git v2.43.0 x64"                  = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
    "IDM v6.42 Build 2 x86"            = "https://mirror2.internetdownloadmanager.com/idman642build2.exe?v=lt&filename=idman642build2.exe"
    "IntelliJ IDEA v2023.2.5 x64"      = "https://download-cdn.jetbrains.com/idea/ideaIC-2023.2.5.exe"
    "JDK v21.0.1 x64"                  = "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe"
    "K-Lite Codec Pack v17.9.4 x64"    = "https://files2.codecguide.com/K-Lite_Codec_Pack_1794_Full.exe"
    "Notepad++ v8.6 x64"               = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6/npp.8.6.Installer.x64.exe"
    "ProtonVPN v3.2.7 x64"             = "https://protonvpn.com/download/ProtonVPN_v3.2.7.exe"
    "Node.js v20.10.0 x64"             = "https://nodejs.org/dist/v20.10.0/node-v20.10.0-x64.msi"
    "PyCharm v2023.2.5 x64"            = "https://download-cdn.jetbrains.com/python/pycharm-community-2023.2.5.exe"
    "Python v3.12.0 x64"               = "https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe"
    "Revo Uninstaller Pro vLatest x64" = "https://download.revouninstaller.com/download/RevoUninProSetup.exe"
    "StartIsBack vLatest x86"          = "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe"
    "Telegram vLatest x64"             = "https://telegram.org/dl/desktop/win64"
    "Visual Studio Code v1.84.2 x64"   = "https://az764295.vo.msecnd.net/stable/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/VSCodeSetup-x64-1.84.2.exe"
    "VLC v3.0.20 x64"                  = "https://mirror.kku.ac.th/videolan/vlc/3.0.20/win64/vlc-3.0.20-win64.exe"
    "Youtube Downloader v1.10.8 x64"   = "https://github.com/Tyrrrz/YoutubeDownloader/releases/download/1.10.8/YoutubeDownloader.zip"
}

$downloadFolder = "$Env:UserProfile\Downloads"

function DownloadSoftware {
    param($appName, $appURL)

    $filePath = Join-Path -Path $downloadFolder -ChildPath "$appName`_Installer.exe"

    if (Test-Path -Path $filePath) {
        Write-Host "$appName already exists. Skipping download." -ForegroundColor Yellow
        return
    }

    try {
        Write-Host "Downloading $appName..." -ForegroundColor Cyan

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
            Write-Progress -Activity "Downloading $appName" -Status $status -PercentComplete $percentComplete
        } while ($read -gt 0)

        $fileStream.Close()
        $stream.Close()
        $response.Close()
    }
    catch {
        Write-Host "Error occurred while downloading ${appName}: $_" -ForegroundColor Red
    }
    finally {
        $fileStream?.Close()
        $stream?.Close()
        $response?.Close()
        $fileStream?.Dispose()
        $stream?.Dispose()
        $response?.Dispose()
    }
}

function InstallSoftware {
    param($appName)

    $installerPath = Join-Path -Path $downloadFolder -ChildPath "$appName`_Installer.exe"
    if (-not (Test-Path -Path $installerPath)) {
        Write-Host "$appName installer not found. Skipping installation." -ForegroundColor Yellow
        return
    }

    Write-Host "Installing $appName..." -ForegroundColor Cyan
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
}

foreach ($app in $softwareURLs.GetEnumerator()) {
    if ($app.Key -eq "Youtube Downloader v1.10.8 x64") {
        Expand-Archive -Path $installerPath -DestinationPath "C:\Program Files\YoutubeDownloader\"
    }
    else {
        DownloadSoftware -appName $app.Key -appURL $app.Value
        InstallSoftware -appName $app.Key
    }
}

$idmDirectory = "C:\Program Files (x86)\Internet Download Manager"
$startIsBackDirectory = "C:\Program Files (x86)\StartIsBack"
$vsCodeSettingsDirectory = "$Env:UserProfile\AppData\Roaming\Code\User"
$revoUninstallerDirectory = "C:\ProgramData\VS Revo Group\Revo Uninstaller Pro"

if (Test-Path -Path $vsCodeSettingsDirectory -PathType Container) {
    $configureVSCode = Read-Host "Do you want to configure Visual Studio Code settings? (y/n)"
    if ($configureVSCode -eq "y" -or $configureVSCode -eq "Y") {
        Write-Host "Visual Studio Code setting configuring..."
        Invoke-WebRequest -Uri "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/C/Users/Admin/AppData/Roaming/Code/User/settings.json" -OutFile "$vsCodeSettingsDirectory\settings.json"
    }
}

if (Test-Path -Path $revoUninstallerDirectory -PathType Container) {
    $activateRevoUninstaller = Read-Host "Do you want to activate Revo Uninstaller Pro? (y/n)"
    if ($activateRevoUninstaller -eq "y" -or $activateRevoUninstaller -eq "Y") {
        Write-Host "Revo Uninstaller Pro activation..."
        Invoke-WebRequest -Uri "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/revouninstallerpro5.lic" -OutFile "$revoUninstallerDirectory\revouninstallerpro5.lic"
    }
}

if (Test-Path -Path $startIsBackDirectory -PathType Container) {
    $activateStartIsBack = Read-Host "Do you want to activate StartIsBack++? (y/n)"
    if ($activateStartIsBack -eq "y" -or $activateStartIsBack -eq "Y") {
        Write-Host "StartIsBack++ activation..."
        Invoke-WebRequest -Uri "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/msimg32.dll" -OutFile "$startIsBackDirectory\msimg32.dll"
    }
}

if (Test-Path -Path $idmDirectory -PathType Container) {
    $activateIDM = Read-Host "Do you want to activate Internet Download Manager? (y/n)"
    if ($activateIDM -eq "y" -or $activateIDM -eq "Y") {
        Write-Host "Internet Download Manager activation script..."
        Invoke-RestMethod -Uri "https://massgrave.dev/ias" | Invoke-Expression
    }
}

Write-Host "`nSetup completed." -ForegroundColor Green
Pause
