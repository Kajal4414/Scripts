# Define variables
$platformToolsUrl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
$platformToolsPath = "$env:PROGRAMFILES\Android\platform-tools"
$zipFilePath = "$env:TEMP\platform-tools.zip"

# Check for administrator privileges
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "`n[ERROR] Administrator Privileges Are Required To Run This Script." -ForegroundColor Red
    exit
}

# Fetch remote version from the webpage
try {
    Write-Host "`n[INFO] Fetching Remote Platform Tools Version..." -ForegroundColor Yellow
    $webContent = Invoke-WebRequest -Uri https://developer.android.com/tools/releases/platform-tools -UseBasicParsing
    $null = $webContent.Content -match '<h4 id=".*?" data-text="(\d+\.\d+\.\d+)'; $remoteVersion = $Matches[1]
}
catch {
    Write-Host "[ERROR] Failed To Fetch Remote Version. $_" -ForegroundColor Red
    exit
}

# Check for internet connection
if (-not (Test-Connection 8.8.8.8 -Count 1 -Quiet)) {
    Write-Host "`n[ERROR] Internet Connection Required." -ForegroundColor Red
    exit
}

# Check if adb is already installed
if (Get-Command "adb" -ErrorAction SilentlyContinue) {
    $localVersion = (adb --version | Select-String -Pattern "Version (\d+\.\d+\.\d+)-\d+" -AllMatches).Matches[0].Groups[1].Value
    if ($localVersion -eq $remoteVersion) {
        Write-Host "`n[INFO] ADB v$remoteVersion Is Already Installed And Up-To-Date.`n" -ForegroundColor Yellow
        exit
    }
    Write-Host "`n[INFO] ADB v$localVersion Is Installed. Updating To v$remoteVersion...`n" -ForegroundColor Yellow
}

# Download the file
try {
    Write-Host "`n[INFO] Downloading Platform Tools From '$platformToolsUrl' To '$zipFilePath'..." -ForegroundColor Yellow
    curl.exe -L $platformToolsUrl -o $zipFilePath
    Write-Host "[SUCCESS] Download Completed Successfully." -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Failed To Download The File. $_" -ForegroundColor Red
    exit
}

# Extract the ZIP file
try {
    Write-Host "`n[INFO] Extracting Platform Tools Archive To '$platformToolsPath'..." -ForegroundColor Yellow
    Expand-Archive -Path $zipFilePath -DestinationPath "$env:PROGRAMFILES\Android" -Force
    Write-Host "[SUCCESS] Extraction Completed Successfully." -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Failed To Extract: $_" -ForegroundColor Red
    exit
}

# Add the folder to the system PATH
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
if (-not ($currentPath -split ';' -contains $platformToolsPath)) {
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$platformToolsPath", [System.EnvironmentVariableTarget]::Machine)
    Write-Host "`n[SUCCESS] Platform Tools Successfully Added To The System Environment Variables" -ForegroundColor Green
}

# Cleanup
Remove-Item -Path $zipFilePath -ErrorAction SilentlyContinue

Write-Host "`n[INFO] Platform Tools Installed/Updated Successfully To Version $remoteVersion!" -ForegroundColor Green
