# Function to invoke Disk Cleanup based on predefined registry settings
function Invoke-DiskCleanup {
    # Stop existing Disk Cleanup process if running
    Get-Process -Name cleanmgr -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    # Define registry settings
    $baseKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'
    $regValues = @{
        "Active Setup Temp Folders"             = 2
        "BranchCache"                           = 2
        "D3D Shader Cache"                      = 0
        "Delivery Optimization Files"           = 2
        "Diagnostic Data Viewer database files" = 2
        "Downloaded Program Files"              = 2
        "Internet Cache Files"                  = 2
        "Language Pack"                         = 0
        "Old ChkDsk Files"                      = 2
        "Recycle Bin"                           = 0
        "RetailDemo Offline Content"            = 2
        "Setup Log Files"                       = 2
        "System error memory dump files"        = 2
        "System error minidump files"           = 2
        "Temporary Files"                       = 0
        "Thumbnail Cache"                       = 2
        "Update Cleanup"                        = 2
        "User file versions"                    = 2
        "Windows Error Reporting Files"         = 2
        "Windows Defender"                      = 2
        "Temporary Sync Files"                  = 2
        "Device Driver Packages"                = 2
    }

    # Set registry settings for Disk Cleanup
    foreach ($entry in $regValues.GetEnumerator()) {
        Set-ItemProperty -Path "$baseKey\$($entry.Key)" -Name 'StateFlags0064' -Value $entry.Value -Type DWORD
    }

    # Start Disk Cleanup with predefined settings
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:64" -Wait
}

# Invoke Disk Cleanup
Invoke-DiskCleanup

# Delete directories with administrator privileges
$directories = @(
    "$Env:ProgramFiles\ModifiableWindowsApps",
    "$Env:Public\Desktop",
    "$Env:WinDir\SoftwareDistribution\Download",
    "$Env:WinDir\SoftwareDistribution\PostRebootEventCache.V2",
    "$Env:WinDir\temp"
)

foreach ($dir in $directories) {
    if (Test-Path $dir) {
        Write-Host "Deleting the $dir directory..."
        Take-Ownership -Path $dir | Out-Null
        icacls $dir /grant Administrators:F | Out-Null
        Remove-Item $dir -Recurse -Force
    }
}

# Delete other directories
$otherDirectories = @(
    "$Env:AppData\DMCache",
    "$Env:UserProfile\.android",
    "$Env:UserProfile\.dbus-keyrings",
    "$Env:UserProfile\.vscode\cli",
    "$Env:UserProfile\AppData\Local\Temp",
    "$Env:UserProfile\AppData\Local\D3DSCache",
    "$Env:UserProfile\AppData\Local\fontconfig",
    "$Env:UserProfile\AppData\Local\npm-cache",
    "$Env:UserProfile\AppData\Local\PeerDistRepub",
    "$Env:UserProfile\AppData\Local\pip",
    "$Env:UserProfile\AppData\Local\pylint",
    "$Env:UserProfile\AppData\Local\VirtualStore",
    "$Env:UserProfile\AppData\LocalLow\AMD",
    "$Env:UserProfile\AppData\Roaming\Adobe",
    "$Env:UserProfile\Favorites",
    "$Env:UserProfile\Recent",
    "$Env:UserProfile\Searches",
    "$Env:UserProfile\Saved Games",
    "$Env:UserProfile\Videos\Captures",
    "$Env:WinDir\AppReadiness",
    "$Env:WinDir\Prefetch"
)

foreach ($otherDir in $otherDirectories) {
    if (Test-Path $otherDir) {
        Write-Host "Deleting the $otherDir directory..."
        Remove-Item $otherDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "Exiting in 3 seconds..."
Start-Sleep -Seconds 3
