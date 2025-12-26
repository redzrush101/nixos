#!/usr/bin/env bash

set -euo pipefail

# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PACKAGE_FILE="$DIR/default.nix"

# Fetch latest release from GitHub API
LATEST_RELEASE=$(curl -s https://api.github.com/repos/nab138/iloader/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | jq -r .tag_name | sed 's/^v//')

CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_FILE")

if [ "$LATEST_VERSION" == "$CURRENT_VERSION" ]; then
    echo "iloader is already at the latest version ($CURRENT_VERSION)"
    exit 0
fi

echo "Updating iloader from $CURRENT_VERSION to $LATEST_VERSION..."

# Download the .deb to calculate the hash
TEMP_DEB=$(mktemp)
DEB_URL="https://github.com/nab138/iloader/releases/download/v${LATEST_VERSION}/iloader-linux-amd64.deb"

echo "Downloading $DEB_URL..."
curl -L -o "$TEMP_DEB" "$DEB_URL"

NEW_HASH=$(sha256sum "$TEMP_DEB" | cut -d ' ' -f 1)
rm "$TEMP_DEB"

# Update the file
sed -i "s/version = \".*\";/version = \"$LATEST_VERSION\";/" "$PACKAGE_FILE"
sed -i "s/sha256 = \".*\";/sha256 = \"$NEW_HASH\";/" "$PACKAGE_FILE"

echo "Successfully updated iloader to $LATEST_VERSION with hash $NEW_HASH"
