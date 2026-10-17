# FlipScroll

A small macOS menu bar app that lets the mouse and the trackpad scroll in different directions.

Keep "Natural scrolling" on in System Settings, and FlipScroll reverses only the mouse wheel.

## Requirements

- macOS 13 or later
- Swift 5.9 or later (Xcode or Command Line Tools)

## Build

```bash
./scripts/build-app.sh
open build/FlipScroll.app
```

On first launch, allow FlipScroll in **System Settings → Privacy & Security → Accessibility**.

## Menu

- **Enabled**: turns all reversing on or off
- **Reverse Mouse**: reverses the mouse wheel
- **Reverse Trackpad**: reverses the trackpad
