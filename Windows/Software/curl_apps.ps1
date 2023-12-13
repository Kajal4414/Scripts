# Function to simplify the download process
function DownloadFile {
    param (
        [string]$url,
        [string]$outputFile
    )

    if (Test-Path $outputFile) {
        Write-Host "Skipping: File $outputFile already exists." -ForegroundColor Yellow
    }
    else {
        Write-Host "`nDownloading: $outputFile from '$url'`n" -ForegroundColor Green
        curl.exe -LS -o $outputFile $url
        Write-Host ("-" * 100) -ForegroundColor Green
    }
}

# Function to get the latest release asset URL from GitHub
function Get-Latest-GitHub-Release {
    param (
        [string]$repoUrl,
        [string]$assetName
    )

    $releaseInfo = Invoke-RestMethod -Uri "$repoUrl/releases/latest"
    $assetUrl = $releaseInfo.assets | Where-Object { $_.name -like $assetName } | Select-Object -ExpandProperty browser_download_url
    return $assetUrl
}

# Download Chrome
DownloadFile -url "https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe" -outputFile "ChromeBrowser.exe"

# Download Brave
$braveUrl = Get-Latest-GitHub-Release -repoUrl "https://api.github.com/repos/brave/brave-browser" -assetName 'BraveBrowserStandaloneSetup.exe'
DownloadFile -url $braveUrl -outputFile "BraveBrowser.exe"

# Download Visual Studio Code
DownloadFile -url "https://update.code.visualstudio.com/latest/win32-x64/stable" -outputFile "VSCode.exe"

# Download VSCodium
$vsCodiumUrl = Get-Latest-GitHub-Release -repoUrl "https://api.github.com/repos/VSCodium/vscodium" -assetName 'VSCodiumSetup-x64*.exe'
DownloadFile -url $vsCodiumUrl -outputFile "VSCodium.exe"

# Download Notepad++
$notepadPlusPlusUrl = Get-Latest-GitHub-Release -repoUrl "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus" -assetName 'npp*x64.exe'
DownloadFile -url $notepadPlusPlusUrl -outputFile "Notepad++.exe"

# Download OhMyPosh
$ohMyPoshUrl = Get-Latest-GitHub-Release -repoUrl "https://api.github.com/repos/JanDeDobbeleer/oh-my-posh" -assetName 'install-amd64.exe'
DownloadFile -url $ohMyPoshUrl -outputFile "OhMyPosh.exe"

# Download Git for Windows
$gitUrl = Get-Latest-GitHub-Release -repoUrl "https://api.github.com/repos/git-for-windows/git" -assetName 'Git*64-bit.exe'
DownloadFile -url $gitUrl -outputFile "Git.exe"

# Download Gpg4win
DownloadFile -url "https://files.gpg4win.org/gpg4win-latest.exe" -outputFile "Gpg4win.exe"

# Download JDK
DownloadFile -url "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe" -outputFile "JDK.exe"

# Download Python
$pythonUrl = (Invoke-WebRequest -Uri 'https://www.python.org/downloads' -UseBasicParsing).Links | Where-Object { $_.Href -like '*amd64.exe' } | Select-Object -First 1 -ExpandProperty Href
DownloadFile -url $pythonUrl -outputFile "Python.exe"

# Download Visual C++ Redistributable
$visualCppUrl = Get-Latest-GitHub-Release -repoUrl "https://api.github.com/repos/abbodi1406/vcredist" -assetName 'VisualCppRedist_AIO_x86_x64.exe'
DownloadFile -url $visualCppUrl -outputFile "VisualCppRedist.exe"

# Download IDM
$idmUrl = (Invoke-WebRequest -Uri 'https://www.internetdownloadmanager.com' -UseBasicParsing).Links | Where-Object { $_.Href -like '*.exe' } | Select-Object -First 1 -ExpandProperty Href
DownloadFile -url $idmUrl -outputFile "IDM.exe"

# Download K-Lite Codec Pack
$kLiteUrl = (Invoke-WebRequest -Uri 'https://codecguide.com/download_k-lite_codec_pack_full.htm' -UseBasicParsing).Links | Where-Object { $_.Href -like '*Full.exe' } | Select-Object -First 1 -ExpandProperty Href
DownloadFile -url $kLiteUrl -outputFile "K-Lite.exe"

# Download Telegram
DownloadFile -url "https://telegram.org/dl/desktop/win64" -outputFile "Telegram.exe"

# Download Obsidian
$obsidianUrl = Get-Latest-GitHub-Release -repoUrl "https://api.github.com/repos/obsidianmd/obsidian-releases" -assetName 'Obsidian.*.exe'
DownloadFile -url $obsidianUrl[3] -outputFile "Obsidian.exe"

# Download ProtonVPN
$protonVpnUrl = (Invoke-WebRequest -Uri 'https://protonvpn.com/download-windows' -UseBasicParsing).Links | Where-Object { $_.Href -like '*.exe' } | Select-Object -First 1 -ExpandProperty Href
DownloadFile -url $protonVpnUrl -outputFile "ProtonVPN.exe"

# Download StartAllBack
DownloadFile -url "https://www.startallback.com/download.php" -outputFile "StartAllBack.exe"

# Download StartIsBack++
DownloadFile -url "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe" -outputFile "StartIsBack++.exe"

# Download Winpinator
$winpinatorUrl = Get-Latest-GitHub-Release -repoUrl "https://api.github.com/repos/swiszczoo/winpinator" -assetName 'winpinator*x64.exe'
DownloadFile -url $winpinatorUrl -outputFile "Winpinator.exe"

# Download YoutubeDownloader
$youtubeDownloaderUrl = Get-Latest-GitHub-Release -repoUrl "https://api.github.com/repos/Tyrrrz/YoutubeDownloader" -assetName 'YoutubeDownloader.zip'
DownloadFile -url $youtubeDownloaderUrl -outputFile "YoutubeDownloader.zip"

# Download 7-Zip
$sevenZipUrl = 'https://www.7-zip.org/'
DownloadFile -url "$sevenZipUrl$((Invoke-WebRequest -Uri $sevenZipUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*x64.exe' } | Select-Object -First 1 -ExpandProperty Href)" -outputFile "7-Zip.exe"

# Download VLC
$vlcUrl = 'https://get.videolan.org/vlc/last/win64/'
DownloadFile -url "$vlcUrl$((Invoke-WebRequest -Uri $vlcUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'vlc*.exe' } | Select-Object -First 1 -ExpandProperty Href)" -outputFile "VLC.exe"

# Download Node.js
$nodeUrl = 'https://nodejs.org/download/release/latest/'
DownloadFile -url "$nodeUrl$((Invoke-WebRequest -Uri $nodeUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'node*x64.msi' } | Select-Object -First 1 -ExpandProperty Href)" -outputFile "Node.msi"

Write-Host "`nAll downloads finished." -ForegroundColor Green
