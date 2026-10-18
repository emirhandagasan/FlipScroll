#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

./scripts/build-app.sh

VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" Resources/Info.plist)
DMG="build/FlipScroll-$VERSION.dmg"

# The Applications link lets users install by drag and drop.
STAGING="$(mktemp -d)"
cp -R build/FlipScroll.app "$STAGING/"
ln -s /Applications "$STAGING/Applications"

rm -f "$DMG"
hdiutil create -volname FlipScroll -srcfolder "$STAGING" -format UDZO "$DMG"
rm -rf "$STAGING"

echo "Created $DMG"
