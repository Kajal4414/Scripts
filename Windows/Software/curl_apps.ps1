curl.exe -LS -o ChromeBrowser.exe https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe
curl.exe -LS -o BraveBrowser.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/brave/brave-browser/releases/latest').assets | Where-Object { $_.name -eq 'BraveBrowserStandaloneSetup.exe' } | Select-Object -ExpandProperty browser_download_url)
curl.exe -LS -o VSCode.exe https://update.code.visualstudio.com/latest/win32-x64/stable
curl.exe -LS -o VSCodium.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/VSCodium/vscodium/releases/latest').assets | Where-Object { $_.name -like 'VSCodiumSetup-x64*.exe' } | Select-Object -ExpandProperty browser_download_url)
curl.exe -LS -o Notepad++.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest').assets | Where-Object { $_.name -like 'npp*x64.exe' } | Select-Object -ExpandProperty browser_download_url)
curl.exe -LS -o OhMyposh.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/releases/latest').assets | Where-Object { $_.name -eq 'install-amd64.exe' } | Select-Object -ExpandProperty browser_download_url)
curl.exe -LS -o Git.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest').assets | Where-Object { $_.name -like 'Git*64-bit.exe' } | Select-Object -ExpandProperty browser_download_url)
curl.exe -LS -o Gpg4win.exe https://files.gpg4win.org/gpg4win-latest.exe
curl.exe -LS -o JDK.exe https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe
curl.exe -LS -o Python.exe "$((Invoke-WebRequest -Uri 'https://www.python.org/downloads' -UseBasicParsing).Links | Where-Object { $_.Href -like '*amd64.exe' } | Select-Object -First 1 -ExpandProperty Href)"
curl.exe -LS -o VisualCppRedist.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/abbodi1406/vcredist/releases/latest').assets | Where-Object { $_.name -eq 'VisualCppRedist_AIO_x86_x64.exe' } | Select-Object -ExpandProperty browser_download_url)
curl.exe -LS -o IDM.exe "$((Invoke-WebRequest -Uri 'https://www.internetdownloadmanager.com' -UseBasicParsing).Links | Where-Object { $_.Href -like '*.exe' } | Select-Object -First 1 -ExpandProperty Href)"
curl.exe -LS -o K-Lite.exe "$((Invoke-WebRequest -Uri 'https://codecguide.com/download_k-lite_codec_pack_full.htm' -UseBasicParsing).Links | Where-Object { $_.Href -like '*Full.exe' } | Select-Object -First 1 -ExpandProperty Href)"
curl.exe -LS -o Telegram.exe https://telegram.org/dl/desktop/win64
curl.exe -LS -o Obsidian.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest').assets | Where-Object { $_.name -like 'Obsidian.*.exe' } | Select-Object -ExpandProperty browser_download_url)[3]
curl.exe -LS -o ProtonVPN.exe "$((Invoke-WebRequest -Uri 'https://protonvpn.com/download-windows' -UseBasicParsing).Links | Where-Object { $_.Href -like '*.exe' } | Select-Object -First 1 -ExpandProperty Href)"
curl.exe -LS -o StartAllBack.exe https://www.startallback.com/download.php
curl.exe -LS -o StartIsBack++.exe https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe
curl.exe -LS -o Winpinator.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/swiszczoo/winpinator/releases/latest').assets | Where-Object { $_.name -like 'winpinator*x64.exe' } | Select-Object -ExpandProperty browser_download_url)
curl.exe -LS -o YoutubeDownloader.zip $((Invoke-RestMethod -Uri 'https://api.github.com/repos/Tyrrrz/YoutubeDownloader/releases/latest').assets | Where-Object { $_.name -eq 'YoutubeDownloader.zip' } | Select-Object -ExpandProperty browser_download_url)

$baseUrl = 'https://www.7-zip.org/'; curl.exe -LS -o 7-Zip.exe "$baseUrl$((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*x64.exe' } | Select-Object -First 1 -ExpandProperty Href)"
$baseUrl = 'https://get.videolan.org/vlc/last/win64/'; curl.exe -LS -o VLC.exe "$baseUrl$((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'vlc*.exe' } | Select-Object -First 1 -ExpandProperty Href)"
$baseUrl = 'https://nodejs.org/download/release/latest/'; curl.exe -LS -o Node.msi "$baseUrl$((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'node*x64.msi' } | Select-Object -First 1 -ExpandProperty Href)"
