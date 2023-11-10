@echo off

if exist "%programfiles%\ModifiableWindowsApps" (
    echo Deleting the ModifiableWindowsApps directory...
    takeown /F "%programfiles%\ModifiableWindowsApps" /R /D Y
	  icacls "%programfiles%\ModifiableWindowsApps" /grant administrators:F /T
    rmdir /S /Q "%programfiles%\ModifiableWindowsApps"
    pause
)

if exist "%userprofile%\AppData\Local\Temp" (
    echo Deleting the AppData\Local\Temp directory...
    rmdir /S "%userprofile%\AppData\Local\Temp"
    pause
)

if exist "%userprofile%\Recent" (
    echo Deleting the Recent directory...
    rmdir /S /Q "%userprofile%\Recent"
    pause
)

if exist "%userprofile%\Searches" (
    echo Deleting the Searches directory...
    rmdir /S /Q "%userprofile%\Searches"
    pause
)

if exist "%windir%\AppRed" (
    echo Deleting the AppRed directory...
    rmdir /S "%windir%\AppRed"
    pause
)

if exist "%windir%\temp" (
    echo Deleting the temp directory...
    rmdir /S "%windir%\temp"
    pause
)

if exist "%windir%\Prefetch" (
    echo Deleting the Prefetch directory...
    rmdir /S "%windir%\Prefetch"
    pause
)

echo The script is finished.
pause
