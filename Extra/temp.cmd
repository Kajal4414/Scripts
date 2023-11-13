@echo off

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrator privileges confirmed.
) else (
    echo Please run the script as an administrator.
    pause
    exit /b
)

echo Starting cleanup script...

:: Delete ModifiableWindowsApps directory with takeown and icacls commands
if exist "%ProgramFiles%\ModifiableWindowsApps" (
    echo Deleting the "%ProgramFiles%\ModifiableWindowsApps" directory...
    
    :: Take ownership of the directory
    takeown /F "%ProgramFiles%\ModifiableWindowsApps" /R /D Y >NUL 2>&1
    
    :: Grant administrators full control
    icacls "%ProgramFiles%\ModifiableWindowsApps" /grant administrators:F /T >NUL 2>&1
    
    :: Remove the directory
    rmdir /S /Q "%ProgramFiles%\ModifiableWindowsApps"
    echo.
)

:: Delete other directories
:: Add more if statements for additional directories as needed
for %%D in (
    "%UserProfile%\AppData\Local\Temp"
    "%UserProfile%\.vscode\cli"
    "%UserProfile%\Recent"
    "%UserProfile%\Searches"
    "%UserProfile%\Favorites"
    "%UserProfile%\Saved Games"
    "%Public%\Desktop"
    "%WinDir%\AppReadiness"
    "%WinDir%\temp"
    "%WinDir%\Prefetch"
) do (
    if exist %%D (
        echo Deleting the "%%~D" directory...
        RD /S /Q "%%~D"
        echo.
    )
)

echo The script has completed successfully.
echo.
pause
