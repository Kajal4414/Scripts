import os
import re
import sys
import requests
from urllib.parse import urlparse
from colorama import Fore, Style

DEFAULT_URL = "https://starzone.ragalahari.com/feb2022/hd/aakanksha-singh-clap-press-meet/aakanksha-singh-clap-press-meet1.jpg"
DEFAULT_NUM_IMAGES = 2
HEAVY_S = "━" * 150
CHUNK_SIZE = 1024
TIMEOUT = 5

# Function to check internet connectivity
def check_internet():
    try:
        requests.get("http://www.google.com", timeout=TIMEOUT)
        return True
    except requests.exceptions.RequestException:
        return False

if not check_internet():
    print(f"{Fore.RED}No internet connection{Style.RESET_ALL}")
    sys.exit(1)

# Input for the image URL
url_prompt = f"{Fore.YELLOW}Enter the full URL of the first image {Style.RESET_ALL}{Fore.GREEN}(Press enter for default: {DEFAULT_URL}): {Style.RESET_ALL}"
full_url = input(url_prompt) or DEFAULT_URL

# Validate the image URL
if not (full_url.startswith("https://") and (full_url.lower().endswith(".jpg") or full_url.lower().endswith(".png"))):
    print(f"{Fore.RED}Invalid or unsupported image URL{Style.RESET_ALL}")
    sys.exit(1)

# Input for the number of images to download
num_images_prompt = f"{Fore.YELLOW}How many images would you like to download? {Style.RESET_ALL}{Fore.GREEN}(Press enter for default: {DEFAULT_NUM_IMAGES}, 'A' for all): {Style.RESET_ALL}"
num_images_input = input(num_images_prompt).strip()

# Set the number of images to download
if num_images_input.lower() == "a":
    num_images = float("inf")
else:
    num_images_str = num_images_input or str(DEFAULT_NUM_IMAGES)
    if not num_images_str.isdigit() or int(num_images_str) <= 0:
        print(f"{Fore.RED}Invalid number of images{Style.RESET_ALL}")
        sys.exit(1)
    num_images = int(num_images_str)

# Display selected options
print()
print(HEAVY_S)
print(f"{Fore.YELLOW}Image URL: {Style.RESET_ALL}{Fore.GREEN}{full_url}{Style.RESET_ALL}")
num_images_display = "All" if num_images_input.lower() == "a" else num_images
print(f"{Fore.YELLOW}Number of images to download: {Style.RESET_ALL}{Fore.GREEN}{num_images_display}{Style.RESET_ALL}")
print()
print(HEAVY_S)

# Parse URL and extract necessary information
parsed_url = urlparse(full_url)
site_url = f"{parsed_url.scheme}://{parsed_url.netloc}{os.path.dirname(parsed_url.path)}/"
folder_name = re.sub(r"\d*$", "", os.path.splitext(os.path.basename(parsed_url.path))[0]).replace("-", " ").title()
file_name_match = re.search(r"(\d+)\.(jpg|png)$", full_url)

if file_name_match:
    file_number = int(file_name_match.group(1))
    file_extension = file_name_match.group(2)
    file_name = os.path.splitext(os.path.basename(full_url))[0][:-len(str(file_number))]
else:
    print(f"{Fore.RED}Couldn't extract image number from URL{Style.RESET_ALL}")
    sys.exit(1)

# Download the images
NUM_DOWNLOADED = TOTAL_SIZE = 0
i = 1

try:
    while i <= num_images:
        file_name_format = f"{file_name}{file_number + i - 1}.{file_extension}"
        file_path = os.path.join(folder_name, file_name_format)

        # Create folder if it doesn't exist
        if not os.path.exists(folder_name):
            os.makedirs(folder_name)
            print(f"{Fore.GREEN}Folder '{folder_name}' created{Style.RESET_ALL}")
            print()

        # Skip if image already exists
        if os.path.exists(file_path):
            print(f"{file_name_format}{Fore.YELLOW} - already exists. Skipping...{Style.RESET_ALL}")
            i += 1
            continue

        # Get the file URL and start downloading
        file_url = f"{site_url}{file_name_format}"
        try:
            with requests.get(file_url, stream=True, timeout=TIMEOUT) as response:
                if response.status_code == 404:
                    print(f"{Fore.YELLOW}No more images available. Stopping download.{Style.RESET_ALL}")
                    break

                response.raise_for_status()
                file_size = int(response.headers.get("content-length") or 0)

                if file_size == 0:
                    print(f"{file_name_format}{Fore.RED} - Unable to get file size. Skipping...{Style.RESET_ALL}")
                    continue

                # Download the file
                DOWNLOAD_SIZE = 0
                with open(file_path, "wb") as file:
                    for chunk in response.iter_content(chunk_size=CHUNK_SIZE):
                        if chunk:
                            file.write(chunk)
                            DOWNLOAD_SIZE += len(chunk)
                            TOTAL_SIZE += len(chunk)
                            percent = min(int((DOWNLOAD_SIZE / file_size) * 100), 100)
                            print(f"{file_name_format}{Fore.GREEN} - Downloaded {percent}%{Style.RESET_ALL}", end="\r")

                print()
                NUM_DOWNLOADED += 1
                i += 1
        except requests.exceptions.RequestException:
            print(f"{file_name_format}{Fore.RED} - Not Found for URL: {file_url}{Style.RESET_ALL}")
            break

    # Display download information
    print()
    if num_images_input.lower() == "a":
        download_info = f"All images of '{folder_name}'"
    else:
        download_info = f"{NUM_DOWNLOADED} out of {num_images} images"

    print(f"{Fore.BLUE}Downloaded {download_info} at '{os.path.abspath(folder_name)}' - Total downloaded size: {TOTAL_SIZE/CHUNK_SIZE/CHUNK_SIZE:.2f} MB{Style.RESET_ALL}")

except KeyboardInterrupt:
    print()
    print(f"\n{Fore.RED}Download interrupted by user{Style.RESET_ALL}")
