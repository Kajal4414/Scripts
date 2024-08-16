# Replace these variables with your actual GitHub repository details and access token
GITHUB_TOKEN="your_personal_access_token"
REPO_OWNER="your_username_or_organization"
REPO_NAME="your_repository_name"

# Get all tags
curl -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/git/refs/tags |
    jq '.[] | .ref' |
    while read tag_ref; do
        # Extract tag name
        tag_name=$(echo "$tag_ref" | awk -F '/' '{print $3}' | tr -d '"')
        # Delete each tag
        curl -X DELETE -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/git/refs/tags/$tag_name
    done
