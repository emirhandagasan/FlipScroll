#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Build for Apple Silicon and Intel, then merge into one binary.
for ARCH in arm64 x86_64; do
    swift build -c release --triple "$ARCH-apple-macosx13.0"
done

APP="build/FlipScroll.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
lipo -create \
    .build/arm64-apple-macosx/release/FlipScroll \
    .build/x86_64-apple-macosx/release/FlipScroll \
    -output "$APP/Contents/MacOS/FlipScroll"
cp Resources/Info.plist "$APP/Contents/"
cp Resources/AppIcon.icns "$APP/Contents/Resources/"
codesign --force --sign - "$APP"

echo "Built $APP"
