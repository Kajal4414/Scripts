@echo off

:: Delete directories requiring 'takeown' and 'icacls' commands.
for %%D in (
    "%ProgramFiles%\ModifiableWindowsApps"
    "%Public%\Desktop"
    "%WinDir%\SoftwareDistribution\Download"
    "%WinDir%\SoftwareDistribution\PostRebootEventCache.V2"
    "%WinDir%\temp"
    ) do (
    if exist "%%~D" (
        echo Deleting the "%%~D" directory...
        takeown /F "%%~D" /A >NUL 2>&1 & icacls "%%~D" /grant Administrators:F >NUL 2>&1
        RD /S /Q "%%~D"
    )
)

:: Delete other directories.
for %%D in (
    "%AppData%\DMCache"
    "%UserProfile%\.android"
    "%UserProfile%\.dbus-keyrings"
    "%UserProfile%\.vscode\cli"
    "%UserProfile%\AppData\Local\Temp"
    "%UserProfile%\AppData\Local\D3DSCache"
    "%UserProfile%\AppData\Local\npm-cache"
    "%UserProfile%\AppData\Local\PeerDistRepub"
    "%UserProfile%\AppData\Local\pylint"
    "%UserProfile%\AppData\Local\VirtualStore"
    "%UserProfile%\AppData\LocalLow\AMD"
    "%UserProfile%\AppData\Roaming\Adobe"
    "%UserProfile%\Favorites"
    "%UserProfile%\Recent"
    "%UserProfile%\Searches"
    "%UserProfile%\Saved Games"
    "%UserProfile%\Videos\Captures"
    "%WinDir%\AppReadiness"
    "%WinDir%\Prefetch"
    ) do (
    if exist "%%~D" (
        echo Deleting the "%%~D" directory...
        RD /S /Q "%%~D" 2>NUL
    )
)

echo.
echo Press any key to exit...
pause >NUL