# Firefox Installer Script Guide

This guide will explain how to use this script to install Mozilla Firefox with optional configurations.

## Script Parameters

- **`-force`**: This option forces the installation of Firefox even if it is already installed.
- **`-skipHashCheck`**: This option skips the hash verification after downloading.
- **`-theme`**: This option installs the 'Firefox Mod Blur' theme.
- **`-configs`**: This option configures Firefox with `policies.json`, `autoconfig.js`, and `firefox.cfg`.
- **`-lang`**: Specifies the language for the Firefox installation (default: "en-GB").
- **`-edition`**: Specifies the edition of Firefox (Developer, Enterprise, or default).
- **`-version`**: Specifies the version of Firefox (if you want to install a specific version).

## Usage Examples

### Basic Usage

If you simply want to install Firefox without any special configurations:

```powershell
irm https://raw.githubusercontent.com/Kajal4414/Scripts/dev/Windows/Software/install_firefox.ps1 | iex
```

### Force Install

If you need to forcefully install Firefox even if it's already installed:

```powershell
.\install_firefox.ps1 -force
```

### Skip Hash Check

If you want to skip the hash check:

```powershell
.\install_firefox.ps1 -skipHashCheck
```

### Install with Theme

If you want to install the 'Firefox Mod Blur' theme:

```powershell
.\install_firefox.ps1 -theme
```

### Install with Configurations

If you want to configure Firefox with `policies.json`, `autoconfig.js`, and `firefox.cfg`:

```powershell
.\install_firefox.ps1 -configs
```

### Install Specific Edition and Version

If you want to install a specific edition (Developer or Enterprise) or a specific version:

```powershell
.\install_firefox.ps1 -edition Developer -version 89.0
```

### Full Command Example

Here is an example that includes all options:

```powershell
.\install_firefox.ps1 -force -skipHashCheck -theme -configs -lang "en-US" -edition Enterprise -version 78.0
```

## Script Details

### Functions

- **`PauseNull`**: This function pauses the script and waits for user input.
- **`DownloadFile`**: This function downloads a file from a specified URL.
- **`VerifyHash`**: This function verifies the hash of the local file against the remote file.
- **`ConfigureFiles`**: This function downloads and places configuration files (`policies.json`, `autoconfig.js`, `firefox.cfg`).

### Main Script Flow

1. Checks for admin privileges.
2. Fetches the latest Firefox version from JSON data.
3. Determines the version to use (specified or default).
4. Downloads the Firefox setup file.
5. (Optional) Verifies the hash.
6. Installs Firefox.
7. Removes unnecessary files.
8. (Optional) Sets up configuration files.
9. (Optional) Installs the 'Firefox Mod Blur' theme.
10. Displays the release notes URL.

## Conclusion

This guide should help you understand the usage and parameters of the script.
