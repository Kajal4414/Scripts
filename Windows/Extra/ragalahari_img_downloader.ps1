function Get-NumberOfImages($totalImages) {
    do {
        $userInput = Read-Host "Enter the number of images to download (Press Enter for all '$totalImages')"
        if (-not $userInput) { return $totalImages }
        $inputAsInt = $userInput -as [int]
        if ($inputAsInt -and $inputAsInt -gt 0 -and $inputAsInt -le $totalImages) { return $inputAsInt }
        Write-Host "Enter a valid number between 1 and $totalImages." -ForegroundColor Red
    } while ($true)
}

function DownloadImage($url, $destinationFolder) {
    $fileName = [System.IO.Path]::GetFileName($url)
    $filePath = Join-Path $destinationFolder $fileName
    if (-not (Test-Path -Path $filePath)) {
        Write-Host "Downloading '$fileName'..."
        Invoke-WebRequest -Uri $url -OutFile $filePath -ErrorAction Stop
        return "downloaded"
    } else {
        Write-Host "'$fileName' already exists." -ForegroundColor Yellow
        return "skipped"
    }
}

do {
    $userUrl = Read-Host "Enter the gallery URL (Press Enter for default)"
    $userUrl = if ([string]::IsNullOrWhiteSpace($userUrl)) { "https://www.ragalahari.com/actor/171464/allu-arjun-at-honer-richmont-launch.aspx" } else { $userUrl }
    $isValidUrl = $userUrl -match '\.aspx$'
    if (-not $isValidUrl) { Write-Host "Invalid URL. Please enter a valid gallery URL." -ForegroundColor Red }
} while (-not $isValidUrl)

$response = Invoke-RestMethod -Uri $userUrl -ErrorAction Stop
$imageUrls = [regex]::Matches($response, '(?<=src=")[^"]*t\.jpg') | ForEach-Object { $_.Value -replace 't\.jpg$', '.jpg' }
$totalImages = $imageUrls.Count
$numberOfImages = Get-NumberOfImages $totalImages

$destinationFolder = Read-Host "Enter the destination folder name"
if (-not (Test-Path -Path $destinationFolder)) { New-Item -ItemType Directory -Path $destinationFolder -Force | Out-Null }

$downloadedCount = 0
$skippedCount = 0

foreach ($imageUrl in $imageUrls[0..($numberOfImages - 1)]) {
    $status = DownloadImage $imageUrl $destinationFolder
    if ($status -eq "downloaded") { $downloadedCount++ }
    if ($status -eq "skipped") { $skippedCount++ }
}

Write-Host "`nAll images downloaded at '$(Resolve-Path -Path $destinationFolder)', Total downloaded: $downloadedCount, Total skipped: $skippedCount" -ForegroundColor Green
