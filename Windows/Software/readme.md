# Browsers

-   ### [Mozilla Firefox](https://www.mozilla.org/en-US/firefox/all/#product-desktop-release)

    -   #### [Installation Script](./install_firefox.ps1)

        ###### Note: Run PowerShell or Terminal as an administrator (not CMD), then copy and paste the code below and press 'Enter'.

        ```ps1
        # Set execution policy for this session only
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

        # Run script
        .\install_firefox.ps1

        # OR
        irm https://raw.githubusercontent.com/sakshiagrwal/Scripts/main/Windows/Software/install_firefox.ps1 | iex
        ```

    -   #### [Configure Firefox](https://github.com/amitxv/PC-Tuning/blob/main/docs/post-install.md#configure-a-web-browser)
    -   #### [Firefox Mod Blur](https://github.com/datguypiko/Firefox-Mod-Blur)

-   ### [Google Chrome](https://www.google.com/intl/en/chrome/?standalone=1)
    -   #### [Catppuccin Mocha](https://chromewebstore.google.com/detail/catppuccin-chrome-theme-m/bkkmolkhemgaeaeggcmfbghljjjoofoh) <!--https://github.com/catppuccin/chrome-->

# Code Editors and IDEs

-   ### [Visual Studio Code](https://code.visualstudio.com/download)
    -   #### [Alternative - VSCodium](https://github.com/VSCodium/vscodium)
    -   #### [Settings](../C/Users/Admin/AppData/Roaming/Code/User/settings.json)
-   ### [IntelliJ IDEA](https://www.jetbrains.com/idea/download/?section=windows)
    -   #### [Installation Guide - Linux](https://www.jetbrains.com/help/idea/installation-guide.html#9a778ae1)
-   ### [PyCharm](https://www.jetbrains.com/pycharm/download/?section=windows)
    -   #### [Installation Guide - Linux](https://www.jetbrains.com/help/pycharm/installation-guide.html#d2ebe883)
        ```sh
        sudo tar xzf pycharm-*.tar.gz -C /opt/ # Recommended installation location
        sudo sh /opt/pycharm-*/bin/pycharm.sh # Run as root for update
        sudo sh /opt/idea-*/bin/idea.sh
        ```
-   ### [Notepad++](https://github.com/notepad-plus-plus/notepad-plus-plus)
    -   #### [Catppuccin Theme](https://github.com/catppuccin/notepad-plus-plus/blob/main/catppuccin-mocha.xml)
    -   #### [Twilight Theme](https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/PowerEditor/installer/themes/Twilight.xml)
-   ### [Oh My Posh](https://github.com/jandedobbeleer/oh-my-posh)
    -   #### [Installation Guide - Windows](https://ohmyposh.dev/docs/installation/windows)
-   ### [Windows Terminal](https://github.com/microsoft/terminal)
    -   #### [Settings](../C/Users/Admin/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json)

# Development Tools

-   ### [Git](https://git-scm.com)
-   ### [Gpg4win](https://www.gpg4win.org)
-   ### [JDK 21](https://www.oracle.com/in/java/technologies/downloads/#jdk21-windows)
-   ### [Node.js](https://nodejs.org/en)
-   ### [Python](https://www.python.org/downloads)

# Runtimes

-   ### [Visual C++ Redist](https://github.com/abbodi1406/vcredist)
-   ### [DirectX Redist](https://www.microsoft.com/en-gb/download/details.aspx?id=8109)
-   ### [WebView2](https://developer.microsoft.com/en-us/microsoft-edge/webview2)

# Download Managers

-   ### [Internet Download Manager](https://www.internetdownloadmanager.com)
    -   #### [IDM Activation Script](https://github.com/WindowsAddict/IDM-Activation-Script)
    -   #### [IDM Trial Reset](https://github.com/J2TEAM/idm-trial-reset)
-   ### [Free Download Manager](https://www.freedownloadmanager.org)
-   ### [qBittorrent](https://www.qbittorrent.org)

# Media Players

-   ### [K-Lite Codec Pack](https://codecguide.com/download_k-lite_codec_pack_full.htm)
-   ### [VLC media player](https://www.videolan.org)
-   ### [Screenbox](https://github.com/huynhsontung/Screenbox)
-   ### [PV Photo Viewer](../Extra/pv.exe) <!-- https://github.com/davidly/PV -->

# Office

-   ### [Office 365 ProPlus](https://officecdn.microsoft.com/db/492350f6-3a01-4f97-b9c0-c7c6ddf67d60/media/en-us/O365ProPlusRetail.img) <!-- Office 365 ProPlus English US x86-64 Offline -->
    -   #### [Microsoft Activation Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)
        ###### Microsoft Activation Scripts 'Ohook' method can activate it.
    -   #### [Microsoft Activation Scripts Docs](https://massgrave.dev/office_c2r_links.html)

# Messaging

-   ### [Telegram Desktop](https://apps.microsoft.com/detail/telegram-desktop/9NZTWSQNTD0S?hl=en-in&gl=IN)
    -   #### [Alternative - Portable Version](https://desktop.telegram.org)
    -   #### [Alternative - MaterialYou](https://github.com/kukuruzka165/materialgram)
        ###### Note: Recommended installation directory for linux:
        ```sh
        sudo tar -xf tsetup*.tar.xz -C /opt/
        ```
-   ### [Indirect](https://github.com/huynhsontung/Indirect)

# Miscellaneous

-   ### [7-Zip](https://www.7-zip.org)
    -   #### [Configure 7-Zip](https://github.com/amitxv/PC-Tuning/blob/main/docs/post-install.md#install-7-zip)
-   ### [App Installer](https://apps.microsoft.com/detail/app-installer/9NBLGGH4NNS1?hl=en-in&gl=IN)
    -   #### [GitHub](https://github.com/microsoft/winget-cli/releases)
-   ### [AMD Software](https://www.amd.com/en/support/apu/amd-ryzen-processors/amd-ryzen-5-mobile-processors-radeon-vega-graphics/amd-ryzen-5-1)
    -   #### [Installation Guide](https://docs.atlasos.net/getting-started/post-installation/drivers/gpu/amd)
    -   #### [Alternative Guide](https://github.com/amitxv/PC-Tuning/blob/main/docs/configure-amd.md)
-   ### [BleachBit](https://github.com/bleachbit/bleachbit)
    -   #### [Alternative - CleanmgrPlus](https://github.com/builtbybel/CleanmgrPlus)
-   ### [Bulk Crap Uninstaller](https://github.com/Klocman/Bulk-Crap-Uninstaller)
-   ### [Calculator](https://apps.microsoft.com/detail/windows-calculator/9WZDNCRFHVN5?hl=en-in&gl=IN) <!-- https://github.com/microsoft/calculator -->
    -   #### [Parsify Desktop](https://github.com/parsify-dev/desktop)
-   ### [ExplorerBlurMica](https://github.com/Maplespe/ExplorerBlurMica)
-   ### [HEIF Image Extensions](https://apps.microsoft.com/detail/heif-image-extensions/9PMMSR1CGPWG?hl=en-in&gl=IN)
-   ### [MyAsus](https://apps.microsoft.com/detail/myasus/9N7R5S6B0ZZH?hl=en-in&gl=IN)

    -   #### Set the battery charging threshold to `80%` (Install this driver) [ASUS System Control Interface v3](https://www.asus.com/support/Download-Center/)
        ```cmd
        reg add "HKLM\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" /v ChargingRate /t REG_DWORD /d 80 /f
        
        :: Computer\HKEY_LOCAL_MACHINE\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys
        :: Select 'ChargingRate'
        :: Value data '3c' (Hexadecimal) OR '60' (Decimal)
        ```
        -   Restart the Asus Optimization service in PowerShell (Administrator): `Restart-Service "ASUSOptimization"`
        -   List all ASUS services: `Get-Service | Where-Object {$_.Name -like "*ASUS*"}`
        -   Disable all ASUS services except `ASUSOptimization` using this: `Set-Service -Name "AsusAppService" -StartupType Disabled`
        -   ASUS Servises: AsusAppService, ASUSLinkNear, ASUSLinkRemote, ASUSSoftwareManager, ASUSSwitch, ASUSSystemAnalysis, ASUSSystemDiagnosis.

-   ### [Notepad](https://apps.microsoft.com/detail/windows-notepad/9MSMLRH6LZF3)
-   ### [Obsidian](https://obsidian.md)
-   ### [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)
    -   #### [Configure Process Explorer](https://github.com/amitxv/PC-Tuning/blob/main/docs/post-install.md#replace-task-manager-with-process-explorer)
-   ### [Proton VPN](https://protonvpn.com/download-windows)
    -   #### [Installation Guide - Linux](https://protonvpn.com/support/official-linux-vpn-mint/)
-   ### [Revo Uninstaller Pro](https://www.revouninstaller.com/revo-uninstaller-free-download)
    ###### For activation, download the [revouninstallerpro5.lic](../Extra/revouninstallerpro5.lic) file and copy it to the following path:
    ```ps1
    C:\ProgramData\VS Revo Group\Revo Uninstaller Pro\
    ```
-   ### [StartAllBack](https://www.startallback.com)
    -   #### [SAB - Activation Script](https://github.com/sakshiagrwal/SAB)
-   ### [StartIsBack++](https://www.startisback.com/#download-tab)
    ###### For activation, download the [msimg32.dll](../Extra/msimg32.dll) file and copy it to the following path:
    ```ps1
    C:\Program Files (x86)\StartIsBack\
    ```
-   ### [Winpinator](https://winpinator.swisz.cz/download.html)
-   ### [YoutubeDownloader](https://github.com/Tyrrrz/YoutubeDownloader)
    -   ##### `.NET Runtime` [Installation Script For Linux](https://aka.ms/dotnet-core-applaunch?missing_runtime=true&arch=x64&rid=linux-x64&os=linuxmint.21.3&apphost_version=8.0.4)
        ```sh
        wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && chmod +x ./dotnet-install.sh && ./dotnet-install.sh --version latest && export DOTNET_ROOT=$HOME/.dotnet

        cd YoutubeDownloader/
        ./YoutubeDownloader # Launch App
        ```
