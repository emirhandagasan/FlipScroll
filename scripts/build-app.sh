#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

swift build -c release

APP="build/FlipScroll.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp .build/release/FlipScroll "$APP/Contents/MacOS/"
cp Resources/Info.plist "$APP/Contents/"
codesign --force --sign - "$APP"

echo "Built $APP"
