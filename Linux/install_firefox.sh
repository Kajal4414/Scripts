#!/bin/bash

force=false
skipHashCheck=false
lang="en-GB"
edition=""
version=""

# Function to pause and wait for user input
function pause_null {
    read -p "Press Enter to exit..."
    exit
}

# Check for admin privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Administrator privileges required." >&2
    pause_null
fi

# Main script execution
function main {
    echo "Starting Firefox installation process..." 

    # Attempt to fetch JSON data
    response=$(curl -s "https://product-details.mozilla.org/1.0/firefox_versions.json")
    if [ $? -ne 0 ]; then
        echo "Failed to fetch JSON data: $response" >&2
        pause_null
    fi

    # Determine the version to download based on the specified edition
    remote_version=""
    case $edition in
        "Developer") remote_version=$(echo "$response" | jq -r '.FIREFOX_DEVEDITION') ;;
        "Enterprise") remote_version=$(echo "$response" | jq -r '.FIREFOX_ESR') ;;
        *) remote_version=$(echo "$response" | jq -r '.LATEST_FIREFOX_VERSION') ;;
    esac

    # Use the specified version if provided, otherwise use the determined version
    remote_version=${version:-$remote_version}

    # Define download URL and file paths
    download_url="https://releases.mozilla.org/pub/firefox/releases/$remote_version/win64/$lang/Firefox%20Setup%20$remote_version.exe"
    hash_source="https://ftp.mozilla.org/pub/firefox/releases/$remote_version/SHA512SUMS"
    install_dir="/opt/firefox"
    setup_file="/tmp/Firefox_Setup_$remote_version.exe"

    # Check if the current version is already installed
    if [ -e "$install_dir/firefox.exe" ]; then
        local_version=$(file "$install_dir/firefox.exe" | awk -F'[\t]' '{print $2}')

        if [ "$local_version" = "$remote_version" ]; then
            echo "Mozilla Firefox v$remote_version is already installed."
            
            if [ "$force" = true ]; then
                echo "-force specified, proceeding anyway."
            else
                pause_null
            fi
        fi
    fi

    # Download Firefox setup file
    echo -e "\nDownloading Mozilla Firefox v$remote_version setup..."
    curl -o "$setup_file" -sS "$download_url"
    echo "Downloading successful."

    # Verify hash if not skipping hash check
    if [ "$skipHashCheck" = false ]; then
        echo -e "\nVerifying SHA-512 Hash..."
        local_sha512=$(sha512sum "$setup_file" | awk '{print $1}')
        remote_sha512=$(curl -s "$hash_source" | grep "win64/$lang/Firefox Setup $remote_version.exe" | awk '{print $1}')

        if [ "$local_sha512" = "$remote_sha512" ]; then
            echo "SHA-512 Hash verification successful."
        else
            echo "SHA-512 Hash verification failed, consider using -skipHashCheck."
            pause_null
        fi
    fi

    # Installation process
    echo -e "\nInstalling Mozilla Firefox..."
    sudo pkill firefox # Stop Firefox processes
    sudo rm -rf "$install_dir" # Remove existing installation

    sudo mkdir -p "$install_dir"
    sudo cp "$setup_file" "$install_dir"
    sudo chmod +x "$install_dir/Firefox_Setup_$remote_version.exe"
    sudo "$install_dir/Firefox_Setup_$remote_version.exe" "/S /MaintenanceService=false"

    if [ $? -eq 0 ]; then
        echo "Installation successful."
    else
        echo "Error occurred while installing 'Mozilla Firefox $remote_version.exe'."
        pause_null
    fi

    # Remove unnecessary files
    echo -e "\nRemoving unnecessary files..."
    sudo rm -f "$setup_file"
    
    # Configuration settings
    echo -e "\nConfiguring Mozilla Firefox settings..."

    # Create 'distribution' folder for policies.json
    sudo mkdir -p "$install_dir/distribution"
    
    # Write policies.json
    curl -o "$install_dir/distribution/policies.json" -sS "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/policies.json"

    # Write autoconfig.js
    curl -o "$install_dir/defaults/pref/autoconfig.js" -sS "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/autoconfig.js"

    # Write firefox.cfg
    curl -o "$install_dir/firefox.cfg" -sS "https://github.com/sakshiagrwal/Scripts/raw/main/Windows/Extra/firefox.cfg"

    echo "Created: policies.json"
    echo "Created: autoconfig.js"
    echo "Created: firefox.cfg"

    # Display release notes URL
    echo -e "\nRelease notes: https://www.mozilla.org/en-US/firefox/$remote_version/releasenotes"
    return 0
}

main
