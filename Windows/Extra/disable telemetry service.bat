@echo off

REM Delete instances of Macromedia Flash (Old and unsecure software, no longer supported)
takeown /F c:\windows\system32\macromed /A /R /D Y
icacls c:\windows\system32\macromed /grant Administrators:F /T /C
rmdir /S /Q c:\windows\system32\macromed

takeown /F c:\windows\syswow64\macromed /A /R /D Y
icacls c:\windows\syswow64\macromed /grant Administrators:F /T /C
rmdir /S /Q c:\windows\syswow64\macromed

del c:\windows\syswow64\flashplayer*.*

REM Disable tunneling protocols (To improve network security by disabling unused tunneling protocols)
netsh int teredo set state disabled
netsh int 6to4 set state disabled
netsh int isatap set state disabled

REM Set service dependency for BITS (To ensure BITS service only starts when network profile manager service is running)
sc config BITS depend=netprofm

REM Add Recycle Bin to My Computer (Convenience for accessing Recycle Bin directly from My Computer)
reg add "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{645FF040-5081-101B-9F08-00AA002F954E}"

REM Disable negative DNS cache (Improve network performance by avoiding storing negative DNS responses)
reg add "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Dnscache\\Parameters" /v MaxNegativeCacheTtl /t REG_DWORD /d 0 /f

REM Disable Desktop icon label shadow (For better visual performance, especially on older systems)
reg add "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\VisualEffects\\ListviewShadow" /v DefaultApplied /t REG_DWORD /d 0 /f

REM Add AHCI device initiated sleep options to Power Options for SSDs (Advanced power options for better SSD performance)
reg add "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Power\\PowerSettings\\0012ee47-9041-4b5d-9b77-5b94f2d88b50" /v Attributes /t REG_DWORD /d 2 /f

REM Enable Turbo Boost in Power Options (Allows enabling Turbo Boost for better CPU performance)
reg add "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Power\\PowerSettings\\54533251-82be-4824-96c1-47b60b740d00\\be337238-0d82-41a4-a4b7-d8ed351f75d9" /v Attributes /t REG_DWORD /d 2 /f

REM Remove Git from Context Menus (Cleaner right-click context menus by removing unnecessary options)
reg delete "HKEY_CLASSES_ROOT\\Directory\\shell\\git_gui" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\shell\\git_gui\\command" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\shell\\git_shell" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\shell\\git_shell\\command" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\Background\\shell\\git_shell" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\Background\\shell\\git_shell\\command" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\Background\\shell\\git_gui" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\Background\\shell\\git_gui\\command" /f

REM Remove Powershell from Context Menus (Cleaner right-click context menus by removing unnecessary options)
reg delete "HKEY_CLASSES_ROOT\\Drive\\shell\\Powershell" /f
reg delete "HKEY_CLASSES_ROOT\\Drive\\shell\\Powershell\\command" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\shell\\Powershell" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\shell\\Powershell\\command" /f

REM Remove Command Prompt from Context Menus (Cleaner right-click context menus by removing unnecessary options)
reg delete "HKEY_CLASSES_ROOT\\Directory\\shell\\cmd" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\shell\\cmd\\command" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\Background\\shell\\cmd" /f
reg delete "HKEY_CLASSES_ROOT\\Directory\\Background\\shell\\cmd\\command" /f

REM Block specific shell extensions (To prevent unwanted shell extensions from loading)
reg add "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Shell Extensions\\Blocked" /v "{FDADFEE3-02D1-4E7C-A511-380F4C98D73B}" /t REG_SZ /d "" /f

REM Disable Ndu service (To reduce memory usage, Ndu is related to network data usage tracking)
reg add "HKEY_LOCAL_MACHINE\\SYSTEM\\ControlSet001\\Services\\Ndu" /v Start /t REG_DWORD /d 4 /f

REM Disable hosted network (To ensure the computer is not acting as a wireless access point)
netsh wlan set hostednetwork mode=disallow

echo All commands executed successfully.
pause
