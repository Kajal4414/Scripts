param (
    [string]$lang = "en-GB"
)

# Define the URLs for the setup file and the SHA512 hash file
$firefoxSetupUrl = "https://releases.mozilla.org/pub/firefox/releases/120.0.1/win64/$lang/Firefox%20Setup%20120.0.1.exe"
$hashFileUrl = "https://ftp.mozilla.org/pub/firefox/releases/120.0.1/SHA512SUMS"

# Define the path for the downloaded setup file
$firefoxSetupPath = "$Env:UserProfile\Desktop\Scripts\FirefoxSetup.exe"

# Download the Firefox setup file
Invoke-WebRequest -Uri $firefoxSetupUrl -OutFile $firefoxSetupPath

# Fetch the content of the SHA512 hash file
$hashFileContent = Invoke-RestMethod -Uri $hashFileUrl

# Extract the hash for the setup file from the content
$remoteSHA512 = ($hashFileContent -split "`n" | Select-String -Pattern "win64/$lang/Firefox Setup 120.0.1.exe").Line.Split(" ")[0].Trim()

# Compute the SHA512 hash of the downloaded setup file
$localSHA512 = (Get-FileHash -Path $firefoxSetupPath -Algorithm SHA512).Hash

# Compare the computed hash with the expected hash
if ($localSHA512 -eq $remoteSHA512) {
    # If the hashes match, output a success message
    Write-Host "Hash matches the expected hash" -ForegroundColor Green
    Write-Host "Local Hash: " $localSHA512 -ForegroundColor Yellow
    Write-Host "Remote Hash: " $remoteSHA512 -ForegroundColor Blue
}
else {
    # If the hashes do not match, output an error message
    Write-Host "The downloaded file is corrupted or has been tampered with." -ForegroundColor Red
}
