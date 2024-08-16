#!/bin/bash

# Replace these variables with your actual GitHub repository details and access token
GITHUB_TOKEN="your_personal_access_token"
REPO_OWNER="your_username_or_organization"
REPO_NAME="your_repository_name"

# Function to delete tags
delete_tags() {
    echo "Deleting tags..."
    curl -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/git/refs/tags" |
        jq -r '.[] | .ref' |
        while read -r tag_ref; do
            tag_name=$(echo "$tag_ref" | awk -F '/' '{print $3}' | tr -d '"')
            curl -X DELETE -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
                "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/git/refs/tags/$tag_name"
        done
}

# Function to delete releases
delete_releases() {
    echo "Deleting releases..."
    curl -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases" |
        jq -r '.[] | .id' |
        while read -r release_id; do
            curl -X DELETE -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
                "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/$release_id"
        done
}

# Execute functions
delete_tags
delete_releases
