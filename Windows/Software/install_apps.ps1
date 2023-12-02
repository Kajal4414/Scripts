$softwareURLs = @{
    "7-Zip"                = @{
        "DownloadURL" = "https://www.7-zip.org/a/7z2301-x64.exe"
        "LocalPath"   = "C:\Program Files\7-Zip"
    }
    "BleachBit"            = @{
        "DownloadURL" = "https://download.bleachbit.org/BleachBit-4.6.0-setup.exe"
        "LocalPath"   = "C:\Program Files (x86)\BleachBit"
    }
    "Chrome"               = @{
        "DownloadURL" = "https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe"
        "LocalPath"   = "C:\Program Files\Google\Chrome"
    }
    "Git"                  = @{
        "DownloadURL" = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
        "LocalPath"   = "C:\Program Files\Git"
    }
    "IDM"                  = @{
        "DownloadURL" = "https://mirror2.internetdownloadmanager.com/idman642build2.exe?v=lt&filename=idman642build2.exe"
        "LocalPath"   = "C:\Program Files (x86)\Internet Download Manager"
    }
    "K-Lite Codec Pack"    = @{
        "DownloadURL" = "https://files2.codecguide.com/K-Lite_Codec_Pack_1794_Full.exe"
        "LocalPath"   = "C:\Program Files (x86)\K-Lite Codec Pack"
    }
    "Notepad++"            = @{
        "DownloadURL" = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6/npp.8.6.Installer.x64.exe"
        "LocalPath"   = "C:\Program Files\Notepad++"
    }
    "ProtonVPN"            = @{
        "DownloadURL" = "https://protonvpn.com/download/ProtonVPN_v3.2.7.exe"
        "LocalPath"   = "C:\Program Files\Proton\VPN"
    }
    "Revo Uninstaller Pro" = @{
        "DownloadURL" = "https://download.revouninstaller.com/download/RevoUninProSetup.exe"
        "LocalPath"   = "C:\Program Files\VS Revo Group\Revo Uninstaller Pro"
    }
    "StartIsBack"          = @{
        "DownloadURL" = "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe"
        "LocalPath"   = "C:\Program Files (x86)\StartIsBack"
    }
    "Telegram"             = @{
        "DownloadURL" = "https://telegram.org/dl/desktop/win64"
        "LocalPath"   = "$Env:UserProfile\AppData\Roaming\Telegram Desktop"
    }
    "VLC"                  = @{
        "DownloadURL" = "https://mirror.kku.ac.th/videolan/vlc/3.0.20/win64/vlc-3.0.20-win64.exe"
        "LocalPath"   = "C:\Program Files\VideoLAN\VLC"
    }
    "Youtube Downloader"   = @{
        "DownloadURL" = "https://github.com/Tyrrrz/YoutubeDownloader/releases/download/1.10.8/YoutubeDownloader.zip"
        "LocalPath"   = "C:\Program Files\Youtube Downloader"
    }
}

$downloadFolder = "$Env:UserProfile\Downloads"

function DownloadSoftware {
    param($appName, $appData)

    $downloadURL = $appData["DownloadURL"]
    $filePath = Join-Path -Path $downloadFolder -ChildPath "$appName`_Installer.exe"

    if (!(Test-Path -Path $filePath)) {
        Write-Host "Downloading $appName..." -ForegroundColor Cyan

        try {
            $webRequest = [System.Net.WebRequest]::Create($downloadURL)
            $response = $webRequest.GetResponse()
            $stream = $response.GetResponseStream()
            $fileStream = [System.IO.File]::Create($filePath)

            $bufferSize = 8192
            $buffer = New-Object Byte[] $bufferSize
            $bytesRead = 0
            $bytesInMegabyte = 1MB

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
            Write-Host "Error occurred while downloading ${appName}: $_"
            if ($fileStream) { $fileStream.Close() }
            if ($stream) { $stream.Close() }
            if ($response) { $response.Close() }
        }
        finally {
            if ($fileStream) { $fileStream.Dispose() }
            if ($stream) { $stream.Dispose() }
            if ($response) { $response.Dispose() }
        }
    }
    else {
        Write-Host "$appName already exists. Skipping download." -ForegroundColor Yellow
    }
}

function InstallSoftware {
    param($appName, $appData)

    $localPath = $appData["LocalPath"]
    $installed = $false

    if (Test-Path -Path $localPath) {
        $installed = $true
    }
    else {
        $installerPath = Join-Path -Path $downloadFolder -ChildPath "$appName`_Installer.exe"
        if (Test-Path -Path $installerPath) {
            Write-Host "Installing $appName..."
            Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
            $installed = $true
        }
    }

    if ($installed) {
        Write-Host "$appName is already installed. Skipping Installation." -ForegroundColor Yellow
    }
}

foreach ($app in $softwareURLs.GetEnumerator()) {
    $appName = $app.Key
    $appData = $app.Value

    DownloadSoftware -appName $appName -appData $appData
    InstallSoftware -appName $appName -appData $appData
}

Write-Host "`nSetup completed." -ForegroundColor Green
