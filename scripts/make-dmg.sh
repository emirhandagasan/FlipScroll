#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

VOLUME="FlipScroll"
if [ -e "/Volumes/$VOLUME" ]; then
    echo "Eject the $VOLUME disk first" >&2
    exit 1
fi

./scripts/build-app.sh

VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" Resources/Info.plist)
DMG="build/FlipScroll-$VERSION.dmg"
WORK="$(mktemp -d)"
STAGING="$WORK/staging"
trap 'rm -rf "$WORK"' EXIT

# The Applications link lets users install by drag and drop.
mkdir -p "$STAGING/.background"
cp -R build/FlipScroll.app "$STAGING/"
ln -s /Applications "$STAGING/Applications"

swift scripts/make-dmg-background.swift "$WORK"
tiffutil -cathidpicheck "$WORK/background.png" "$WORK/background@2x.png" \
    -out "$STAGING/.background/background.tiff"

# Finder saves the layout only on a writable disk, so convert it afterwards.
hdiutil create -volname "$VOLUME" -srcfolder "$STAGING" -fs HFS+ -format UDRW "$WORK/rw.dmg"
hdiutil attach "$WORK/rw.dmg" -noverify -noautoopen

osascript <<EOF
tell application "Finder"
    tell disk "$VOLUME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set bounds of container window to {200, 120, 860, 557}
        set viewOptions to icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 128
        set background picture of viewOptions to file ".background:background.tiff"
        set position of item "FlipScroll.app" of container window to {165, 190}
        set position of item "Applications" of container window to {495, 190}
        update without registering applications
        delay 2
        close
    end tell
end tell
EOF

sync

# Finder or Spotlight can keep the disk busy for a moment.
for ATTEMPT in 1 2 3 4 5 6 7 8 9 10; do
    hdiutil detach "/Volumes/$VOLUME" && break
    if [ "$ATTEMPT" = 10 ]; then
        exit 1
    fi
    sleep 2
done

rm -f "$DMG"
hdiutil convert "$WORK/rw.dmg" -format UDZO -o "$DMG"

echo "Created $DMG"
