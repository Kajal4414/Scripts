@echo off

:: Delete ModifiableWindowsApps directory with 'takeown' and 'icacls' commands.
if exist "%ProgramFiles%\ModifiableWindowsApps" (
    echo Deleting the "%ProgramFiles%\ModifiableWindowsApps" directory...
    takeown /F "%ProgramFiles%\ModifiableWindowsApps" /A >NUL 2>&1 & icacls "%ProgramFiles%\ModifiableWindowsApps" /grant Administrators:F >NUL 2>&1
    RD /S /Q "%ProgramFiles%\ModifiableWindowsApps"
    echo.
)

:: Delete other directories.
for %%D in (
    "%UserProfile%\.android"
    "%UserProfile%\.dbus-keyrings"
    "%UserProfile%\.vscode\cli"
    "%UserProfile%\AppData\Local\Temp"
    "%UserProfile%\Favorites"
    "%UserProfile%\Recent"
    "%UserProfile%\Searches"
    "%UserProfile%\Saved Games"
    "%UserProfile%\Videos\Captures"
    "%Public%\Desktop"
    "%WinDir%\AppReadiness"
    "%WinDir%\Prefetch"
    "%WinDir%\temp"
    ) do (
    if exist "%%~D" (
        echo Deleting the "%%~D" directory...
        RD /S /Q "%%~D" 2>NUL
        echo.
    )
)

echo Press any key to exit...
pause >NUL