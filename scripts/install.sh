#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

./scripts/build-app.sh

TARGET="/Applications/FlipScroll.app"
pkill -x FlipScroll || true
rm -rf "$TARGET"
cp -R build/FlipScroll.app "$TARGET"
open "$TARGET"

echo "Installed $TARGET"
