:: rmdir "C:\Windows\temp\*"
@echo off

:: Check for administrator privileges
net session >NUL 2>&1
if %errorLevel% neq 0 (
    echo Please run the script as an administrator.
    echo.
    echo Press any key to exit...
    pause >NUL
    exit /b
)

:: Delete ModifiableWindowsApps directory with 'takeown' (Take ownership of the directory) and 'icacls' (Grant administrators full control) commands
if exist "%ProgramFiles%\ModifiableWindowsApps" (
    echo Deleting the "%ProgramFiles%\ModifiableWindowsApps" directory...
    takeown /F "%ProgramFiles%\ModifiableWindowsApps" /R /D Y >NUL 2>&1
    icacls "%ProgramFiles%\ModifiableWindowsApps" /grant administrators:F /T >NUL 2>&1
    RD /S /Q "%ProgramFiles%\ModifiableWindowsApps"
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
    "%WinDir%\Prefetch"
) do (
    if exist %%D (
        echo Deleting the "%%~D" directory...
        RD /S /Q "%%~D" 2>NUL
        echo.
        echo.
    )
)

echo Press any key to exit...
pause >NUL
