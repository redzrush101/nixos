#!/usr/bin/env bash
set -euo pipefail

# Get the directory of the script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$DIR/default.nix"

# Fetch latest version and integrity from npm
METADATA=$(curl -s https://registry.npmjs.org/@iflow-ai/iflow-cli/latest)
VERSION=$(echo "$METADATA" | jq -r .version)
INTEGRITY=$(echo "$METADATA" | jq -r .dist.integrity)

echo "Latest version: $VERSION"
echo "Integrity hash: $INTEGRITY"

# Update default.nix
sed -i "s/version = \".*\";/version = \"$VERSION\";/" "$DEFAULT_NIX"
sed -i "s/hash = \".*\";/hash = \"$INTEGRITY\";/" "$DEFAULT_NIX"

echo "Successfully updated $DEFAULT_NIX"
