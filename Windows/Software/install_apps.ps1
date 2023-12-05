# Read software URLs from the JSON file (retuns: appName, version, url).
$softwareURLs = Get-Content -Path ".\Windows\Software\softwareURLs.json" | ConvertFrom-Json

# Define download folder
$downloadFolder = "$Env:UserProfile\Downloads"

# Function to pause and wait for user input
function PauseNull {
    Write-Host "Press any key to exit... " -NoNewline
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') | Out-Null
    exit
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
    param($appName, $appVersion)

    # Check if the software is already installed and the version matches
    if (IsAppInstalled $appName $appVersion) {
        Write-Host "Skipping installation: '$appName' version '$appVersion' is already installed." -ForegroundColor Yellow
        return
    }

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

# Function to check if the software is installed and the version matches
function IsAppInstalled {
    param($appName, $appVersion)

    # Get installed applications from registry with DisplayVersion info
    $x64Apps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $appName -and $_.DisplayVersion -eq $appVersion }
    $x86Apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $appName -and $_.DisplayVersion -eq $appVersion }

    # Check if the app with specified version exists in installed apps list
    if ($x64Apps -or $x86Apps) {
        return $true
    }
    else {
        return $false
    }
}

# Loop through software URLs, download, and install
foreach ($app in $softwareURLs.GetEnumerator()) {
    DownloadSoftware -appName $app.Key -appURL $app.Value
    InstallSoftware -appName $app.Key
}
