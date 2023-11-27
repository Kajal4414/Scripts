# Delete directories requiring 'takeown' and 'icacls' commands
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

Write-Host "Exiting in 3 seconds..."
Start-Sleep -Seconds 3
