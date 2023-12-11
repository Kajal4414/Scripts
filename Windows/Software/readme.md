# Browsers

-   ### [Mozilla Firefox](https://www.mozilla.org/en-US/firefox/all/#product-desktop-release)

    -   #### [Installation Script](./install_firefox.ps1)

        ```ps1
        # Note: Run PowerShell or Terminal as an administrator (not CMD), then copy and paste the code below and press 'Enter'.

        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass # Set execution policy for this session only

        install_firefox.ps1 # Run script
        ```

    -   #### [Configure Firefox](https://github.com/amitxv/PC-Tuning/blob/main/docs/post-install.md#configure-a-web-browser)
    -   #### [~~Firefox Mod Blur~~](https://github.com/datguypiko/Firefox-Mod-Blur) - Deprecated

-   ### [Google Chrome](https://www.google.com/intl/en/chrome/?standalone=1)

    ```ps1
    curl.exe -LS -o ChromeBrowser.exe https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe
    ```

    -   #### [Catppuccin Mocha](https://chromewebstore.google.com/detail/catppuccin-chrome-theme-m/bkkmolkhemgaeaeggcmfbghljjjoofoh) <!--https://github.com/catppuccin/chrome-->

-   ### [Brave](https://github.com/brave/brave-browser)

    ```ps1
    # WebRequest
    Invoke-WebRequest -Uri $((Invoke-RestMethod -Uri 'https://api.github.com/repos/brave/brave-browser/releases/latest').assets | Where-Object { $_.name -eq 'BraveBrowserStandaloneSetup.exe' } | Select-Object -ExpandProperty browser_download_url) -OutFile BraveBrowser.exe

    # cURL
    curl.exe -LS -o BraveBrowser.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/brave/brave-browser/releases/latest').assets | Where-Object { $_.name -eq 'BraveBrowserStandaloneSetup.exe' } | Select-Object -ExpandProperty browser_download_url)
    ```

# Code Editors and IDEs

-   ### [Visual Studio Code](https://code.visualstudio.com/download)

    ```ps1
    curl.exe -LS -o VSCode.exe https://update.code.visualstudio.com/latest/win32-x64/stable
    ```

    -   #### [Alternative - VSCodium](https://github.com/VSCodium/vscodium)

        ```ps1
        curl.exe -LS -o VSCodium.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/VSCodium/vscodium/releases/latest').assets | Where-Object { $_.name -like 'VSCodiumSetup-x64*.exe' } | Select-Object -ExpandProperty browser_download_url)
        ```

    -   #### [Settings](../C/Users/Admin/AppData/Roaming/Code/User/settings.json)

-   ### [IntelliJ IDEA](https://www.jetbrains.com/idea/download/?section=windows)
    -   #### [Installation Guide - Linux](https://www.jetbrains.com/help/idea/installation-guide.html#9a778ae1)
-   ### [PyCharm](https://www.jetbrains.com/pycharm/download/?section=windows)
    -   #### [Installation Guide - Linux](https://www.jetbrains.com/help/pycharm/installation-guide.html#d2ebe883)
-   ### [Notepad++](https://github.com/notepad-plus-plus/notepad-plus-plus)

    ```ps1
    curl.exe -LS -o Notepad++.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest').assets | Where-Object { $_.name -like 'npp*x64.exe' } | Select-Object -ExpandProperty browser_download_url)
    ```

    -   #### [Catppuccin Theme](https://github.com/catppuccin/notepad-plus-plus/blob/main/catppuccin-mocha.xml)
    -   #### [Twilight Theme](https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/PowerEditor/installer/themes/Twilight.xml)

-   ### [Oh My Posh](https://github.com/jandedobbeleer/oh-my-posh)

    ```ps1
    curl.exe -LS -o OhMyposh.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/releases/latest').assets | Where-Object { $_.name -eq 'install-amd64.exe' } | Select-Object -ExpandProperty browser_download_url)
    ```

    -   #### [Installation Guide - Windows](https://ohmyposh.dev/docs/installation/windows)

-   ### [Windows Terminal](https://github.com/microsoft/terminal)
    -   #### [Settings](../C/Users/Admin/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json)

# Development Tools

-   ### [Git](https://git-scm.com)

    ```ps1
    curl.exe -LS -o Git.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest').assets | Where-Object { $_.name -like 'Git*64-bit.exe' } | Select-Object -ExpandProperty browser_download_url)
    ```

-   ### [Gpg4win](https://www.gpg4win.org)

    ```ps1
    curl.exe -LS -o Gpg4win.exe https://files.gpg4win.org/gpg4win-latest.exe
    ```

-   ### [JDK 21](https://www.oracle.com/in/java/technologies/downloads/#jdk21-windows)

    ```ps1
    curl.exe -LS -o JDK.exe https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe
    ```

-   ### [Node.js](https://nodejs.org/en)

    ```ps1
    $baseUrl = 'https://nodejs.org/download/release/latest/'; curl.exe -LS -o Node.msi "$baseUrl$((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'node*x64.msi' } | Select-Object -First 1 -ExpandProperty Href)"
    ```

-   ### [Python](https://www.python.org/downloads)

    ```ps1
    curl.exe -LS -o Python.exe "$((Invoke-WebRequest -Uri 'https://www.python.org/downloads' -UseBasicParsing).Links | Where-Object { $_.Href -like '*amd64.exe' } | Select-Object -First 1 -ExpandProperty Href)"
    ```

# Runtimes

-   ### [Visual C++ Redist](https://github.com/abbodi1406/vcredist)

    ```ps1
    curl.exe -LS -o VisualCppRedist.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/abbodi1406/vcredist/releases/latest').assets | Where-Object { $_.name -eq 'VisualCppRedist_AIO_x86_x64.exe' } | Select-Object -ExpandProperty browser_download_url)
    ```

-   ### [DirectX Redist](https://www.microsoft.com/en-gb/download/details.aspx?id=8109)
-   ### [WebView2](https://developer.microsoft.com/en-us/microsoft-edge/webview2)

# Download Managers

-   ### [Internet Download Manager](https://www.internetdownloadmanager.com)

    ```ps1
    curl.exe -LS -o IDM.exe "$((Invoke-WebRequest -Uri 'https://www.internetdownloadmanager.com' -UseBasicParsing).Links | Where-Object { $_.Href -like '*.exe' } | Select-Object -First 1 -ExpandProperty Href)"
    ```

    -   #### [IDM Activation Script](https://github.com/WindowsAddict/IDM-Activation-Script)

        ```ps1
        irm https://massgrave.dev/ias | iex
        ```

    -   #### [IDM Trial Reset](https://github.com/J2TEAM/idm-trial-reset)

-   ### [Free Download Manager](https://www.freedownloadmanager.org)
-   ### [qBittorrent](https://www.qbittorrent.org)

# Media Players

-   ### [K-Lite Codec Pack](https://codecguide.com/download_k-lite_codec_pack_full.htm)

    ```ps1
    curl.exe -LS -o K-Lite.exe "$((Invoke-WebRequest -Uri 'https://codecguide.com/download_k-lite_codec_pack_full.htm' -UseBasicParsing).Links | Where-Object { $_.Href -like '*Full.exe' } | Select-Object -First 1 -ExpandProperty Href)"
    ```

-   ### [VLC media player](https://www.videolan.org)

    ```ps1
    $baseUrl = 'https://get.videolan.org/vlc/last/win64/'; curl.exe -LS -o VLC.exe "$baseUrl$((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like 'vlc*.exe' } | Select-Object -First 1 -ExpandProperty Href)"
    ```

-   ### [Screenbox](https://github.com/huynhsontung/Screenbox)
-   ### [PV Photo Viewer](../Extra/pv.exe) <!-- https://github.com/davidly/PV -->

# Office

-   ### [Office 365 ProPlus](https://officecdn.microsoft.com/db/492350f6-3a01-4f97-b9c0-c7c6ddf67d60/media/en-us/O365ProPlusRetail.img) <!-- Office 365 ProPlus English US x86-64 Offline -->
    -   #### [Microsoft Activation Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)
        ###### Microsoft Activation Scripts 'Ohook' method can activate it.
    -   #### [Microsoft Activation Scripts Docs](https://massgrave.dev/office_c2r_links.html)

# Messaging

-   ### [Telegram Desktop](https://apps.microsoft.com/detail/telegram-desktop/9NZTWSQNTD0S?hl=en-in&gl=IN)

    ```ps1
    curl.exe -LS -o Telegram.exe https://telegram.org/dl/desktop/win64
    ```

    -   #### [Alternative - Portable Version](https://desktop.telegram.org)
    -   #### [Alternative - MaterialYou](https://github.com/kukuruzka165/materialgram)
        ###### Note: Recommended installation directory for linux:
        ```sh
        sudo tar -xf tsetup*.tar.xz -C /opt/
        ```

-   ### [Indirect](https://github.com/huynhsontung/Indirect)

# Miscellaneous

-   ### [7-Zip](https://www.7-zip.org)

    ```ps1
    $baseUrl = 'https://www.7-zip.org/'; curl.exe -LS -o 7-Zip.exe "$baseUrl$((Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Links | Where-Object { $_.Href -like '*x64.exe' } | Select-Object -First 1 -ExpandProperty Href)"
    ```

    -   #### [Configure 7-Zip](https://github.com/amitxv/PC-Tuning/blob/main/docs/post-install.md#install-7-zip)

-   ### [App Installer](https://apps.microsoft.com/detail/app-installer/9NBLGGH4NNS1?hl=en-in&gl=IN)
    -   #### [GitHub](https://github.com/microsoft/winget-cli/releases)
-   ### [AMD Software](https://www.amd.com/en/support/apu/amd-ryzen-processors/amd-ryzen-5-mobile-processors-radeon-vega-graphics/amd-ryzen-5-1)
    -   #### [Installation Guide](https://docs.atlasos.net/getting-started/post-installation/drivers/gpu/amd)
    -   #### [Alternative Guide](https://github.com/amitxv/PC-Tuning/blob/main/docs/configure-amd.md)
-   ### [BleachBit](https://github.com/bleachbit/bleachbit)

    ```ps1
    ((Invoke-WebRequest -Uri "https://www.bleachbit.org/download/windows" -UseBasicParsing).Links | Where-Object { $_.Href -like '*.exe' } | Select-Object -First 1 -ExpandProperty Href) -replace "/download/file/t\?file=" | ForEach-Object { curl.exe -LS -o BleachBit.exe "https://download.bleachbit.org/$_" }
    ```

    -   #### [Alternative - CleanmgrPlus](https://github.com/builtbybel/CleanmgrPlus)

-   ### [Bulk Crap Uninstaller](https://github.com/Klocman/Bulk-Crap-Uninstaller)
-   ### [Calculator](https://apps.microsoft.com/detail/windows-calculator/9WZDNCRFHVN5?hl=en-in&gl=IN) <!-- https://github.com/microsoft/calculator -->
    -   #### [Parsify Desktop](https://github.com/parsify-dev/desktop)
-   ### [ExplorerBlurMica](https://github.com/Maplespe/ExplorerBlurMica)
-   ### [~~HEIF Image Extensions~~](https://apps.microsoft.com/detail/heif-image-extensions/9PMMSR1CGPWG?hl=en-in&gl=IN)
-   ### [~~MyAsus~~](https://apps.microsoft.com/detail/myasus/9N7R5S6B0ZZH?hl=en-in&gl=IN)
-   ### [Notepad](https://apps.microsoft.com/detail/windows-notepad/9MSMLRH6LZF3)
-   ### [Obsidian](https://obsidian.md)

    ```ps1
    curl.exe -LS -o Obsidian.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest').assets | Where-Object { $_.name -like 'Obsidian.*.exe' } | Select-Object -ExpandProperty browser_download_url)[3]
    ```

-   ### [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)
    -   #### [Configure Process Explorer](https://github.com/amitxv/PC-Tuning/blob/main/docs/post-install.md#replace-task-manager-with-process-explorer)
-   ### [Proton VPN](https://protonvpn.com/download-windows)

    ```ps1
    curl.exe -LS -o ProtonVPN.exe "$((Invoke-WebRequest -Uri 'https://protonvpn.com/download-windows' -UseBasicParsing).Links | Where-Object { $_.Href -like '*.exe' } | Select-Object -First 1 -ExpandProperty Href)"
    ```

    -   #### [Installation Guide - Linux](https://protonvpn.com/support/official-linux-vpn-mint/)

-   ### [Revo Uninstaller Pro](https://www.revouninstaller.com/revo-uninstaller-free-download)

    ###### For activation, download the [revouninstallerpro5.lic](../Extra/revouninstallerpro5.lic) file and copy it to the following path: `C:\ProgramData\VS Revo Group\Revo Uninstaller Pro\`

    ```ps1
    curl.exe -LS -o 'C:\ProgramData\VS Revo Group\Revo Uninstaller Pro\revouninstallerpro5.lic' https://github.com/sakshiagrwal/Scripts/raw/dev/Windows/Extra/revouninstallerpro5.lic
    ```

-   ### [StartAllBack](https://www.startallback.com)

    ```ps1
    curl.exe -LS -o StartAllBack.exe https://www.startallback.com/download.php
    ```

    -   #### [SAB - Activation Script](https://github.com/sakshiagrwal/SAB)

-   ### [StartIsBack++](https://www.startisback.com/#download-tab)

    ```ps1
    curl.exe -LS -o StartIsBack++.exe https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe
    ```

    ###### For activation, download the [msimg32.dll](../Extra/msimg32.dll) file and copy it to the following path: `C:\Program Files (x86)\StartIsBack\`

    ```ps1
    curl.exe -LS -o 'C:\Program Files (x86)\StartIsBack\msimg32.dll' https://github.com/sakshiagrwal/Scripts/raw/dev/Windows/Extra/msimg32.dll
    ```

-   ### [Winpinator](https://winpinator.swisz.cz/download.html)

    ```ps1
    curl.exe -LS -o Winpinator.exe $((Invoke-RestMethod -Uri 'https://api.github.com/repos/swiszczoo/winpinator/releases/latest').assets | Where-Object { $_.name -like 'winpinator*x64.exe' } | Select-Object -ExpandProperty browser_download_url)
    ```

-   ### [YoutubeDownloader](https://github.com/Tyrrrz/YoutubeDownloader)

    ```ps1
    curl.exe -LS -o YoutubeDownloader.zip $((Invoke-RestMethod -Uri 'https://api.github.com/repos/Tyrrrz/YoutubeDownloader/releases/latest').assets | Where-Object { $_.name -eq 'YoutubeDownloader.zip' } | Select-Object -ExpandProperty browser_download_url)
    ```
