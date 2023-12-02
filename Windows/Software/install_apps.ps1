# Software download URLs
$softwareURLs = @{
    "7-Zip"                = "https://www.7-zip.org/a/7z2301-x64.exe"
    "BleachBit"            = "https://download.bleachbit.org/BleachBit-4.6.0-setup.exe"
    "Chrome"               = "https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe"
    "Git"                  = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
    "IDM"                  = "https://mirror2.internetdownloadmanager.com/idman642build2.exe?v=lt&filename=idman642build2.exe"
    "K-Lite Codec Pack"    = "https://files2.codecguide.com/K-Lite_Codec_Pack_1794_Full.exe"
    "Notepad++"            = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6/npp.8.6.Installer.x64.exe"
    "ProtonVPN"            = "https://protonvpn.com/download/ProtonVPN_v3.2.7.exe"
    "Revo Uninstaller Pro" = "https://download.revouninstaller.com/download/RevoUninProSetup.exe"
    "StartIsBack"          = "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe"
    "Telegram"             = "https://telegram.org/dl/desktop/win64"
    "VLC"                  = "https://mirror.kku.ac.th/videolan/vlc/3.0.20/win64/vlc-3.0.20-win64.exe"
    "Youtube Downloader"   = "https://github.com/Tyrrrz/YoutubeDownloader/releases/download/1.10.8/YoutubeDownloader.zip"
}

# Download path
$downloadFolder = "$Env:UserProfile\Downloads"

# Function to download software if it doesn't exist with progress bar
function DownloadSoftware {
    param(
        [string]$appName,
        [string]$appURL
    )

    $filePath = Join-Path -Path $downloadFolder -ChildPath "$appName`_Installer.exe"

    if (-not (Test-Path -Path $filePath)) {
        Write-Host "Downloading $appName..."

        try {
            $webRequest = [System.Net.WebRequest]::Create($appURL)
            $webRequest.Method = "GET"

            $response = $webRequest.GetResponse()
            $stream = $response.GetResponseStream()
            $bufferSize = 8192
            $buffer = New-Object Byte[] $bufferSize
            $totalBytes = [int]$response.ContentLength
            $bytesRead = 0

            $fileStream = [System.IO.File]::Create($filePath)

            $bytesInMegabyte = 1MB

            do {
                $read = $stream.Read($buffer, 0, $buffer.Length)
                $fileStream.Write($buffer, 0, $read)
                $bytesRead += $read

                $megabytesDownloaded = $bytesRead / $bytesInMegabyte
                $totalMegabytes = $totalBytes / $bytesInMegabyte
                $percentComplete = ($bytesRead / $totalBytes) * 100

                $status = "Downloaded {0:F2} MB of {1:F2} MB" -f $megabytesDownloaded, $totalMegabytes
                Write-Progress -Activity "Downloading $appName" -Status $status -PercentComplete $percentComplete
            } while ($read -gt 0)

            $fileStream.Close()
            $stream.Close()
            $response.Close()
        }
        catch {
            Write-Host "Error occurred while downloading ${appName}: $_"
            # Handle exceptions here (e.g., clean up resources, log errors, etc.)
            if ($fileStream) { $fileStream.Close() }
            if ($stream) { $stream.Close() }
            if ($response) { $response.Close() }
        }
        finally {
            # Always ensure resources are properly disposed of
            if ($fileStream) { $fileStream.Dispose() }
            if ($stream) { $stream.Dispose() }
            if ($response) { $response.Dispose() }
        }
    }
    else {
        Write-Host "$appName already exists. Skipping download."
    }
}

# Function to install software
function InstallSoftware {
    param(
        [string]$appName
    )
    $installerPath = Join-Path -Path $downloadFolder -ChildPath "$appName`_Installer.exe"
    if (Test-Path -Path $installerPath) {
        Write-Host "Installing $appName..."
        Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
    }
}

# Download and install software
foreach ($app in $softwareURLs.GetEnumerator()) {
    DownloadSoftware -appName $app.Key -appURL $app.Value
    # InstallSoftware -appName $app.Key
}

Write-Host "Setup completed."
Pause
