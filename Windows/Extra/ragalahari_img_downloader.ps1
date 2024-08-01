function Get-NumberOfImages($totalImages) {
    do {
        $userInput = Read-Host "Enter the number of images to download (Press Enter for all '$totalImages')"; Write-Host
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
        Write-Host -NoNewline "$fileName - Downloading..." -ForegroundColor Blue
        $ProgressPreference = 'SilentlyContinue'
        try {
            Invoke-WebRequest -Uri $url -OutFile $filePath -ErrorAction Stop
            Write-Host "`r$fileName - Downloaded.   " -ForegroundColor Green
            return "downloaded"
        } catch {
            Write-Host "`r$fileName - Failed.       " -ForegroundColor Red
            return "failed"
        }
    } else {
        Write-Host "$fileName - Skipped." -ForegroundColor Yellow
        return "skipped"
    }
}

function Get-FolderNameFromUrl($url) {
    $folderName = $url -replace '.*/([^/]+)\.aspx$', '$1' -replace '-', ' '
    return (Get-Culture).TextInfo.ToTitleCase($folderName.ToLower())
}

do {
    $userUrl = Read-Host "Enter the gallery URL (Press Enter for default)"
    $userUrl = if ([string]::IsNullOrWhiteSpace($userUrl)) { "https://www.ragalahari.com/actress/173348/pragati-srivastava-at-gam-gam-ganesha-pre-release-event-hd-gallery.aspx" } else { $userUrl }
    $isValidUrl = $userUrl -match '\.aspx$'
    if (-not $isValidUrl) { Write-Host "Invalid URL. Please enter a valid gallery URL." -ForegroundColor Red }
} while (-not $isValidUrl)

$response = Invoke-RestMethod -Uri $userUrl -ErrorAction Stop
$imageUrls = [regex]::Matches($response, '(?<=src=")[^"]*t\.jpg') | ForEach-Object { $_.Value -replace 't\.jpg$', '.jpg' }
$totalImages = $imageUrls.Count
$numberOfImages = Get-NumberOfImages $totalImages

$destinationFolder = Get-FolderNameFromUrl $userUrl
if (-not (Test-Path -Path $destinationFolder)) { New-Item -ItemType Directory -Path $destinationFolder -Force | Out-Null; Write-Host "$destinationFolder - Folder Created." -ForegroundColor Green; Write-Host }

$downloadedCount = 0
$skippedCount = 0
$failedCount = 0

foreach ($imageUrl in $imageUrls[0..($numberOfImages - 1)]) {
    $status = DownloadImage $imageUrl $destinationFolder
    if ($status -eq "downloaded") { $downloadedCount++ }
    elseif ($status -eq "skipped") { $skippedCount++ }
    elseif ($status -eq "failed") { $failedCount++ }
}

Write-Host "`nImages downloaded at '$(Resolve-Path -Path $destinationFolder)'" -ForegroundColor Cyan -NoNewline
Write-Host "`nDownloaded: $downloadedCount" -ForegroundColor Green -NoNewline
Write-Host " - Skipped: $skippedCount" -ForegroundColor Yellow -NoNewline
Write-Host " - Failed: $failedCount" -ForegroundColor Red
