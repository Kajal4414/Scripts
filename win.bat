@echo off

echo Installing VLC...
powershell -Command "& { (New-Object Net.WebClient).DownloadFile('https://download.videolan.org/vlc/3.0.11/win64/vlc-3.0.11-win64.exe', 'vlc-installer.exe') }"
vlc-installer.exe /S

echo Installing Chrome...
powershell -Command "& { (New-Object Net.WebClient).DownloadFile('https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi', 'chrome-installer.msi') }"
msiexec /i chrome-installer.msi /quiet

echo Installing Firefox...
powershell -Command "& { (New-Object Net.WebClient).DownloadFile('https://download-installer.cdn.mozilla.net/pub/firefox/releases/89.0/win64/en-US/Firefox%20Setup%2089.0.exe', 'firefox-installer.exe') }"
firefox-installer.exe /S

echo Installation complete.
