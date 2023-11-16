@echo off

:: Delete ModifiableWindowsApps directory with 'takeown' and 'icacls' commands.
if exist "%ProgramFiles%\ModifiableWindowsApps" (
	whoami /user | find /i "S-1-5-18" >NUL 2>&1 || (
	call RunAsTI.cmd "%~f0" %*
	exit /b
	)
    echo Deleting the "%ProgramFiles%\ModifiableWindowsApps" directory...
    takeown /F "%ProgramFiles%\ModifiableWindowsApps" /R /D Y >NUL 2>&1
    icacls "%ProgramFiles%\ModifiableWindowsApps" /grant administrators:F /T >NUL 2>&1
    RD /S /Q "%ProgramFiles%\ModifiableWindowsApps"
    echo.
)

:: Delete other directories ($ rmdir "C:\Windows\temp\*").
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
	:: Add more if statements for additional directories as needed.
    if exist %%D (
        echo Deleting the "%%~D" directory...
        RD /S /Q "%%~D" 2>NUL
        echo.
        echo.
    )
)

echo Press any key to exit...
pause >NUL
