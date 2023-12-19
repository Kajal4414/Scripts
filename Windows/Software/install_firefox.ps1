# Define the URLs for the setup file and the SHA512 hash file
$firefoxSetupUrl = "https://releases.mozilla.org/pub/firefox/releases/120.0.1/win64/en-GB/Firefox%20Setup%20120.0.1.exe"
$hashFileUrl = "https://ftp.mozilla.org/pub/firefox/releases/120.0.1/SHA512SUMS"

# Define the paths for the downloaded files
$firefoxSetupPath = "C:\Users\Deepak\Desktop\Scripts\FirefoxSetup.exe"
$hashFilePath = "C:\Users\Deepak\Desktop\Scripts\SHA512SUMS"

# Download the Firefox setup file
# Invoke-WebRequest -Uri $firefoxSetupUrl -OutFile $firefoxSetupPath

# Download the SHA512 hash file
# Invoke-WebRequest -Uri $hashFileUrl -OutFile $hashFilePath

# Extract the hash for the setup file from the SHA512SUMS file
$expectedHash = (Get-Content $hashFilePath | Select-String -Pattern "win64/en-GB/Firefox Setup 120.0.1.exe" | ForEach-Object { ($_ -split ' ')[0] }).Trim()

# Compute the SHA512 hash of the downloaded setup file
$computedHash = (Get-FileHash -Path $firefoxSetupPath -Algorithm SHA512).Hash

# Compare the computed hash with the expected hash
if ($computedHash -eq $expectedHash) {
    # If the hashes match, output an success message
    Write-Host "Hash matches the expected hash" -ForegroundColor Green
    Write-Host $computedHash -ForegroundColor Yellow
    Write-Host $expectedHash -ForegroundColor Blue
}
else {
    # If the hashes do not match, output an error message
    Write-Host "The downloaded file is corrupted or has been tampered with." -ForegroundColor Red
}
