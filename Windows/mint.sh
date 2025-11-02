#!/bin/bash

# --- Define Colors ---
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
NC="\e[0m" # No Color

# --- Function for Interactive Prompts ---
prompt_for_section() {
    echo "" # Add a blank line for readability
    echo -e "${YELLOW}Do you want to run '$1' section? (y/n)${NC}"
    read -p "Enter your choice: " choice
    [[ $choice =~ ^[Yy]$ ]]
}

# --- General System Setup ---
if prompt_for_section "System Update"; then
    echo -e "${GREEN}Updating system packages...${NC}"
    sudo apt update && sudo apt upgrade -y
else
    echo -e "${RED}Skipping system update.${NC}"
fi

# --- Core Package Installation ---
if prompt_for_section "Core Packages"; then
    echo -e "${GREEN}Installing essential packages...${NC}"
    sudo apt install -y adb bleachbit ffmpeg git python3-pip python3-secretstorage vlc
else
    echo -e "${RED}Skipping core packages.${NC}"
fi

# --- Install Node.js 22.x LTS (https://deb.nodesource.com/) ---
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
sudo apt-get install -y nodejs
node -v # Verify Node.js
npm -v # Verify npm

# --- Browser & Utility Installation ---
if prompt_for_section "Brave Browser"; then
    echo -e "${GREEN}Installing Brave Browser...${NC}"
    curl -fsS https://dl.brave.com/install.sh | sh
else
    echo -e "${RED}Skipping Brave Browser.${NC}"
fi

if prompt_for_section "YT-DLP"; then
    echo -e "${GREEN}Installing YT-DLP...${NC}"
    sudo wget -q --show-progress https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/bin/yt-dlp && sudo chmod +x /usr/bin/yt-dlp
else
    echo -e "${RED}Skipping YT-DLP.${NC}"
fi

if prompt_for_section "YoutubeDownloader"; then
    echo -e "${GREEN}Installing YoutubeDownloader...${NC}" # Bare = Without FFmpeg
    cd ~/Downloads && wget -q --show-progress https://github.com/Tyrrrz/YoutubeDownloader/releases/latest/download/YoutubeDownloader.Bare.linux-x64.zip && unzip Youtube*.zip -d "YT Downloader Bare" && rm Youtube*.zip
else
    echo -e "${RED}Skipping YoutubeDownloader.${NC}"
fi

if prompt_for_section "Universal Android Debloater NG"; then
    echo -e "${GREEN}Installing Universal Android Debloater NG...${NC}"
    wget -q --show-progress https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest/download/uad-ng-linux -O ~/Desktop/UAD-NG && chmod +x ~/Desktop/UAD-NG
else
    echo -e "${RED}Skipping UAD-NG.${NC}"
fi

if prompt_for_section "Google Chrome"; then
    echo -e "${GREEN}Installing Google Chrome...${NC}"
    wget -q --show-progress https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i ./google*_amd64.deb && rm ./google*_amd64.deb
else
    echo -e "${RED}Skipping Google Chrome.${NC}"
fi

if prompt_for_section "VS Code"; then
    echo -e "${GREEN}Installing VS Code...${NC}"
    wget -q --show-progress https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 && sudo dpkg -i ./code*_amd64.deb && rm ./code*_amd64.deb
else
    echo -e "${RED}Skipping VS Code.${NC}"
fi

# --- Developer Software (JetBrains & Java) ---

if prompt_for_section "Java JDK"; then
    echo -e "${GREEN}Installing Java JDK...${NC}"
    jdk=$(curl -s "https://www.oracle.com/java/technologies/downloads/" | grep -oP 'href="\K[^"]*linux-x64_bin\.deb' | head -n 1) && wget -q --show-progress $jdk && sudo dpkg -i ./jdk*_bin.deb && rm ./jdk*_bin.deb
else
    echo -e "${RED}Skipping Java JDK.${NC}"
fi

if prompt_for_section "IntelliJ IDEA"; then
    echo -e "${GREEN}Installing IntelliJ IDEA Community Edition...${NC}"
    icc=$(curl -s "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true" | grep -oP '"linux":\s*{\s*"link":\s*"\K[^"]+') && wget -q --show-progress $icc && sudo tar -xzf ./ideaIC-*.tar.gz -C /opt && rm ./ideaIC-*.tar.gz
else
    echo -e "${RED}Skipping IntelliJ IDEA.${NC}"
fi

if prompt_for_section "PyCharm"; then
    echo -e "${GREEN}Installing PyCharm Community Edition...${NC}"
    pcc=$(curl -s "https://data.services.jetbrains.com/products/releases?code=PCC&latest=true" | grep -oP '"linux":\s*{\s*"link":\s*"\K[^"]+') && wget -q --show-progress $pcc && sudo tar -xzf ./pycharm-*.tar.gz -C /opt && rm ./pycharm-*.tar.gz
else
    echo -e "${RED}Skipping PyCharm.${NC}"
fi

if prompt_for_section "Telegram"; then
    echo -e "${GREEN}Installing Telegram Desktop...${NC}"
    tgm=$(curl -s "https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest" | grep -oP '"browser_download_url": "\K[^"]*tsetup[^"]*\.tar\.xz') && wget -q --show-progress $tgm && sudo tar -xf ./tsetup*.tar.xz -C /opt && rm ./tsetup*.tar.xz
else
    echo -e "${RED}Skipping Telegram.${NC}"
fi

# --- Git & SSH Configuration ---

if prompt_for_section "Git Configuration"; then
    echo -e "${GREEN}Configuring Git...${NC}"
    git config --global user.name "Deepak5310"
    git config --global user.email "37282143+Deepak5310@users.noreply.github.com"
    git config --global core.editor "xed --wait"
else
    echo -e "${RED}Skipping Git configuration.${NC}"
fi

if prompt_for_section "SSH Setup"; then
    echo -e "${GREEN}Setting up SSH key...${NC}"
    mkdir -p ~/.ssh && mv ./id_ed25519 ./id_ed25519.pub ~/.ssh && chmod 600 ~/.ssh/id_ed25519
else
    echo -e "${RED}Skipping SSH setup.${NC}"
fi

# --- VS Code Extensions & Settings ---

if prompt_for_section "VS Code Extensions"; then
    echo -e "${GREEN}Installing VS Code extensions...${NC}"
    extensions=("beardedbear.beardedtheme" "dbaeumer.vscode-eslint" "eamodio.gitlens" "esbenp.prettier-vscode" "foxundermoon.shell-format" "github.codespaces" "github.github-vscode-theme" "jock.svg" "ms-python.black-formatter" "ms-python.debugpy" "ms-python.pylint" "ms-python.python" "ms-python.vscode-pylance" "ms-vscode.makefile-tools" "ms-vscode.powershell" "pkief.material-icon-theme" "redhat.java" "redhat.vscode-xml" "redhat.vscode-yaml" "ritwickdey.liveserver" "visualstudioexptteam.intellicode-api-usage-examples" "visualstudioexptteam.vscodeintellicode" "vscjava.vscode-java-debug" "vscjava.vscode-java-dependency" "vscjava.vscode-java-pack")
    for ext in "${extensions[@]}"; do
        code --install-extension $ext
    done
else
    echo -e "${RED}Skipping VS Code extensions.${NC}"
fi

if prompt_for_section "VS Code Settings"; then
    echo -e "${GREEN}Copying VS Code settings...${NC}"
    cp ./settings.json ~/.config/Code/User
else
    echo -e "${RED}Skipping VS Code settings.${NC}"
fi

# --- System & UI Customization ---

if prompt_for_section "Battery Charging Threshold"; then
    echo -e "${GREEN}Setting battery charging threshold...${NC}"
    sudo wget -q --show-progress https://raw.githubusercontent.com/Kajal4414/Scripts/refs/heads/main/Linux/etc/systemd/system/battery-threshold.service -P /etc/systemd/system/ && sudo systemctl enable --now battery-threshold.service
else
    echo -e "${RED}Skipping battery threshold setup.${NC}"
fi

# --- Theme & Icon Installation ---

if prompt_for_section "Colloid-gtk-theme"; then
    echo -e "${GREEN}Installing Colloid GTK Theme...${NC}"
    git clone --depth 1 https://github.com/vinceliuice/Colloid-gtk-theme && cd ./Colloid-gtk-theme && ./install.sh -u && ./install.sh -c dark --tweaks black rimless -l fixed && cd .. && rm -rf ./Colloid-gtk-theme
else
    echo -e "${RED}Skipping Colloid-gtk-theme.${NC}"
fi

if prompt_for_section "Colloid-icon-theme"; then
    echo -e "${GREEN}Installing Colloid Icon Theme...${NC}"
    git clone --depth 1 https://github.com/vinceliuice/Colloid-icon-theme && cd ./Colloid-icon-theme && ./install.sh -u && ./install.sh && cd .. && rm -rf ./Colloid-icon-theme
    # [ -f /usr/share/applications/protonvpn-app.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/Colloid/apps/scalable/protonvpn-gui.svg|" /usr/share/applications/protonvpn-app.desktop
    # [ -f /usr/share/applications/jetbrains-pycharm-ce.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/Colloid/apps/scalable/pycharm.svg|" /usr/share/applications/jetbrains-pycharm-ce.desktop
    # [ -f /usr/share/applications/jetbrains-idea-ce.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/Colloid/apps/scalable/idea.svg|" /usr/share/applications/jetbrains-idea-ce.desktop
    # [ -f /usr/share/applications/jetbrains-studio.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/Colloid/apps/scalable/android-studio.svg|" /usr/share/applications/jetbrains-studio.desktop
    # [ -f /usr/share/applications/freedownloadmanager.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/Colloid/apps/scalable/freedownloadmanager.svg|" /usr/share/applications/freedownloadmanager.desktop
else
    echo -e "${RED}Skipping Colloid-icon-theme.${NC}"
fi

if prompt_for_section "Orchis-theme"; then
    echo -e "${GREEN}Installing Orchis Theme...${NC}"
    git clone --depth 1 https://github.com/vinceliuice/Orchis-theme && cd ./Orchis-theme && ./install.sh -u && ./install.sh -c dark -s compact --tweaks black macos primary submenu --round 8px -l && cd .. && rm -rf ./Orchis-theme
else
    echo -e "${RED}Skipping Orchis-theme.${NC}"
fi

if prompt_for_section "WhiteSur-icon-theme"; then
    echo -e "${GREEN}Installing WhiteSur Icon Theme...${NC}"
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme && cd ./WhiteSur-icon-theme && ./install.sh -u && ./install.sh && cd .. && rm -rf ./WhiteSur-icon-theme
    # [ -f /usr/share/applications/protonvpn-app.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/WhiteSur/apps/scalable/protonvpn-gui.svg|" /usr/share/applications/protonvpn-app.desktop
    # [ -f /usr/share/applications/jetbrains-pycharm-ce.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/WhiteSur/apps/scalable/pycharm.svg|" /usr/share/applications/jetbrains-pycharm-ce.desktop
    # [ -f /usr/share/applications/jetbrains-idea-ce.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/WhiteSur/apps/scalable/idea.svg|" /usr/share/applications/jetbrains-idea-ce.desktop
    # [ -f /usr/share/applications/jetbrains-studio.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/WhiteSur/apps/scalable/android-studio.svg|" /usr/share/applications/jetbrains-studio.desktop
    # [ -f /usr/share/applications/freedownloadmanager.desktop ] && sudo sed -i "s|Icon=.*|Icon=/usr/share/icons/WhiteSur/apps/scalable/freedownloadmanager.svg|" /usr/share/applications/freedownloadmanager.desktop
else
    echo -e "${RED}Skipping WhiteSur-icon-theme.${NC}"
fi

# --- Cursor & Font Installation ---

if prompt_for_section "Fonts"; then
    echo -e "${GREEN}Installing Fonts...${NC}"
    mkdir -p ~/.local/share/fonts && cp ./JetBrainsMono/variable/*.ttf ./IBMPlexSans/*.ttf ~/.local/share/fonts
else
    echo -e "${RED}Skipping font installation.${NC}"
fi

if prompt_for_section "Font Cache Rebuild"; then
    echo -e "${GREEN}Rebuilding font cache...${NC}"
    fc-cache -f -v
else
    echo -e "${RED}Skipping font cache rebuild.${NC}"
fi

if prompt_for_section "Apple Cursors"; then
    echo -e "${GREEN}Installing Apple Cursors...${NC}"
    (cd ~/Downloads && wget -q --show-progress https://github.com/ful1e5/apple_cursor/releases/latest/download/macOS.tar.xz && tar -xf macOS.tar.xz && mv macOS/ ~/.icons/ && rm -r macOS.tar.xz macOS-White/ LICENSE)
else
    echo -e "${RED}Skipping Apple Cursors.${NC}"
fi

# --- System Tweaks ---

if prompt_for_section "Create 4GB swap space"; then
    echo -e "${GREEN}Swap file creating...${NC}"
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
else
    echo -e "${RED}Skipping swap space.${NC}"
fi

if prompt_for_section "Memory optimization"; then
    echo -e "${GREEN}Memory optimization...${NC}"
    echo -e "vm.swappiness=10\nvm.vfs_cache_pressure=50\nvm.overcommit_ratio=90\nvm.overcommit_memory=1" | sudo tee /etc/sysctl.d/99-memory-tuning.conf
else
    echo -e "${RED}Skipping memory optimization.${NC}"
fi
