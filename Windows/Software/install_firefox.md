# Firefox Installer Script Guide

Yeh guide aapko batayegi ki kaise aap is script ko use kar sakte hain Mozilla Firefox install karne ke liye with optional configurations.

## Script Parameters

- **`-force`**: Yeh option forcibly install karta hai Firefox agar already installed hai.
- **`-skipHashCheck`**: Yeh option hash verification ko skip karta hai download ke baad.
- **`-theme`**: Yeh option install karta hai 'Firefox Mod Blur' theme.
- **`-configs`**: Yeh option configure karta hai Firefox ko with `policies.json`, `autoconfig.js`, and `firefox.cfg`.
- **`-lang`**: Firefox installation ke liye language specify karta hai (default: "en-GB").
- **`-edition`**: Firefox edition specify karta hai (Developer, Enterprise, ya default).
- **`-version`**: Firefox version specify karta hai (agar aap specific version install karna chahte hain).

## Usage Examples

### Basic Usage

Agar aap simply Firefox install karna chahte hain without any special configurations:

```powershell
.\Script.ps1
```

### Force Install

Agar aapko forcefully Firefox install karna hai even if it's already installed:

```powershell
.\Script.ps1 -force
```

### Skip Hash Check

Agar aap hash check skip karna chahte hain:

```powershell
.\Script.ps1 -skipHashCheck
```

### Install with Theme

Agar aapko 'Firefox Mod Blur' theme install karna hai:

```powershell
.\Script.ps1 -theme
```

### Install with Configurations

Agar aap Firefox ko `policies.json`, `autoconfig.js`, aur `firefox.cfg` ke saath configure karna chahte hain:

```powershell
.\Script.ps1 -configs
```

### Install Specific Edition and Version

Agar aap specific edition (Developer ya Enterprise) ya specific version install karna chahte hain:

```powershell
.\Script.ps1 -edition Developer -version 89.0
```

### Full Command Example

Yeh ek example hai jisme sabhi options include hain:

```powershell
.\Script.ps1 -force -skipHashCheck -theme -configs -lang "en-US" -edition Enterprise -version 78.0
```

## Script Details

### Functions

- **`PauseNull`**: Yeh function script ko pause karta hai aur user input ka wait karta hai.
- **`DownloadFile`**: Yeh function specified URL se file download karta hai.
- **`VerifyHash`**: Yeh function local aur remote file hash ko verify karta hai.
- **`ConfigureFiles`**: Yeh function configuration files (`policies.json`, `autoconfig.js`, `firefox.cfg`) ko download aur place karta hai.

### Main Script Flow

1. Admin privileges check karta hai.
2. Latest Firefox version fetch karta hai JSON data se.
3. Version decide karta hai (specified ya default).
4. Firefox setup file download karta hai.
5. (Optional) Hash verification karta hai.
6. Firefox install karta hai.
7. Unnecessary files remove karta hai.
8. (Optional) Configuration files set karta hai.
9. (Optional) 'Firefox Mod Blur' theme install karta hai.
10. Release notes URL display karta hai.

## Conclusion

Yeh guide aapko script ke usage aur parameters ko samajhne mein madad karegi. Agar aapko koi additional help chahiye, feel free to reach out!
