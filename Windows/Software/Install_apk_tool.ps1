# Define the ApkTool installation path
$apkToolPath = "$env:PROGRAMFILES\Android\apk-tool"

# Create the ApkTool directory if it doesn't exist
New-Item -Path $apkToolPath -ItemType Directory -Force | Out-Null

# Download ApkTool jar and bat files
$apkToolJarUrl = "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.9.3.jar"
$apkToolBatUrl = "https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/windows/apktool.bat"

curl.exe -L $apkToolJarUrl -o "$apkToolPath\apktool.jar"
curl.exe -LSs $apkToolBatUrl -o "$apkToolPath\apktool.bat"

# Update the PATH environment variable if ApkTool path is not already included
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
if ($currentPath -notcontains $apkToolPath) {
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$apkToolPath", [System.EnvironmentVariableTarget]::Machine)
}
