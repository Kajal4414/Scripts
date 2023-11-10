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
	rmdir /S /Q "%userprofile%\AppData\Local\Temp"
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

if exist "%userprofile%\Favorites" (
    echo Deleting the Favorites directory...
    rmdir /S /Q "%userprofile%\Favorites"
    pause
)

if exist "%windir%\AppReadiness" (
    echo Deleting the AppReadiness directory...
    rmdir /S /Q "%windir%\AppReadiness"
    pause
)

if exist "%windir%\temp" (
    echo Deleting the temp directory...
    rmdir /S /Q "%windir%\temp"
    pause
)

if exist "%windir%\Prefetch" (
    echo Deleting the Prefetch directory...
    rmdir /S /Q "%windir%\Prefetch"
    pause
)

echo The script is finished.
pause
