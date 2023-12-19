# Define the URLs for the setup file and the SHA512 hash file
$firefoxSetupUrl = "https://releases.mozilla.org/pub/firefox/releases/120.0.1/win64/en-GB/Firefox%20Setup%20120.0.1.exe"
$hashFileUrl = "https://ftp.mozilla.org/pub/firefox/releases/120.0.1/SHA512SUMS"

# Define the path for the downloaded setup file
$firefoxSetupPath = "$Env:UserProfile\Desktop\Scripts\FirefoxSetup.exe"

# Download the Firefox setup file
Invoke-WebRequest -Uri $firefoxSetupUrl -OutFile $firefoxSetupPath

# Fetch the content of the SHA512 hash file
$hashFileContent = Invoke-RestMethod -Uri $hashFileUrl

# Extract the hash for the setup file from the content
$expectedHash = ($hashFileContent -split "`n" | Select-String -Pattern "win64/en-GB/Firefox Setup 120.0.1.exe").Line.Split(" ")[0].Trim()

# Compute the SHA512 hash of the downloaded setup file
$computedHash = (Get-FileHash -Path $firefoxSetupPath -Algorithm SHA512).Hash

# Compare the computed hash with the expected hash
if ($computedHash -eq $expectedHash) {
    # If the hashes match, output a success message
    Write-Host "Hash matches the expected hash" -ForegroundColor Green
    Write-Host "Computed Hash: " $computedHash -ForegroundColor Yellow
    Write-Host "Expected Hash: " $expectedHash -ForegroundColor Blue
}
else {
    # If the hashes do not match, output an error message
    Write-Host "The downloaded file is corrupted or has been tampered with." -ForegroundColor Red
}
