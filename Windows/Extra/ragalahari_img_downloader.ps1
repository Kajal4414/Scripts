function Get-NumberOfImages($totalImages) {
    while ($true) {
        $userInput = Read-Host "Enter the number of images to download (Press Enter for all '$totalImages')"; Write-Host
        if (-not $userInput) { return $totalImages }
        $inputAsInt = $userInput -as [int]
        if ($inputAsInt -gt 0 -and $inputAsInt -le $totalImages) { return $inputAsInt }
        Write-Host "Enter a valid number between 1 and $totalImages." -ForegroundColor Red
    }
}

function DownloadImage {
    param ([string]$url, [string]$destinationFolder)
    $fileName = [System.IO.Path]::GetFileName($url)
    $filePath = Join-Path $destinationFolder $fileName
    if (-not (Test-Path -Path $filePath -PathType Leaf)) {
        try {
            $ProgressPreference = 'SilentlyContinue'
            Write-Host -NoNewline "$fileName - Downloading..." -ForegroundColor Blue
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

do {
    $defaultUrl = "https://www.ragalahari.com/actor/171464/allu-arjun-at-honer-richmont-launch.aspx"
    $userUrl = Read-Host "Enter the gallery URL (Press Enter for default '$defaultUrl')"
    if ($userUrl -eq "") { $userUrl = $defaultUrl }
    $isValidUrl = [Uri]::TryCreate($userUrl, [UriKind]::Absolute, [ref]$null) -and $userUrl.ToLower().EndsWith(".aspx")
    if (-not $isValidUrl) { Write-Host "`nInvalid URL. Please enter a valid gallery URL." -ForegroundColor Red }
} while (-not $isValidUrl)

$response = try { Invoke-RestMethod -Uri $userUrl -ErrorAction Stop } catch { Write-Host "`nFailed to retrieve the gallery page. Please check the URL and try again." -ForegroundColor Red; exit }
$imageUrls = [regex]::Matches($response, '(?<=src=["''])([^"'']*t\.jpg)') | ForEach-Object { $_.Value -replace 't\.jpg$', '.jpg' }
$numberOfImages = Get-NumberOfImages $imageUrls.Count

$destinationFolder = (Get-Culture).TextInfo.ToTitleCase(($userUrl -replace '.*/([^/]+)\.aspx$', '$1' -replace '-', ' ').ToLower())
if (-not (Test-Path -Path $destinationFolder)) { New-Item -ItemType Directory -Path $destinationFolder -Force | Out-Null; Write-Host "$destinationFolder - Folder Created.`n" -ForegroundColor Green }

$downloadResults = @()
foreach ($imageUrl in $imageUrls[0..($numberOfImages - 1)]) {
    $downloadResults += DownloadImage -url $imageUrl -destinationFolder $destinationFolder
}

$downloadedCount = ($downloadResults | Where-Object { $_ -eq "downloaded" }).Count
$skippedCount = ($downloadResults | Where-Object { $_ -eq "skipped" }).Count
$failedCount = ($downloadResults | Where-Object { $_ -eq "failed" }).Count

Write-Host "`nDownloaded: $downloadedCount" -ForegroundColor Green -NoNewline
Write-Host " - " -NoNewline; Write-Host "Skipped: $skippedCount" -ForegroundColor Yellow -NoNewline
Write-Host " - " -NoNewline; Write-Host "Failed: $failedCount" -ForegroundColor Red
Write-Host "Images downloaded at '$(Resolve-Path -Path $destinationFolder)'" -ForegroundColor Blue
