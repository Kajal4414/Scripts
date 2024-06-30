# Replace with your own username and repository name
$USERNAME = 'username'
$REPOSITORY = 'repository_name'

# GitHub API URL
$URL = "https://api.github.com/repos/$USERNAME/$REPOSITORY/releases"

# Fetch releases data
$response = Invoke-RestMethod -Uri $URL

# Parse JSON response and extract release names and download counts
$response | ForEach-Object {
    $release = $_
    $release.name
    $release.assets | ForEach-Object {
        "Release: $($release.name) - Asset: $($_.name) - Downloads: $($_.download_count)"
    }
}
