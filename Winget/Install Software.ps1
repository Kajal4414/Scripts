@echo off

mkdir "C:\Software"

echo Checking if VLC is already installed...
winget show VideoLAN.VLC >nul 2>&1
if %errorlevel% == 0 (
  echo VLC is already installed. Skipping installation.
) else (
  echo VLC is not installed. Installing...
  winget install VideoLAN.VLC --install-location="C:\Software"
)

echo Checking if Chrome is already installed...
winget show Google.Chrome >nul 2>&1
if %errorlevel% == 0 (
  echo Chrome is already installed. Skipping installation.
) else (
  echo Chrome is not installed. Installing...
  winget install Google.Chrome --install-location="C:\Software"
)

echo Checking if Firefox is already installed...
winget show Mozilla.Firefox >nul 2>&1
if %errorlevel% == 0 (
  echo Firefox is already installed. Skipping installation.
) else (
  echo Firefox is not installed. Installing...
  winget install Mozilla.Firefox --install-location="C:\Software"
)

echo Installation complete.
