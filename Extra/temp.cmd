@echo off

if exist "%ProgramFiles%\ModifiableWindowsApps" (
    echo Deleting the "%ProgramFiles%\ModifiableWindowsApps" directory...
    takeown /F "%ProgramFiles%\ModifiableWindowsApps" /R /D Y
    icacls "%ProgramFiles%\ModifiableWindowsApps" /grant administrators:F /T
    rmdir /S /Q "%ProgramFiles%\ModifiableWindowsApps"
    echo.
    pause
)

if exist "%UserProfile%\AppData\Local\Temp" (
    echo Deleting the "%UserProfile%\AppData\Local\Temp" directory...
    rmdir /S /Q "%UserProfile%\AppData\Local\Temp"
    echo.
    pause
)

if exist "%UserProfile%\Recent" (
    echo Deleting the "%UserProfile%\Recent" directory...
    rmdir /S /Q "%UserProfile%\Recent"
    echo.
    pause
)

if exist "%UserProfile%\Searches" (
    echo Deleting the "%UserProfile%\Searches" directory...
    rmdir /S /Q "%UserProfile%\Searches"
    echo.
    pause
)

if exist "%UserProfile%\Favorites" (
    echo Deleting the "%UserProfile%\Favorites" directory...
    rmdir /S /Q "%UserProfile%\Favorites"
    echo.
    pause
)

if exist "%Public%\Desktop" (
    echo Deleting the "%Public%\Desktop" directory...
    rmdir /S /Q "%Public%\Desktop"
    echo.
    pause
)

if exist "%WinDir%\AppReadiness" (
    echo Deleting the "%WinDir%\AppReadiness" directory...
    rmdir /S /Q "%WinDir%\AppReadiness"
    echo.
    pause
)

if exist "%WinDir%\temp" (
    echo Deleting the "%WinDir%\temp" directory...
    rmdir /S /Q "%WinDir%\temp"
    echo.
    pause
)

if exist "%WinDir%\Prefetch" (
    echo Deleting the "%WinDir%\Prefetch" directory...
    rmdir /S /Q "%WinDir%\Prefetch"
    echo.
    pause
)

echo The script is finished.
pause
