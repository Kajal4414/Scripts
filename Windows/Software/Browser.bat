downloadUrl=https://dl.google.com/chrome/install/latest/chrome_installer.exe
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%downloadUrl%', 'installer.exe')"

start /wait installer.exe
rd /s /q installer.exe

taskkill /f /im "GoogleUpdate.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateSetup.exe" >nul 2>&1
taskkill /f /im "GoogleCrashHandler.exe" >nul 2>&1
taskkill /f /im "GoogleCrashHandler64.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateBroker.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateCore.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateOnDemand.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateComRegisterShell64.exe" >nul 2>&1

sc delete gupdate >nul 2>&1
sc delete gupdatem >nul 2>&1
sc delete googlechromeelevationservice >nul 2>&1

rmdir /s /q "C:\Program Files (x86)\Google\Update" >nul 2>&1
rmdir /s /q "C:\Program Files\Google\GoogleUpdater" >nul 2>&1
