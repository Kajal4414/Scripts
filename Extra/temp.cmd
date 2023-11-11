@echo off

if exist "%ProgramFiles%\ModifiableWindowsApps" (
    echo Deleting the "%ProgramFiles%\ModifiableWindowsApps" directory...
    takeown /F "%ProgramFiles%\ModifiableWindowsApps" /R /D Y
    icacls "%ProgramFiles%\ModifiableWindowsApps" /grant administrators:F /T
    rmdir /S /Q "%ProgramFiles%\ModifiableWindowsApps"
    echo.
)

if exist "%UserProfile%\AppData\Local\Temp" (
    echo Deleting the "%UserProfile%\AppData\Local\Temp" directory...
    rmdir /S /Q "%UserProfile%\AppData\Local\Temp"
    echo.
)

if exist "%UserProfile%\.vscode\cli" (
    echo Deleting the "%UserProfile%\.vscode\cli" directory...
    rmdir /S /Q "%UserProfile%\.vscode\cli"
    echo.
)

if exist "%UserProfile%\Recent" (
    echo Deleting the "%UserProfile%\Recent" directory...
    rmdir /S /Q "%UserProfile%\Recent"
    echo.
)

if exist "%UserProfile%\Searches" (
    echo Deleting the "%UserProfile%\Searches" directory...
    rmdir /S /Q "%UserProfile%\Searches"
    echo.
)

if exist "%UserProfile%\Favorites" (
    echo Deleting the "%UserProfile%\Favorites" directory...
    rmdir /S /Q "%UserProfile%\Favorites"
    echo.
)

if exist "%UserProfile%\Saved Games" (
    echo Deleting the "%UserProfile%\Saved Games" directory...
    rmdir /S /Q "%UserProfile%\Saved Games"
    echo.
)

if exist "%Public%\Desktop" (
    echo Deleting the "%Public%\Desktop" directory...
    rmdir /S /Q "%Public%\Desktop"
    echo.
)

if exist "%WinDir%\AppReadiness" (
    echo Deleting the "%WinDir%\AppReadiness" directory...
    rmdir /S /Q "%WinDir%\AppReadiness"
    echo.
)

if exist "%WinDir%\temp" (
    echo Deleting the "%WinDir%\temp" directory...
    rmdir /S /Q "%WinDir%\temp"
    echo.
)

if exist "%WinDir%\Prefetch" (
    echo Deleting the "%WinDir%\Prefetch" directory...
    rmdir /S /Q "%WinDir%\Prefetch"
    echo.
)

echo The script is finished.
echo.
pause
