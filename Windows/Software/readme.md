<div align="center">

# 🖥️ Windows Setup & Configuration Guide

> A curated collection of software, scripts, and configuration files for setting up a productive Windows development environment.

[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-0078D6?style=flat-square&logo=windows)](https://www.microsoft.com/windows)
[![Shell](https://img.shields.io/badge/Shell-PowerShell-5391FE?style=flat-square&logo=powershell)](https://github.com/PowerShell/PowerShell)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

</div>

---

## 📋 Table of Contents

- [🌐 Browsers](#-browsers)
- [🧑‍💻 Code Editors & IDEs](#-code-editors--ides)
- [🛠️ Development Tools](#️-development-tools)
- [⚙️ Runtimes & Redistributables](#️-runtimes--redistributables)
- [⬇️ Download Managers](#️-download-managers)
- [🎬 Media Players & Viewers](#-media-players--viewers)
- [📁 Office Suite](#-office-suite)
- [💬 Messaging](#-messaging)
- [🔧 Miscellaneous Utilities](#-miscellaneous-utilities)
  - [ASUS Battery Threshold Configuration](#asus-battery-threshold-configuration)
- [🐧 Linux Notes](#-linux-notes)

---

## 🌐 Browsers

### Firefox

| Resource | Link |
|----------|------|
| Official Download | [Mozilla Firefox](https://www.mozilla.org/en-US/firefox/all/#product-desktop-release) |
| UI Customization | [Firefox Mod Blur](https://github.com/datguypiko/Firefox-Mod-Blur) |

**Quick Install (PowerShell — run as Administrator):**

> ⚠️ **Note:** Run PowerShell or Terminal as Administrator. Do **not** use CMD.

```powershell
# Step 1 – Download the installer script
curl.exe -LSs "https://raw.githubusercontent.com/Kajal4414/Scripts/main/Windows/Software/install_firefox.ps1" `
  -o "$env:USERPROFILE\Desktop\install_firefox.ps1"

# Step 2 – Execute and clean up
cd "$env:USERPROFILE\Desktop"; .\install_firefox.ps1 -theme -configs; Remove-Item .\install_firefox.ps1
```

> 💡 **Tip:** If you encounter an execution policy error, run the following before Step 2:
> ```powershell
> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
> ```

---

### Google Chrome

| Resource | Link |
|----------|------|
| Official Download | [Google Chrome (Standalone)](https://www.google.com/intl/en/chrome/?standalone=1) |
| Theme | [Catppuccin Mocha](https://chromewebstore.google.com/detail/catppuccin-chrome-theme-m/bkkmolkhemgaeaeggcmfbghljjjoofoh) |

---

## 🧑‍💻 Code Editors & IDEs

### Visual Studio Code

| Resource | Link |
|----------|------|
| Official Download | [VS Code](https://code.visualstudio.com/download) |
| Open-Source Alternative | [VSCodium](https://github.com/VSCodium/vscodium) |

**Apply Custom Settings:**

```powershell
curl.exe -LSs "https://raw.githubusercontent.com/Kajal4414/Scripts/main/Windows/C/Users/Admin/AppData/Roaming/Code/User/settings.json" `
  -o "$env:APPDATA\Code\User\settings.json"
```

**Install Extensions:**

```powershell
irm https://raw.githubusercontent.com/Kajal4414/Scripts/main/Windows/Software/install_code_extensions.ps1 | iex
```

---

### IntelliJ IDEA

| Resource | Link |
|----------|------|
| Official Download | [IntelliJ IDEA](https://www.jetbrains.com/idea/download/?section=windows) |

**Linux Installation:**

```sh
sudo tar -xzf ideaIC-*.tar.gz -C /opt    # Recommended installation path
sudo sh /opt/idea-*/bin/idea.sh          # Run as root to support updates
```

---

### PyCharm

| Resource | Link |
|----------|------|
| Official Download | [PyCharm](https://www.jetbrains.com/pycharm/download/?section=windows) |

**Linux Installation:**

```sh
sudo tar -xzf pycharm-*.tar.gz -C /opt
sudo sh /opt/pycharm-*/bin/pycharm.sh
```

---

### Notepad++

| Resource | Link |
|----------|------|
| Official Download | [Notepad++](https://github.com/notepad-plus-plus/notepad-plus-plus) |
| Catppuccin Theme | [catppuccin-mocha.xml](https://github.com/catppuccin/notepad-plus-plus/blob/main/catppuccin-mocha.xml) |
| Twilight Theme | [Twilight.xml](https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/PowerEditor/installer/themes/Twilight.xml) |

---

### Terminal & Shell

| Tool | Link |
|------|------|
| [Windows Terminal](https://github.com/microsoft/terminal) | Modern tabbed terminal for Windows |
| [Oh My Posh](https://github.com/jandedobbeleer/oh-my-posh) | Prompt theme engine |

> 📖 Oh My Posh Installation Guide: [Windows Setup](https://ohmyposh.dev/docs/installation/windows)

---

## 🛠️ Development Tools

| Tool | Link | Notes |
|------|------|-------|
| [Git](https://git-scm.com) | Version control | — |
| [Gpg4win](https://www.gpg4win.org) | GPG encryption for Windows | — |
| [JDK – Adoptium](https://adoptium.net/) | Java Development Kit | ✅ Recommended over Oracle JDK |
| ~~[JDK – Oracle](https://www.oracle.com/in/java/technologies/downloads/)~~ | Oracle JDK | ⚠️ Not recommended |
| [Node.js](https://nodejs.org/en) | JavaScript runtime | — |
| [Python](https://www.python.org/downloads) | Python interpreter | — |
| [Platform Tools](https://developer.android.com/tools/releases/platform-tools) | ADB, Fastboot, etc. | — |
| [APK Tool](https://github.com/iBotPeaches/Apktool) | APK reverse engineering | — |

---

### Platform Tools

```powershell
irm https://raw.githubusercontent.com/Kajal4414/Scripts/main/Windows/Software/install_platform_tools.ps1 | iex
```

---

### APK Tool

| Resource | Link |
|----------|------|
| GitHub | [iBotPeaches/Apktool](https://github.com/iBotPeaches/Apktool) |
| Downloads | [Bitbucket Releases](https://bitbucket.org/iBotPeaches/apktool/downloads/) |

```powershell
irm https://raw.githubusercontent.com/Kajal4414/Scripts/main/Windows/Software/Install_apk_tool.ps1 | iex
```

---

### JDK – Adoptium Troubleshooting

<details>
<summary>🔧 <strong>Error Code 2503 – Fix</strong></summary>

**Method 1 – Run the installer with elevated privileges:**

```powershell
msiexec /i "C:\Users\YourName\Downloads\OpenJDK25U-jdk_x64_windows_hotspot_25.0.3_9.msi"
```

**Method 2 – Fix Temp folder permissions:**

```powershell
icacls "C:\Windows\Temp" /grant "%USERNAME%":F
```

</details>

---

## ⚙️ Runtimes & Redistributables

| Package | Link |
|---------|------|
| [Visual C++ Redistributables](https://github.com/abbodi1406/vcredist) | All-in-one VC++ redist |
| [DirectX Redistributable](https://www.microsoft.com/en-gb/download/details.aspx?id=8109) | DirectX end-user runtime |
| [Microsoft Edge WebView2](https://developer.microsoft.com/en-us/microsoft-edge/webview2) | WebView2 runtime |

---

## ⬇️ Download Managers

| Tool | Link | Notes |
|------|------|-------|
| [Internet Download Manager](https://www.internetdownloadmanager.com) | IDM | Paid; trial reset available |
| [Free Download Manager](https://www.freedownloadmanager.org) | FDM | Free alternative |
| [qBittorrent](https://www.qbittorrent.org) | qBittorrent | Open-source torrent client |

**IDM Trial Reset:**

> ⚠️ The [IDM Activation Script](https://github.com/WindowsAddict/IDM-Activation-Script) is deprecated. Use [IDM Trial Reset](https://github.com/J2TEAM/idm-trial-reset) instead.

---

## 🎬 Media Players & Viewers

| Tool | Link | Notes |
|------|------|-------|
| [K-Lite Codec Pack](https://codecguide.com/download_k-lite_codec_pack_full.htm) | Codec bundle | Full edition recommended |
| [VLC Media Player](https://www.videolan.org) | VLC | Universal media player |
| [Screenbox](https://github.com/huynhsontung/Screenbox) | Screenbox | Modern UWP media player |
| [MPV](https://github.com/mpv-player/mpv) | MPV | Minimalist, highly configurable |
| [PV Photo Viewer](../Extra/pv.exe) | PV | Lightweight image viewer |

**MPV Quick Install:**

```powershell
irm https://raw.githubusercontent.com/Kajal4414/Scripts/main/Windows/Software/install_mpv.ps1 | iex
```

---

## 📁 Office Suite

### Microsoft Office 365 ProPlus

| Resource | Link |
|----------|------|
| Offline Installer (EN-US x64) | [O365ProPlusRetail.img](https://officecdn.microsoft.com/db/492350f6-3a01-4f97-b9c0-c7c6ddf67d60/media/en-us/O365ProPlusRetail.img) |
| Activation (Ohook method) | [Microsoft Activation Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts) |
| Office C2R Download Links | [MAS Docs](https://massgrave.dev/office_c2r_links.html) |

> 💡 Use the **Ohook** method from Microsoft Activation Scripts for activation.

---

## 💬 Messaging

### Telegram Desktop

| Resource | Link |
|----------|------|
| Official Release | [tdesktop Releases](https://github.com/telegramdesktop/tdesktop/releases/latest) |
| Material You Fork | [materialgram](https://github.com/kukuruzka165/materialgram) |

**Linux Installation:**

```sh
sudo tar -xf tsetup*.tar.xz -C /opt
```

---

### Instagram DMs

| Tool | Link |
|------|------|
| [Indirect](https://github.com/huynhsontung/Indirect) | Unofficial Instagram DM client for Windows |

---

## 🔧 Miscellaneous Utilities

| Tool | Link | Description |
|------|------|-------------|
| [7-Zip](https://www.7-zip.org) | Archive manager | — |
| [App Installer / WinGet](https://apps.microsoft.com/detail/app-installer/9NBLGGH4NNS1) | Package manager | [CLI Releases](https://github.com/microsoft/winget-cli/releases) |
| [AMD Software](https://www.amd.com/en/support/apu/amd-ryzen-processors/amd-ryzen-5-mobile-processors-radeon-vega-graphics/amd-ryzen-5-1) | GPU drivers | See [Atlas Docs](https://docs.atlasos.net/getting-started/post-installation/drivers/amd/#configure-radeon-software) |
| [BleachBit](https://github.com/bleachbit/bleachbit) | System cleaner | Alt: [CleanmgrPlus](https://github.com/builtbybel/CleanmgrPlus) |
| [Bulk Crap Uninstaller](https://github.com/Klocman/Bulk-Crap-Uninstaller) | Batch uninstaller | — |
| [Windows Calculator](https://apps.microsoft.com/detail/windows-calculator/9WZDNCRFHVN5) | Calculator | Alt: [Parsify Desktop](https://github.com/parsify-dev/desktop) |
| [ExplorerBlurMica](https://github.com/Maplespe/ExplorerBlurMica) | Explorer blur effect | — |
| [HEIF Image Extensions](https://apps.microsoft.com/detail/heif-image-extensions/9PMMSR1CGPWG) | HEIC/HEIF support | — |
| [Notepad](https://apps.microsoft.com/detail/windows-notepad/9MSMLRH6LZF3) | Windows Notepad | — |
| [Obsidian](https://obsidian.md) | Markdown knowledge base | — |
| [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer) | Advanced task manager | [Config Guide](https://github.com/amitxv/PC-Tuning/blob/main/docs/post-install.md#replace-task-manager-with-process-explorer) |
| [Proton VPN](https://protonvpn.com/download-windows) | VPN client | — |
| [Revo Uninstaller Pro](https://www.revouninstaller.com/revo-uninstaller-free-download) | Advanced uninstaller | See activation below |
| [StartAllBack](https://www.startallback.com) | Start menu replacement | [Activation Script](https://github.com/sakshiagrwal/SAB) |
| [StartIsBack++](https://www.startisback.com/#download-tab) | Start menu replacement | See activation below |
| [Winpinator](https://winpinator.swisz.cz/download.html) | Warpinator for Windows | — |
| [YoutubeDownloader](https://github.com/Tyrrrz/YoutubeDownloader) | YouTube video downloader | — |

---

### Revo Uninstaller Pro — Activation

Copy the license file to the application data directory:

```powershell
# Copy the license file from ../Extra/
Copy-Item "revouninstallerpro5.lic" -Destination "C:\ProgramData\VS Revo Group\Revo Uninstaller Pro\"
```

---

### StartIsBack++ — Activation

Copy the DLL file to the installation directory:

```powershell
# Copy the DLL from ../Extra/
Copy-Item "msimg32.dll" -Destination "C:\Program Files (x86)\StartIsBack\"
```

---

### ASUS Battery Threshold Configuration

<details>
<summary>⚡ <strong>Set Battery Charging Threshold to 60% (Without MyASUS App)</strong></summary>

**Prerequisites:** Install the [ASUS System Control Interface](https://www.asus.com/support/Download-Center/) driver.

**Method 1 — Command Prompt (Administrator):**

```cmd
reg add "HKLM\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys" /v ChargingRate /t REG_DWORD /d 60 /f
```

**Method 2 — Registry Editor (Manual):**

1. Navigate to: `HKLM\SOFTWARE\ASUS\ASUS System Control Interface\AsusOptimization\ASUS Keyboard Hotkeys`
2. Select or create `ChargingRate`
3. Set value: `3C` (Hex) or `60` (Decimal)

**Method 3 — PowerShell Script:**

Use the pre-built script at [`../Extra/charging_threshold.ps1`](../Extra/charging_threshold.ps1).

</details>

<details>
<summary>🔧 <strong>ASUS Services Management</strong></summary>

**List all ASUS services:**

```powershell
Get-Service | Where-Object { $_.Name -like "*ASUS*" }
```

**Full list of ASUS services:**

| Service Name | Description |
|---|---|
| `AsusAppService` | ASUS application service |
| `ASUSLinkNear` | Local device linking |
| `ASUSLinkRemote` | Remote device linking |
| `ASUSSoftwareManager` | Software update manager |
| `ASUSSwitch` | Device switching |
| `ASUSSystemAnalysis` | System diagnostics |
| `ASUSSystemDiagnosis` | Hardware diagnostics |

**Disable all ASUS services except `ASUSOptimization`:**

```powershell
Set-Service -Name "AsusAppService"       -StartupType Disabled
Set-Service -Name "ASUSLinkNear"         -StartupType Disabled
Set-Service -Name "ASUSLinkRemote"       -StartupType Disabled
Set-Service -Name "ASUSSoftwareManager"  -StartupType Disabled
Set-Service -Name "ASUSSwitch"           -StartupType Disabled
Set-Service -Name "ASUSSystemAnalysis"   -StartupType Disabled
Set-Service -Name "ASUSSystemDiagnosis"  -StartupType Disabled
```

**Restart the ASUS Optimization service:**

```powershell
Restart-Service "ASUSOptimization"
```

</details>

---

## 🐧 Linux Notes

### YoutubeDownloader — .NET Runtime on Linux Mint (Debian 12)

```sh
# Add Microsoft package repository
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Install .NET SDK (optional)
sudo apt update && sudo apt install -y dotnet-sdk-8.0
dotnet --list-sdks

# Install ASP.NET Core Runtime (required)
sudo apt update && sudo apt install -y aspnetcore-runtime-8.0
dotnet --list-runtimes

# Launch YoutubeDownloader
cd YoutubeDownloader/
./YoutubeDownloader
```

### Proton VPN — Linux Mint

> 📖 See the [official Linux installation guide](https://protonvpn.com/support/official-linux-vpn-mint/).

---

<div align="center">

---

*Maintained by [Kajal4414](https://github.com/Kajal4414) · Contributions welcome via pull request*

</div>
