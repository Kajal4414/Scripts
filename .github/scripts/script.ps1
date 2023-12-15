# Initialize an array to hold the software information
$softwareList = @()

# Load the existing JSON data, preserving all information
$jsonPath = 'Windows/Software/install_apps.json'
if (Test-Path $jsonPath) {
    $existingSoftwareList = Get-Content $jsonPath | ConvertFrom-Json
}
else {
    $existingSoftwareList = @()
}

# Define a helper function to find the existing data for an app
function Get-ExistingData($appName) {
    $softwareItem = $existingSoftwareList | Where-Object { $_.appName -eq $appName }
    return $softwareItem
}

# Update the software list with new URLs but keep the existing version and extensions


# 7-Zip
$baseUrl = "https://www.7-zip.org/"

$softwareList += [PSCustomObject]@{
    appName = "7-Zip"
    version = ([regex]'Download 7-Zip ([\d.]+)').Match((Invoke-WebRequest $baseUrl -UseBasicParsing).Content).Groups[1].Value
    url     = $baseUrl + ((Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*x64.exe' } | Select-Object -First 1 -ExpandProperty Href)
}

# BleachBit
$baseUrl = "https://download.bleachbit.org/"
$finlUrl = (Invoke-WebRequest 'https://www.bleachbit.org/download/windows/' -UseBasicParsing).Links | Where-Object href -like '*BleachBit*.exe' | Select-Object -First 1

$softwareList += [PSCustomObject]@{
    appName = "BleachBit"
    version = $finlUrl.href -replace '.*BleachBit-([0-9.]+)-setup\.exe.*', '$1'
    url     = $baseUrl + $finlUrl.Href.Split('=')[-1]
}

# Brave
$baseUrl = "https://api.github.com/repos/brave/brave-browser/releases/latest"

$softwareList += [PSCustomObject]@{
    appName = "Brave"
    version = (Invoke-RestMethod $baseUrl).tag_name.TrimStart('v')
    url     = (Invoke-RestMethod $baseUrl).assets | Where-Object { $_.name -eq 'BraveBrowserStandaloneSetup.exe' } | Select-Object -ExpandProperty browser_download_url
}

# Chrome
$baseUrl = "https://chromiumdash.appspot.com/fetch_releases?channel=Stable&platform=Windows&num=1"

$softwareList += [PSCustomObject]@{
    appName = "Google Chrome"
    version = (Invoke-RestMethod $baseUrl).version
    url     = "https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe"
}

# Git
$baseUrl = "https://api.github.com/repos/git-for-windows/git/releases/latest"

$softwareList += [PSCustomObject]@{
    appName = "Git"
    version = (Invoke-RestMethod $baseUrl).tag_name -replace '^v(\d+\.\d+\.\d+).*', '$1'
    url     = (Invoke-RestMethod $baseUrl).assets | Where-Object { $_.name -like 'Git*64-bit.exe' } | Select-Object -ExpandProperty browser_download_url
}

# Gpg4win
$baseUrl = "https://files.gpg4win.org/"

$softwareList += [PSCustomObject]@{
    appName = "Gpg4win"
    version = ((Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*en.txt' } | Select-Object -Last 1 -ExpandProperty Href) -replace '.*-(\d+\.\d+\.\d+).*', '$1'
    url     = $baseUrl + 'gpg4win-latest.exe'
}

# IDM
$baseUrl = "https://www.internetdownloadmanager.com/"

$softwareList += [PSCustomObject]@{
    appName = "Internet Download Manager"
    version = if ((Invoke-WebRequest $baseUrl'news.html' -UseBasicParsing).Content -match 'new in version (\d+\.\d+) Build (\d+)') { $matches[1] + '.' + $matches[2] }
    url     = (Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*.exe' } | Select-Object -First 1 -ExpandProperty Href
}

# IntelliJ IDEA
$baseUrl = "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true"

$softwareList += [PSCustomObject]@{
    appName = "IntelliJ IDEA Community Edition"
    version = (Invoke-RestMethod -Uri $baseUrl).IIC.version
    url     = ((Invoke-RestMethod -Uri $baseUrl).IIC | Select-Object -ExpandProperty downloads).windows.link
}

$javaData = Get-ExistingData "Java(TM) SE Development Kit"
$softwareList += [PSCustomObject]@{
    appName = "Java(TM) SE Development Kit"
    version = $javaData.version
    url     = "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe"
}

$klcpData = Get-ExistingData "K-Lite Codec Pack"
$softwareList += [PSCustomObject]@{
    appName = "K-Lite Codec Pack"
    version = $klcpData.version
    url     = "$((Invoke-WebRequest -Uri 'https://codecguide.com/download_k-lite_codec_pack_full.htm' -UseBasicParsing).Links | Where-Object { $_.Href -like '*Full.exe' } | Select-Object -First 1 -ExpandProperty Href)"
}

$baseUrl = "https://nodejs.org/download/release/latest/"
$nodeData = Get-ExistingData "Node.js"
$softwareList += [PSCustomObject]@{
    appName = "Node.js"
    version = $nodeData.version
    url     = "$baseUrl$((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'node*x64.msi' } | Select-Object -First 1 -ExpandProperty Href)"
}

$vsCodeData = Get-ExistingData "Microsoft Visual Studio Code"
$softwareList += [PSCustomObject]@{
    appName    = "Microsoft Visual Studio Code"
    version    = $vsCodeData.version
    url        = "https://update.code.visualstudio.com/latest/win32-x64/stable"
    extensions = $vsCodeData.extensions
}

$nppData = Get-ExistingData "Notepad++"
$softwareList += [PSCustomObject]@{
    appName = "Notepad++"
    version = $nppData.version
    url     = "$((Invoke-RestMethod -Uri 'https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest').assets | Where-Object { $_.name -like 'npp*x64.exe' } | Select-Object -ExpandProperty browser_download_url)"
}

$obsdnData = Get-ExistingData "Obsidian"
$softwareList += [PSCustomObject]@{
    appName = "Obsidian"
    version = $obsdnData.version
    url     = $((Invoke-RestMethod -Uri 'https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest').assets | Where-Object { $_.name -like 'Obsidian.*.exe' } | Select-Object -ExpandProperty browser_download_url)[3]
}

$ompData = Get-ExistingData "OhMyPosh"
$softwareList += [PSCustomObject]@{
    appName = "OhMyPosh"
    version = $ompData.version
    url     = "$((Invoke-RestMethod -Uri 'https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/releases/latest').assets | Where-Object { $_.name -eq 'install-amd64.exe' } | Select-Object -ExpandProperty browser_download_url)"
}

$ptnData = Get-ExistingData "Proton VPN"
$softwareList += [PSCustomObject]@{
    appName = "Proton VPN"
    version = $ptnData.version
    url     = $((Invoke-RestMethod -Uri 'https://protonvpn.com/download/windows-releases.json').Categories | Where-Object { $_.name -eq 'Stable' } | Select-Object -ExpandProperty Releases)[0].File.Url
}

$pyData = Get-ExistingData "Python"
$softwareList += [PSCustomObject]@{
    appName = "Python"
    version = $pyData.version
    url     = "$((Invoke-WebRequest -Uri 'https://www.python.org/downloads/' -UseBasicParsing).Links | Where-Object { $_.Href -like '*amd64.exe' } | Select-Object -First 1 -ExpandProperty Href)"
}

$revoData = Get-ExistingData "Revo Uninstaller Pro"
$softwareList += [PSCustomObject]@{
    appName = "Revo Uninstaller Pro"
    version = $revoData.version
    url     = "https://download.revouninstaller.com/download/RevoUninProSetup.exe"
}

$sabData = Get-ExistingData "StartAllBack"
$softwareList += [PSCustomObject]@{
    appName = "StartAllBack"
    version = $sabData.version
    url     = "https://www.startallback.com/download.php"
}

$sibData = Get-ExistingData "StartIsBack++"
$softwareList += [PSCustomObject]@{
    appName = "StartIsBack++"
    version = $sibData.version
    url     = "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe"
}

$tgData = Get-ExistingData "Telegram"
$softwareList += [PSCustomObject]@{
    appName = "Telegram"
    version = $tgData.version
    url     = "https://telegram.org/dl/desktop/win64"
}

$baseUrl = "https://get.videolan.org/vlc/last/win64/"
$vlcData = Get-ExistingData "VLC media player"
$softwareList += [PSCustomObject]@{
    appName = "VLC media player"
    version = $vlcData.version
    url     = "$baseUrl$((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'vlc*.exe' } | Select-Object -First 1 -ExpandProperty Href)"
}

$ytData = Get-ExistingData "YoutubeDownloader"
$softwareList += [PSCustomObject]@{
    appName = "YoutubeDownloader"
    version = $ytData.version
    url     = "$((Invoke-RestMethod -Uri 'https://api.github.com/repos/Tyrrrz/YoutubeDownloader/releases/latest').assets | Where-Object { $_.name -eq 'YoutubeDownloader.zip' } | Select-Object -ExpandProperty browser_download_url)"
}

# Convert the software list to JSON
$json = $softwareList | ConvertTo-Json -Depth 10

# Output the JSON to a file
$json | Out-File -FilePath $jsonPath

# Optionally, write the JSON to the console
Write-Host $json
