# Browser DNS Policy Installer

A cross-platform installer that configures web browsers to use system DNS settings by disabling DNS-over-HTTPS (DoH). This ensures network administrators can enforce DNS policies, enable content filtering, and resolve internal DNS names properly.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Release](https://img.shields.io/github/v/release/Kiira-Motors-Corporation/browser-dns-policy)](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases/latest)

## 📥 Download

**Latest Release:** [v1.0.0](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases/latest)

| Platform | Download | Status |
|----------|----------|--------|
| Windows (11) | [BrowserDNSInstaller.msi](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases/download/v1.0.0/BrowserDNSInstaller.msi) | ✅ Tested |
| Ubuntu/Debian | [kmc-browser-dns-policy_1.0.0.deb](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases/download/v1.0.0/kmc-browser-dns-policy_1.0.0.deb) | ⚠️ Untested |
| RHEL/CentOS/Fedora | [kmc-browser-dns-policy-1.0.0-1.noarch.rpm](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases/download/v1.0.0/kmc-browser-dns-policy-1.0.0-1.noarch.rpm) | ⚠️ Untested |
| macOS | Not yet available | 🚧 Coming soon |

**Note:** The Windows installer has been tested on Windows 11. Linux and macOS installers are provided but have not been tested yet. Feedback welcome!

---

## Overview

This installer automatically configures popular web browsers to trust and use the operating system's DNS server configuration instead of using their built-in DNS-over-HTTPS features.

**Supported Browsers**:
- Google Chrome
- Microsoft Edge
- Mozilla Firefox
- Brave Browser
- Vivaldi
- Opera (Windows only)
- Chromium (Linux only)

**Supported Platforms**:
- Windows (10/11, Server 2016+) - ✅ Tested on Windows 11
- Linux (Debian/Ubuntu, Red Hat/CentOS/Fedora) - ⚠️ Untested
- macOS (10.15+) - 🚧 Coming soon

---

## Installation Instructions

### Windows Installation

**File**: [BrowserDNSInstaller.msi](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases/download/v1.0.0/BrowserDNSInstaller.msi)

**Tested on:** Windows 11 ✅

#### Standard Installation
1. Download [BrowserDNSInstaller.msi](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases/download/v1.0.0/BrowserDNSInstaller.msi)
2. Double-click the file
3. Click "Next" through the installation wizard
4. Restart your browsers (Chrome, Edge, Brave, Opera, Vivaldi, Firefox)

#### Command Line Installation
Open Command Prompt as Administrator and run:
```cmd
msiexec /i BrowserDNSInstaller.msi /qn
```

#### Uninstallation
- **Via Control Panel**: Settings → Apps → KMC Browser DNS Policy → Uninstall
- **Via Command Line**:
  ```cmd
  msiexec /x BrowserDNSInstaller.msi /qn
  ```

---

### Linux Installation

**⚠️ Note:** Linux installers have not been tested yet. Feedback and testing reports are welcome!

#### Debian/Ubuntu (.deb)

**File**: [kmc-browser-dns-policy_1.0.0.deb](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases/download/v1.0.0/kmc-browser-dns-policy_1.0.0.deb)

**Installation**:
```bash
sudo dpkg -i kmc-browser-dns-policy_1.0.0.deb
```

**Uninstallation**:
```bash
sudo dpkg -r kmc-browser-dns-policy
```

#### Red Hat/CentOS/Fedora (.rpm)

**File**: [kmc-browser-dns-policy-1.0.0-1.noarch.rpm](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases/download/v1.0.0/kmc-browser-dns-policy-1.0.0-1.noarch.rpm)

**Installation**:
```bash
sudo rpm -i kmc-browser-dns-policy-1.0.0-1.noarch.rpm
```

**Uninstallation**:
```bash
sudo rpm -e kmc-browser-dns-policy
```

**Note**: After installation, restart your browsers (Chrome, Chromium, Edge, Brave, Vivaldi, Firefox) for changes to take effect.

---

### macOS Installation

**🚧 Coming Soon:** The macOS installer is currently under development and not yet available.

Check the [releases page](https://github.com/Kiira-Motors-Corporation/browser-dns-policy/releases) for updates.

---

## Verification

After installation, verify that policies are applied:

### Chrome/Edge/Brave/Vivaldi
1. Open your browser
2. Navigate to: `chrome://policy` (or `edge://policy`, `brave://policy`, etc.)
3. Look for `DnsOverHttpsMode` with value "off"
4. The source should show "Machine" or "Platform"

### Firefox
1. Open Firefox
2. Navigate to: `about:policies`
3. Look for `DNSOverHTTPS` showing as disabled

---

## Building from Source

### Prerequisites

#### Windows
- WiX Toolset v6.0.2 or later
- Windows 10/11 or Windows Server

#### Linux
- `dpkg-deb` (pre-installed on Debian/Ubuntu)
- For RPM: `alien` package converter
- Basic build tools

#### macOS
- Xcode Command Line Tools
- `pkgbuild` (pre-installed on macOS)

---

### Build Instructions

#### Windows Build

**Location**: `Windows/` folder

**Files**:
- `Product.wxs` - WiX configuration file
- `firefox-policies.json` - Firefox policy configuration

**Build Steps**:
```cmd
cd Windows
wix build Product.wxs -ext WixToolset.Util.wixext -o BrowserDNSInstaller.msi
```

**Output**: `BrowserDNSInstaller.msi`

---

#### Linux Build

**Location**: `Linux/` folder

**Files**:
- `build-deb.sh` - Build script for Debian/Ubuntu package

**Build Steps for .deb**:

⚠️ **Important for WSL Users**: Do not build on Windows filesystem (`/mnt/c/...`). The script will automatically use Linux filesystem.

```bash
cd Linux
chmod +x build-deb.sh
./build-deb.sh
```

**Output**: `kmc-browser-dns-policy_1.0.0.deb`

**Build Steps for .rpm** (from .deb):

If you need an RPM package:
```bash
# Install alien converter
sudo apt-get install alien

# Convert .deb to .rpm
sudo alien -r kmc-browser-dns-policy_1.0.0.deb
```

**Output**: `kmc-browser-dns-policy-1.0.0-1.noarch.rpm`

---

#### macOS Build

**🚧 Status:** macOS installer not yet available

**Location**: `MacOS/` folder

**Files**:
- `build-macos-pkg.sh` - Build script for macOS package

**Build Steps** (must be run on macOS):
```bash
cd MacOS
chmod +x build-macos-pkg.sh
./build-macos-pkg.sh
```

**Output**: `KMC-Browser-DNS-Policy-1.0.0.pkg`

**Note:** Build script is provided but the installer has not been built or tested yet.

---

## Policy Locations by Platform

### Windows
Policies are stored in the Windows Registry at:
- `HKLM\SOFTWARE\Policies\Google\Chrome`
- `HKLM\SOFTWARE\Policies\Microsoft\Edge`
- `HKLM\SOFTWARE\Policies\BraveSoftware\Brave`
- `HKLM\SOFTWARE\Policies\Vivaldi`
- `HKLM\SOFTWARE\Policies\Opera Software\Opera Stable`

### Linux
Policy files are stored at:
- **Chrome/Chromium**: `/etc/opt/chrome/policies/managed/dns-policy.json`
- **Edge**: `/etc/opt/edge/policies/managed/dns-policy.json`
- **Brave**: `/etc/brave/policies/managed/dns-policy.json`
- **Vivaldi**: `/etc/vivaldi/policies/managed/dns-policy.json`
- **Firefox**: `/usr/lib/firefox/distribution/policies.json`

### macOS
Policy files are stored at:
- **Chrome**: `/Library/Google/Chrome/policies/dns-policy.plist`
- **Edge**: `/Library/Microsoft/Edge/policies/dns-policy.plist`
- **Brave**: `/Library/Application Support/BraveSoftware/Brave-Browser/policies/dns-policy.plist`
- **Vivaldi**: `/Library/Application Support/Vivaldi/policies/dns-policy.plist`
- **Firefox**: `/Library/Application Support/Mozilla/Firefox/distribution/policies.json`

---

## Enterprise Deployment

### Windows Group Policy
1. Open Group Policy Management Console
2. Create or edit a GPO
3. Navigate to: Computer Configuration → Policies → Software Settings → Software Installation
4. Right-click → New → Package
5. Select `BrowserDNSInstaller.msi`

### Linux Configuration Management
Use tools like Ansible, Puppet, Chef, or SaltStack:

**Example Ansible playbook**:
```yaml
- name: Install Browser DNS Policy
  apt:
    deb: /path/to/kmc-browser-dns-policy_1.0.0.deb
  when: ansible_os_family == "Debian"
```

### macOS MDM Deployment
Deploy via:
- Jamf Pro
- Munki
- Apple Business Manager
- Other MDM solutions

---

## Troubleshooting

### Policies Not Applied
1. Verify installation completed successfully
2. **Restart your browser** (close ALL browser windows)
3. Check the browser's policy page:
   - Chrome/Edge: `chrome://policy` or `edge://policy`
   - Firefox: `about:policies`
4. Check file/registry permissions

### Linux Build Issues
**Problem**: `control directory has bad permissions 777`

**Solution**: If using WSL, the build script automatically handles this. If issues persist:
```bash
# Build in Linux filesystem, not Windows mount
cd ~
cp /mnt/c/path/to/Linux/build-deb.sh .
./build-deb.sh
```

### Firefox Policies Not Working
- Verify `policies.json` is in the correct location
- Check file permissions: `ls -la /path/to/policies.json`
- Validate JSON syntax: `cat policies.json | python -m json.tool`

### macOS SIP Issues
If System Integrity Protection blocks policies:
- Policies in `/Library` should not be affected by SIP
- Verify file ownership: `ls -la /Library/Google/Chrome/policies/`
- Files should be owned by `root:wheel`

---

## What This Software Does

This installer configures popular web browsers to disable DNS-over-HTTPS (DoH) and use your system's DNS configuration instead. This ensures:

- Network administrators can enforce DNS policies
- Content filtering works correctly
- Internal DNS names resolve properly
- DNS traffic goes through your organization's DNS servers

---

## Repository Structure

```
.
├── Windows/
│   ├── Product.wxs
│   ├── firefox-policies.json
│   └── BrowserDNSInstaller.msi
├── Linux/
│   ├── build-deb.sh
│   ├── kmc-browser-dns-policy_1.0.0.deb
│   └── kmc-browser-dns-policy-1.0.0-1.noarch.rpm
├── MacOS/
│   ├── build-macos-pkg.sh
│   └── KMC-Browser-DNS-Policy-1.0.0.pkg
├── LICENSE
└── README.md
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### What This Means

- ✅ Free to use for any purpose (personal, commercial, educational)
- ✅ Free to modify and distribute
- ✅ Can be included in proprietary software
- ⚠️ Must include the original copyright notice
- ⚠️ Provided "as-is" without warranty

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## Support

For issues or questions:
- **GitHub Issues**: Report bugs or request features
- **Email**: support@kiiramotors.com
- **Documentation**: Check the browser's policy page to verify policies are loaded

---

## Acknowledgments

- Built with [WiX Toolset](https://wixtoolset.org/) for Windows installers
- Firefox policy configuration based on [Mozilla's Enterprise Policy Documentation](https://mozilla.github.io/policy-templates/)
- Chromium-based browser policies based on [Chromium Enterprise Policy List](https://chromeenterprise.google/policies/)

---

## Copyright

Copyright (c) 2025 Kiira Motors Corporation

---

## Changelog

### Version 1.0.0 (2025-11-28)
- Initial release
- ✅ Windows support (tested on Windows 11)
- ⚠️ Linux support (untested - .deb and .rpm packages available)
- 🚧 macOS support (coming soon)
- Support for Chrome, Edge, Firefox, Brave, Vivaldi, Opera, Chromium
- Cross-platform DNS policy enforcement