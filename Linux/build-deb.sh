#!/bin/bash
# build-deb.sh - Creates a .deb package for Linux DNS policies

PACKAGE_NAME="kmc-browser-dns-policy"
VERSION="1.0.0"
ARCH="all"

# WSL FIX: Build in Linux filesystem, not Windows mount
# Check if we're on a Windows mount point
if [[ $(pwd) == /mnt/* ]]; then
    echo "WARNING: You're building on Windows filesystem (/mnt/c/...)"
    echo "Moving to Linux filesystem for correct permissions..."

    BUILD_PATH="$HOME/deb-build"
    mkdir -p "$BUILD_PATH"
    cd "$BUILD_PATH"
    echo "Building in: $(pwd)"
fi

# Clean up any previous builds
rm -rf ${PACKAGE_NAME}_${VERSION}

# Create package structure
mkdir -p ${PACKAGE_NAME}_${VERSION}/DEBIAN
mkdir -p ${PACKAGE_NAME}_${VERSION}/etc/opt/chrome/policies/managed
mkdir -p ${PACKAGE_NAME}_${VERSION}/etc/chromium/policies/managed
mkdir -p ${PACKAGE_NAME}_${VERSION}/etc/opt/edge/policies/managed
mkdir -p ${PACKAGE_NAME}_${VERSION}/etc/brave/policies/managed
mkdir -p ${PACKAGE_NAME}_${VERSION}/etc/vivaldi/policies/managed
mkdir -p ${PACKAGE_NAME}_${VERSION}/usr/lib/firefox/distribution

# Set correct permissions for DEBIAN directory (must be 0755)
chmod 0755 ${PACKAGE_NAME}_${VERSION}/DEBIAN

# Create control file
cat > ${PACKAGE_NAME}_${VERSION}/DEBIAN/control << EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Maintainer: Kiira Motors Corporation <support@kiiramotors.com>
Description: Browser DNS Policy Configuration
 Disables DNS-over-HTTPS in Chrome, Chromium, Edge, Brave, Vivaldi, and Firefox
 to ensure browsers use the system DNS configuration.
EOF

# Chrome/Chromium policy
cat > ${PACKAGE_NAME}_${VERSION}/etc/opt/chrome/policies/managed/dns-policy.json << 'EOF'
{
  "DnsOverHttpsMode": "off",
  "BuiltInDnsClientEnabled": false
}
EOF

# Copy for Chromium
cp ${PACKAGE_NAME}_${VERSION}/etc/opt/chrome/policies/managed/dns-policy.json \
   ${PACKAGE_NAME}_${VERSION}/etc/chromium/policies/managed/

# Edge policy
cat > ${PACKAGE_NAME}_${VERSION}/etc/opt/edge/policies/managed/dns-policy.json << 'EOF'
{
  "DnsOverHttpsMode": "off",
  "BuiltInDnsClientEnabled": false
}
EOF

# Brave policy
cat > ${PACKAGE_NAME}_${VERSION}/etc/brave/policies/managed/dns-policy.json << 'EOF'
{
  "DnsOverHttpsMode": "off"
}
EOF

# Vivaldi policy
cat > ${PACKAGE_NAME}_${VERSION}/etc/vivaldi/policies/managed/dns-policy.json << 'EOF'
{
  "DnsOverHttpsMode": "off"
}
EOF

# Firefox policy
cat > ${PACKAGE_NAME}_${VERSION}/usr/lib/firefox/distribution/policies.json << 'EOF'
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

# Create postinst script to restart browsers if running
cat > ${PACKAGE_NAME}_${VERSION}/DEBIAN/postinst << 'EOF'
#!/bin/bash
set -e

echo "Browser DNS policies have been installed."
echo "Please restart your browsers for changes to take effect."

# Notify users if browsers are running
if pgrep -x "chrome" > /dev/null || pgrep -x "chromium" > /dev/null || \
   pgrep -x "firefox" > /dev/null || pgrep -x "brave" > /dev/null; then
    echo "WARNING: Browsers are currently running. Please close and restart them."
fi

exit 0
EOF

chmod 755 ${PACKAGE_NAME}_${VERSION}/DEBIAN/postinst

# Set proper permissions for all directories and files
find ${PACKAGE_NAME}_${VERSION} -type d -exec chmod 0755 {} \;
find ${PACKAGE_NAME}_${VERSION} -type f -exec chmod 0644 {} \;
# Re-apply executable permission to postinst
chmod 0755 ${PACKAGE_NAME}_${VERSION}/DEBIAN/postinst

# Build the package
dpkg-deb --build ${PACKAGE_NAME}_${VERSION}

echo "Package created: ${PACKAGE_NAME}_${VERSION}.deb"
echo "Package location: $(pwd)/${PACKAGE_NAME}_${VERSION}.deb"
echo ""
echo "To install: sudo dpkg -i ${PACKAGE_NAME}_${VERSION}.deb"
echo "To remove: sudo dpkg -r ${PACKAGE_NAME}"

# If we moved to temp location, copy back to original directory
if [[ -n "$BUILD_PATH" ]]; then
    ORIGINAL_DIR="$OLDPWD"
    if [[ -d "$ORIGINAL_DIR" ]]; then
        echo ""
        echo "Copying package back to: $ORIGINAL_DIR"
        cp ${PACKAGE_NAME}_${VERSION}.deb "$ORIGINAL_DIR/"
        echo "Done! Package is in both locations."
    fi
fi