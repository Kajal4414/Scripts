@echo off

whoami /user | find /i "S-1-5-18" > nul 2>&1 || (
	call RunAsTI.cmd "%~f0" %*
	exit /b
)

:: Uninstall MS Store
powershell -NoP -C "Get-AppxPackage *WindowsStore* | Remove-AppxPackage"

:: Reinstall MS Store
powershell -NoP -C "winget install 9WZDNCRFJBMP"
