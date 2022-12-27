@echo off

echo Checking if VLC is already installed...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player" /v DisplayName >nul 2>&1
if %errorlevel% == 1 (
  echo VLC is not installed. Installing...
  powershell -Command "& { (New-Object Net.WebClient).DownloadFile('https://download.videolan.org/vlc/3.0.11/win64/vlc-3.0.11-win64.exe', 'vlc-installer.exe') }"
  vlc-installer.exe /S
) else (
  echo VLC is already installed. Skipping installation.
)

echo Checking if Chrome is already installed...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" /v DisplayName >nul 2>&1
if %errorlevel% == 1 (
  echo Chrome is not installed. Installing...
  powershell -Command "& { (New-Object Net.WebClient).DownloadFile('https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi', 'chrome-installer.msi') }"
  msiexec /i chrome-installer.msi /quiet
) else (
  echo Chrome is already installed. Skipping installation.
)

echo Checking if Firefox is already installed...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla\Mozilla Firefox" /v DisplayName >nul 2>&1
if %errorlevel% == 1 (
  echo Firefox is not installed. Installing...
  powershell -Command "& { (New-Object Net.WebClient).DownloadFile('https://download-installer.cdn.mozilla.net/pub/firefox/releases/89.0/win64/en-US/Firefox%20Setup%2089.0.exe', 'firefox-installer.exe') }"
  firefox-installer.exe /S
) else (
  echo Firefox is already installed. Skipping installation.
)

echo Installation complete.
