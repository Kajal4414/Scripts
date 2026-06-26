# Replace these variables with your actual GitHub repository details and access token
GITHUB_TOKEN="your_personal_access_token"
REPO_OWNER="your_username_or_organization"
REPO_NAME="your_repository_name"

# Get all workflow runs
curl -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runs \
| jq '.workflow_runs[] | .id' \
| while read run_id; do
    # Delete each workflow run by ID
    curl -X DELETE -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id
  done
