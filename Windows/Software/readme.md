# Software Setup Guide

## Browsers

### [Mozilla Firefox](https://www.mozilla.org/en-US/firefox/all/#product-desktop-release)
- **Installation Script** - Run PowerShell or Terminal as an admin (not CMD), then copy and paste the code below and press 'Enter'.
    ```ps1
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; & "$env:USERPROFILE\Downloads\install_firefox.ps1"
    ```
    **OR**
    ```ps1
    irm https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Software/install_firefox.ps1 | iex
    ```
- **Configure Firefox** - [Post-Install Configuration](https://github.com/amitxv/PC-Tuning/blob/main/docs/post-install.md#configure-a-web-browser)
- **Firefox Mod Blur** - [Customization Guide](https://github.com/datguypiko/Firefox-Mod-Blur)

### [Google Chrome](https://www.google.com/intl/en/chrome/?standalone=1)
- **Catppuccin Mocha** - [Chrome Theme](https://chromewebstore.google.com/detail/catppuccin-chrome-theme-m/bkkmolkhemgaeaeggcmfbghljjjoofoh)

## Code Editors and IDEs

### [Visual Studio Code](https://code.visualstudio.com/download)
- **Alternative** - [VSCodium](https://github.com/VSCodium/vscodium)
- **Settings** - [settings.json](../C/Users/Admin/AppData/Roaming/Code/User/settings.json)

### [IntelliJ IDEA](https://www.jetbrains.com/idea/download/?section=windows)
- **Installation Guide (Linux)**
    ```sh
    sudo tar xzf ideaIC-*.tar.gz -C /opt/ # Recommended installation location
    sudo sh /opt/idea-*/bin/idea.sh # Run as root for update
    ```

### [PyCharm](https://www.jetbrains.com/pycharm/download/?section=windows)
- **Installation Guide (Linux)**
    ```sh
    sudo tar xzf pycharm-*.tar.gz -C /opt/ # Recommended installation location
    sudo sh /opt/pycharm-*/bin/pycharm.sh # Run as root for update
    ```

### [Notepad++](https://github.com/notepad-plus-plus/notepad-plus-plus)
- **Themes**:
    - [Catppuccin Theme](https://github.com/catppuccin/notepad-plus-plus/blob/main/catppuccin-mocha.xml)
    - [Twilight Theme](https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/PowerEditor/installer/themes/Twilight.xml)

### [Oh My Posh](https://github.com/jandedobbeleer/oh-my-posh)
- **Installation Guide (Windows)** - [Guide](https://ohmyposh.dev/docs/installation/windows)

### [Windows Terminal](https://github.com/microsoft/terminal)
- **Settings** - [settings.json](../C/Users/Admin/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json)

## Development Tools

### [Git](https://git-scm.com)

### [Gpg4win](https://www.gpg4win.org)

### [JDK 22](https://www.oracle.com/in/java/technologies/downloads/)

### [Node.js](https://nodejs.org/en)

### [Python](https://www.python.org/downloads)

## Runtimes

### [Visual C++ Redist](https://github.com/abbodi1406/vcredist)

### [DirectX Redist](https://www.microsoft.com/en-gb/download/details.aspx?id=8109)

### [WebView2](https://developer.microsoft.com/en-us/microsoft-edge/webview2)

## Download Managers

### [Internet Download Manager](https://www.internetdownloadmanager.com)
- **IDM Trial Reset** - [Trial Reset Script](https://github.com/J2TEAM/idm-trial-reset)

### [Free Download Manager](https://www.freedownloadmanager.org)

### [qBittorrent](https://www.qbittorrent.org)

## Media Players

### [K-Lite Codec Pack](https://codecguide.com/download_k-lite_codec_pack_full.htm)

### [VLC media player](https://www.videolan.org)

### [Screenbox](https://github.com/huynhsontung/Screenbox)

### [PV Photo Viewer](../Extra/pv.exe)

## Office

### [Office 365 ProPlus](https://officecdn.microsoft.com/db/492350f6-3a01-4f97-b9c0-c7c6ddf67d60/media/en-us/O365ProPlusRetail.img)
- **Microsoft Activation Scripts** - [Activation Script](https://github.com/massgravel/Microsoft-Activation-Scripts)
- **Activation Script Docs** - [Documentation](https://massgrave.dev/office_c2r_links.html)

## Messaging

### [Telegram Desktop](https://github.com/telegramdesktop/tdesktop/releases/latest)
- **Alternative - Portable Version** - [Portable Version](https://desktop.telegram.org)
- **Alternative - MaterialYou** - [MaterialYou](https://github.com/kukuruzka165/materialgram)
    ```sh
    sudo tar -xf tsetup*.tar.xz -C /opt/ # Recommended installation directory for debian
    ```

### [Indirect](https://github.com/huynhsontung/Indirect)

## Miscellaneous

### [7-Zip](https://www.7-zip.org)
- **Configure 7-Zip** - [Guide](https://github.com/amitxv/PC-Tuning/blob/main/docs/post-install.md#install-7-zip)

### [App Installer](https://apps.microsoft.com/detail/app-installer/9NBLGGH4NNS1?hl=en-in&gl=IN)
- **GitHub** - [winget-cli](https://github.com/microsoft/winget-cli/releases)

### [AMD Software](https://www.amd.com/en/support/apu/amd-ryzen-processors/amd-ryzen-5-mobile-processors-radeon-vega-graphics/amd-ryzen-5-1)
- **Installation Guide** - [Guide](https://docs.atlasos.net/getting-started/post-installation/drivers/gpu/amd)
- **Alternative Guide** - [Guide](https://github.com/amitxv/PC-Tuning/blob/main/docs/configure-amd.md)

### [BleachBit](https://github.com/bleachbit/bleachbit)
- **Alternative - CleanmgrPlus** - [CleanmgrPlus](https://github.com/builtbybel/CleanmgrPlus)

### [Bulk Crap Uninstaller](https://github.com/Klocman/Bulk-Crap-Uninstaller)

### [Calculator](https://apps.microsoft.com/detail/windows-calculator/9WZDNCRFHVN5?hl=en-in&gl=IN)
- **Parsify Desktop** - [Parsify Desktop](https://github.com/parsify-dev/desktop)

### [ExplorerBlurMica](https://github.com/Maplespe/ExplorerBlurMica)

### [HEIF Image Extensions](https://apps.microsoft.com/detail/heif-image-extensions/9PMMSR1CGPWG?hl=en-in&gl=IN)

### [MyASUS](https://apps.microsoft.com/detail/myasus/9N7R5S6B0ZZH?hl=en-in&gl=IN)
- **Set Battery Charging Threshold to 60% Without the MyASUS App**:
    - Install the [ASUS System Control Interface](https://www.asus.com/support/Download-Center/) driver.
    - Open Command Prompt as an administrator and run the following command:
        ```cmd
        reg add "HKLM\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" /v ChargingRate /t REG_DWORD /d 60 /f
        ```
    - Alternatively, add the registry key manually:
        - Navigate to `HKLM\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys\ASUS Keyboard Hotkeys`.
        - Select `ChargingRate`.
        - Set the value data to `3c` (Hexadecimal) or `60` (Decimal).

    - **List all ASUS Services**:
        ```powershell
        Get-Service | Where-Object {$_.Name -like "*ASUS*"}
        ```
    - **Disable all ASUS Services Except 'ASUSOptimization'**:
        ```powershell
        Set-Service -Name "AsusAppService" -StartupType Disabled
        ```
    - **List of All ASUS Services**:
        - AsusAppService
        - ASUSLinkNear
        - ASUSLinkRemote
        - ASUSSoftwareManager
        - ASUSSwitch
        - ASUSSystemAnalysis
        - ASUSSystemDiagnosis

    - **Restart the ASUS Optimization Service in PowerShell (Run as Administrator)**:
        ```powershell
        Restart-Service "ASUSOptimization"
        ```

    - **Alternatively, use the following script** - [Script](../Extra/charging_threshold.ps1)

### [Notepad](https://apps.microsoft.com/detail/windows-notepad/9MSMLRH6LZF3)

### [Obsidian](https://obsidian.md)

### [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)
- **Configure Process Explorer** - [Guide](https://github.com/amitxv/

PC-Tuning/blob/main/docs/post-install.md#replace-task-manager-with-process-explorer)

### [Proton VPN](https://protonvpn.com/download-windows)
- **Installation Guide (Linux)** - [Guide](https://protonvpn.com/support/official-linux-vpn-mint/)

### [Revo Uninstaller Pro](https://www.revouninstaller.com/revo-uninstaller-free-download)
- **Activation** - Download the `revouninstallerpro5.lic` file and copy it to the following path:
    ```ps1
    C:\ProgramData\VS Revo Group\Revo Uninstaller Pro\
    ```

### [StartAllBack](https://www.startallback.com)
- **SAB Activation Script** - [Script](https://github.com/sakshiagrwal/SAB)

### [StartIsBack++](https://www.startisback.com/#download-tab)
- **Activation** - Download the `msimg32.dll` file and copy it to the following path:
    ```ps1
    C:\Program Files (x86)\StartIsBack\
    ```

### [Winpinator](https://winpinator.swisz.cz/download.html)

### [YoutubeDownloader](https://github.com/Tyrrrz/YoutubeDownloader)
- **Install `.NET Runtime` On Linux Mint** - [Guide](https://learn.microsoft.com/en-in/dotnet/core/install/linux-debian#debian-12)
    ```sh
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb

    sudo apt update && sudo apt install -y dotnet-sdk-8.0 # Install SDK (Optional)
    dotnet --list-sdks # Check SDK versions

    sudo apt update && sudo apt install -y aspnetcore-runtime-8.0 # Install Runtimes
    dotnet --list-runtimes # Check Runtime versions

    cd YoutubeDownloader/ # Open installation directory
    ./YoutubeDownloader # Launch app
    ```
