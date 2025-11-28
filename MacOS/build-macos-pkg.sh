#!/bin/bash
# build-macos-pkg.sh - Creates a .pkg installer for macOS DNS policies

PACKAGE_NAME="KMC-Browser-DNS-Policy"
VERSION="1.0.0"
IDENTIFIER="com.kiiramotors.browser-dns-policy"

# Create temporary directories
BUILD_DIR="build"
PAYLOAD_DIR="${BUILD_DIR}/payload"
SCRIPTS_DIR="${BUILD_DIR}/scripts"

rm -rf ${BUILD_DIR}
mkdir -p ${PAYLOAD_DIR}
mkdir -p ${SCRIPTS_DIR}

# Create policy directories for macOS
mkdir -p "${PAYLOAD_DIR}/Library/Google/Chrome/policies"
mkdir -p "${PAYLOAD_DIR}/Library/Application Support/Google/Chrome/External Extensions"
mkdir -p "${PAYLOAD_DIR}/Library/Microsoft/Edge/policies"
mkdir -p "${PAYLOAD_DIR}/Library/Application Support/BraveSoftware/Brave-Browser/policies"
mkdir -p "${PAYLOAD_DIR}/Library/Application Support/Vivaldi/policies"
mkdir -p "${PAYLOAD_DIR}/Library/Application Support/Mozilla/Firefox/distribution"

# Chrome policy (managed plist)
cat > "${PAYLOAD_DIR}/Library/Google/Chrome/policies/dns-policy.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>DnsOverHttpsMode</key>
    <string>off</string>
    <key>BuiltInDnsClientEnabled</key>
    <false/>
</dict>
</plist>
EOF

# Edge policy
cat > "${PAYLOAD_DIR}/Library/Microsoft/Edge/policies/dns-policy.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>DnsOverHttpsMode</key>
    <string>off</string>
    <key>BuiltInDnsClientEnabled</key>
    <false/>
</dict>
</plist>
EOF

# Brave policy
cat > "${PAYLOAD_DIR}/Library/Application Support/BraveSoftware/Brave-Browser/policies/dns-policy.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>DnsOverHttpsMode</key>
    <string>off</string>
</dict>
</plist>
EOF

# Vivaldi policy
cat > "${PAYLOAD_DIR}/Library/Application Support/Vivaldi/policies/dns-policy.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>DnsOverHttpsMode</key>
    <string>off</string>
</dict>
</plist>
EOF

# Firefox policy (JSON format, same as Linux)
cat > "${PAYLOAD_DIR}/Library/Application Support/Mozilla/Firefox/distribution/policies.json" << 'EOF'
{
  "policies": {
    "DNSOverHTTPS": {
      "Enabled": false,
      "Locked": true
    },
    "NetworkPrediction": {
      "Value": false
    }
  }
}
EOF

# Create postinstall script
cat > "${SCRIPTS_DIR}/postinstall" << 'EOF'
#!/bin/bash

echo "Browser DNS policies have been installed system-wide."
echo ""
echo "The following browsers will now use system DNS configuration:"
echo "  - Google Chrome"
echo "  - Microsoft Edge"
echo "  - Brave Browser"
echo "  - Vivaldi"
echo "  - Mozilla Firefox"
echo ""
echo "Please restart any running browsers for changes to take effect."

# Set proper permissions
chmod -R 755 "/Library/Google/Chrome/policies" 2>/dev/null || true
chmod -R 755 "/Library/Microsoft/Edge/policies" 2>/dev/null || true
chmod -R 755 "/Library/Application Support/BraveSoftware/Brave-Browser/policies" 2>/dev/null || true
chmod -R 755 "/Library/Application Support/Vivaldi/policies" 2>/dev/null || true
chmod -R 755 "/Library/Application Support/Mozilla/Firefox/distribution" 2>/dev/null || true

# Notify logged-in users
/usr/bin/osascript -e 'display notification "Please restart your browsers to apply DNS policy changes." with title "Browser DNS Policy Installed"' || true

exit 0
EOF

chmod +x "${SCRIPTS_DIR}/postinstall"

# Build the package using pkgbuild
pkgbuild --root "${PAYLOAD_DIR}" \
         --scripts "${SCRIPTS_DIR}" \
         --identifier "${IDENTIFIER}" \
         --version "${VERSION}" \
         --install-location "/" \
         "${PACKAGE_NAME}-${VERSION}.pkg"

echo "Package created: ${PACKAGE_NAME}-${VERSION}.pkg"
echo ""
echo "To install: sudo installer -pkg ${PACKAGE_NAME}-${VERSION}.pkg -target /"
echo "To remove: Use a third-party uninstaller or manually remove policy files"

# Clean up
rm -rf ${BUILD_DIR}