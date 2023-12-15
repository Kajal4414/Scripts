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
$baseUrl = "https://www.internetdownloadmanager.com/news.html"

$softwareList += [PSCustomObject]@{
    appName = "Internet Download Manager"
    version = (([regex]'new in version (\d+\.\d+) Build (\d+)').Match((Invoke-WebRequest $baseUrl -UseBasicParsing).Content).Groups[1, 2] -join '.')
    url     = (Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*.exe' } | Select-Object -First 1 -ExpandProperty Href
}

# IntelliJ IDEA
$baseUrl = "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true"

$softwareList += [PSCustomObject]@{
    appName = "IntelliJ IDEA Community Edition"
    version = (Invoke-RestMethod $baseUrl).IIC.version
    url     = ((Invoke-RestMethod $baseUrl).IIC | Select-Object -ExpandProperty downloads).windows.link
}

# JDK
$baseUrl = "https://www.oracle.com/java/technologies/downloads/"

$softwareList += [PSCustomObject]@{
    appName = "Java(TM) SE Development Kit"
    version = ([regex]'JDK Development Kit (\d+\.\d+\.\d+)').Match((Invoke-WebRequest $baseUrl -UseBasicParsing).Content).Groups[1].Value
    url     = "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe"
}

# K-Lite
$baseUrl = "https://codecguide.com/download_k-lite_codec_pack_full.htm"

$softwareList += [PSCustomObject]@{
    appName = "K-Lite Codec Pack"
    version = ([regex]'Version (\d+\.\d+\.\d+) Full').Match((Invoke-WebRequest $baseUrl -UseBasicParsing).Content).Groups[1].Value
    url     = (Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*Full.exe' } | Select-Object -First 1 -ExpandProperty Href
}

# Node.js
$baseUrl = "https://nodejs.org/download/release/latest/"

$softwareList += [PSCustomObject]@{
    appName = "Node.js"
    version = ((Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'node*x64.msi' } | Select-Object -First 1 -ExpandProperty Href) -replace '.*node-v(\d+\.\d+\.\d+).*', '$1'
    url     = $baseUrl + ((Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'node*x64.msi' } | Select-Object -First 1 -ExpandProperty Href)
}

# VS Code
$baseUrl = "https://api.github.com/repos/microsoft/vscode/releases/latest"
$vscData = Get-ExistingData "Microsoft Visual Studio Code"

$softwareList += [PSCustomObject]@{
    appName    = "Microsoft Visual Studio Code"
    version    = (Invoke-RestMethod $baseUrl).tag_name
    url        = "https://update.code.visualstudio.com/latest/win32-x64/stable"
    extensions = $vscData.extensions
}

# Notepad++
$baseUrl = "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest"

$softwareList += [PSCustomObject]@{
    appName = "Notepad++"
    version = (Invoke-RestMethod $baseUrl).tag_name.TrimStart('v')
    url     = (Invoke-RestMethod $baseUrl).assets | Where-Object { $_.name -like 'npp*x64.exe' } | Select-Object -ExpandProperty browser_download_url
}

# Obsidian
$baseUrl = "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"

$softwareList += [PSCustomObject]@{
    appName = "Obsidian"
    version = (Invoke-RestMethod $baseUrl).tag_name.TrimStart('v')
    url     = ((Invoke-RestMethod $baseUrl).assets | Where-Object { $_.name -like 'Obsidian.*.exe' } | Select-Object -ExpandProperty browser_download_url)[3]
}

# OhMyPosh
$baseUrl = "https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/releases/latest"

$softwareList += [PSCustomObject]@{
    appName = "OhMyPosh"
    version = (Invoke-RestMethod $baseUrl).tag_name.TrimStart('v')
    url     = (Invoke-RestMethod $baseUrl).assets | Where-Object { $_.name -eq 'install-amd64.exe' } | Select-Object -ExpandProperty browser_download_url
}

# Proton VPN
$baseUrl = "https://protonvpn.com/download/windows-releases.json"
$finlUrl = ((Invoke-RestMethod $baseUrl).Categories | Where-Object { $_.Name -eq 'Stable' } | Select-Object -ExpandProperty Releases)[0]

$softwareList += [PSCustomObject]@{
    appName = "Proton VPN"
    version = $finlUrl.Version
    url     = $finlUrl.File.Url
}

# Python
$baseUrl = "https://www.python.org/downloads/"

$softwareList += [PSCustomObject]@{
    appName = "Python"
    version = ([regex]'python-(\d+\.\d+\.\d+)').Match((Invoke-WebRequest $baseUrl -UseBasicParsing).Content).Groups[1].Value
    url     = (Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*amd64.exe' } | Select-Object -First 1 -ExpandProperty Href
}

# Revo Uninstaller
$baseUrl = "https://www.revouninstaller.com/revo-uninstaller-pro-full-version-history/"

$softwareList += [PSCustomObject]@{
    appName = "Revo Uninstaller Pro"
    version = ([regex]'VERSION (\d+\.\d+\.\d+)').Match((Invoke-WebRequest $baseUrl -UseBasicParsing).Content).Groups[1].Value
    url     = (Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*RevoUninProSetup.exe' } | Select-Object -First 1 -ExpandProperty Href
}

# StartAllBack
$baseUrl = "https://www.startallback.com/"

$softwareList += [PSCustomObject]@{
    appName = "StartAllBack"
    version = ([regex]'Download v(\d+\.\d+\.\d+)').Match((Invoke-WebRequest $baseUrl -UseBasicParsing).Content).Groups[1].Value
    url     = $baseUrl + 'download.php'
}

# StartIsBack++
$baseUrl = "https://www.startisback.com/#download-tab/"

$softwareList += [PSCustomObject]@{
    appName = "StartIsBack++"
    version = ([regex]'StartIsBack\+\+ (\d+\.\d+\.\d+)').Match((Invoke-WebRequest $baseUrl -UseBasicParsing).Content).Groups[1].Value
    url     = (Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*setup.exe' } | Select-Object -First 1 -ExpandProperty Href
}

# Telegram
# $baseUrl = "https://telegram.org/dl/desktop/win64"
# $finlUrl = (Invoke-WebRequest $baseUrl -MaximumRedirection 0 -UseBasicParsing -ErrorAction SilentlyContinue).Headers.Location

$softwareList += [PSCustomObject]@{
    appName = "Telegram"
    version = "4.12.2"
    url     = "https://telegram.org/dl/desktop/win64"
}

# VLC
$baseUrl = "https://get.videolan.org/vlc/last/win64/"
$finlUrl = (Invoke-WebRequest $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'vlc*win64.exe' } | Select-Object -First 1 -ExpandProperty Href

$softwareList += [PSCustomObject]@{
    appName = "VLC media player"
    version = $finlUrl -replace 'vlc-(.*)-win64\.exe', '$1'
    url     = $baseUrl + $finlUrl
}

# YoutubeDownloader
$baseUrl = "https://api.github.com/repos/Tyrrrz/YoutubeDownloader/releases/latest"

$softwareList += [PSCustomObject]@{
    appName = "YoutubeDownloader"
    version = (Invoke-RestMethod $baseUrl).tag_name
    url     = ((Invoke-RestMethod $baseUrl).assets | Where-Object { $_.name -eq 'YoutubeDownloader.zip' } | Select-Object -ExpandProperty browser_download_url)
}

# Convert the software list to JSON
$json = $softwareList | ConvertTo-Json -Depth 10

# Output the JSON to a file
$json | Out-File -FilePath $jsonPath
