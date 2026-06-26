#!/bin/bash

# Replace these variables with your actual GitHub repository details and access token
GITHUB_TOKEN="your_personal_access_token"
REPO_OWNER="your_username_or_organization"
REPO_NAME="your_repository_name"

# Get all releases
curl -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases |
    jq '.[] | .id' |
    while read release_id; do
        # Delete each release
        curl -X DELETE -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/$release_id
    done
