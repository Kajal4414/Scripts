import os
import re
import requests

def get_number_of_images(total_images):
    while True:
        user_input = input(f"Enter the number of images to download (Press Enter for all '{total_images}'): ")
        if not user_input:
            return total_images
        try:
            input_as_int = int(user_input)
            if 0 < input_as_int <= total_images:
                return input_as_int
            else:
                print(f"Enter a valid number between 1 and {total_images}.")
        except ValueError:
            print("Enter a valid integer.")

def download_image(url, destination_folder):
    file_name = os.path.basename(url)
    file_path = os.path.join(destination_folder, file_name)
    if not os.path.exists(file_path):
        print(f"Downloading '{file_name}'...")
        response = requests.get(url)
        with open(file_path, 'wb') as f:
            f.write(response.content)
        return "downloaded"
    else:
        print(f"'{file_name}' already exists.")
        return "skipped"

user_url = input("Enter the gallery URL (Press Enter for default): ")
user_url = user_url if user_url.strip() else "https://www.ragalahari.com/actor/171464/allu-arjun-at-honer-richmont-launch.aspx"
is_valid_url = re.search(r'\.aspx$', user_url)
while not is_valid_url:
    print("Invalid URL. Please enter a valid gallery URL.")
    user_url = input("Enter the gallery URL (Press Enter for default): ")
    is_valid_url = re.search(r'\.aspx$', user_url)

response = requests.get(user_url)
image_urls = re.findall(r'(?<=src=")[^"]*t\.jpg', response.text)
total_images = len(image_urls)
number_of_images = get_number_of_images(total_images)

destination_folder = input("Enter the destination folder name: ")
if not os.path.exists(destination_folder):
    os.makedirs(destination_folder)

downloaded_count = 0
skipped_count = 0

for image_url in image_urls[:number_of_images]:
    status = download_image(image_url, destination_folder)
    if status == "downloaded":
        downloaded_count += 1
    if status == "skipped":
        skipped_count += 1

print(f"\nAll images downloaded at '{os.path.abspath(destination_folder)}', Total downloaded: {downloaded_count}, Total skipped: {skipped_count}")
