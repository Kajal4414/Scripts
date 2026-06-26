#!/bin/bash

# ─── Colors ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ─── Default URL ─────────────────────────────────────────
default_url="https://www.ragalahari.com/actor/171464/allu-arjun-at-honer-richmont-launch.aspx"

# ─── Prompt For URL ─────────────────────────────────────
echo -ne "Enter the gallery URL (Press Enter for default '${CYAN}$default_url${NC}'): "
read user_url
user_url="${user_url:-$default_url}"

# ─── Validate URL ───────────────────────────────────────
if [[ ! "$user_url" =~ \.aspx$ ]]; then
  echo -e "\n${RED}❌ Invalid URL. Please enter a valid gallery URL ending with '.aspx'.${NC}"
  exit 1
fi

# ─── Fetch HTML ─────────────────────────────────────────
html=$(curl -s "$user_url")
if [[ -z "$html" ]]; then
  echo -e "\n${RED}❌ Failed to retrieve the gallery page. Please check the URL and try again.${NC}"
  exit 1
fi

# ─── Extract Image URLs ─────────────────────────────────
mapfile -t image_urls < <(echo "$html" | grep -oP 'src=["'\'']\K[^"'\''>]+t\.jpg' | sed 's/t\.jpg$/.jpg/')
total_images=${#image_urls[@]}

if (( total_images == 0 )); then
  echo -e "${YELLOW}⚠️  No images found on the page.${NC}"
  exit 0
fi

# ─── Prompt For Number Of Images ────────────────────────
echo -ne "Enter the number of images to download (Press Enter for all '${CYAN}$total_images${NC}'): "
read input_num

if [[ -z "$input_num" ]]; then
  number_of_images=$total_images
elif [[ "$input_num" =~ ^[0-9]+$ && $input_num -gt 0 && $input_num -le $total_images ]]; then
  number_of_images=$input_num
else
  echo -e "${RED}❌ Invalid input. Must be a number between 1 and $total_images.${NC}"
  exit 1
fi

# ─── Create Folder ──────────────────────────────────────
folder_name=$(basename "$user_url" .aspx | sed -E 's/-/ /g; s/^(actress|heroine) //I' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
mkdir -p "$folder_name"
echo -e "\n${GREEN}📁 Folder Created: $folder_name${NC}\n"

# ─── Download Images ────────────────────────────────────
downloaded=0
skipped=0
failed=0

for (( i = 0; i < number_of_images; i++ )); do
  img_url="${image_urls[i]}"
  file_name=$(basename "$img_url")
  file_path="$folder_name/$file_name"

  if [[ -f "$file_path" ]]; then
    echo -e "${YELLOW}⏩ $file_name - Skipped.${NC}"
    ((skipped++))
    continue
  fi

  echo -ne "${BLUE}⬇️  $file_name - Downloading...${NC}"
  curl -s -o "$file_path" "$img_url"

  if [[ $? -eq 0 && -s "$file_path" ]]; then
    echo -e "\r${GREEN}✅ $file_name - Downloaded.${NC}    "
    ((downloaded++))
  else
    echo -e "\r${RED}❌ $file_name - Failed.${NC}       "
    ((failed++))
    [[ -f "$file_path" ]] && rm -f "$file_path"
  fi
done

# ─── Summary ─────────────────────────────────────────────
echo -e "\n${GREEN}✅ Downloaded: $downloaded${NC}" | tr -d '\n'
[[ $skipped -gt 0 ]] && echo -en "  •  ${YELLOW}⏩ Skipped: $skipped${NC}"
[[ $failed -gt 0 ]] && echo -en "  •  ${RED}❌ Failed: $failed${NC}"
echo
echo -e "\n${CYAN}📂 All Images Saved At: '$(realpath "$folder_name")'${NC}\n"
