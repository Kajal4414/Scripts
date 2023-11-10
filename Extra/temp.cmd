takeown /F "%programfiles%\ModifiableWindowsApps" /R /D Y
icacls "%programfiles%\ModifiableWindowsApps" /grant administrators:F /T
rmdir /S /Q "%programfiles%\ModifiableWindowsApps"

rmdir /S "%userprofile%\AppData\Local\Temp"
rmdir /S "%userprofile%\Recent"
rmdir /S "%userprofile%\Searches"
rmdir /S "%windir%\AppRed"
rmdir /S "%windir%\temp"
rmdir /S "%windir%\Prefetch"
exit
