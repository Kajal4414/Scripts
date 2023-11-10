@echo off

if exist "%ProgramFiles%\ModifiableWindowsApps" (
    echo Deleting the ModifiableWindowsApps directory...
    takeown /F "%ProgramFiles%\ModifiableWindowsApps" /R /D Y
    icacls "%ProgramFiles%\ModifiableWindowsApps" /grant administrators:F /T
    rmdir /S /Q "%ProgramFiles%\ModifiableWindowsApps"
    pause
)

if exist "%UserProfile%\AppData\Local\Temp" (
    echo Deleting the AppData\Local\Temp directory...
    rmdir /S /Q "%UserProfile%\AppData\Local\Temp"
    pause
)

if exist "%UserProfile%\Recent" (
    echo Deleting the Recent directory...
    rmdir /S /Q "%UserProfile%\Recent"
    pause
)

if exist "%UserProfile%\Searches" (
    echo Deleting the Searches directory...
    rmdir /S /Q "%UserProfile%\Searches"
    pause
)

if exist "%UserProfile%\Favorites" (
    echo Deleting the Favorites directory...
    rmdir /S /Q "%UserProfile%\Favorites"
    pause
)

if exist "%Public%\Desktop" (
    echo Deleting the Desktop directory...
    rmdir /S /Q "%Public%\Desktop"
    pause
)

if exist "%WinDir%\AppReadiness" (
    echo Deleting the AppReadiness directory...
    rmdir /S /Q "%WinDir%\AppReadiness"
    pause
)

if exist "%WinDir%\temp" (
    echo Deleting the temp directory...
    rmdir /S /Q "%WinDir%\temp"
    pause
)

if exist "%WinDir%\Prefetch" (
    echo Deleting the Prefetch directory...
    rmdir /S /Q "%WinDir%\Prefetch"
    pause
)

echo The script is finished.
pause
