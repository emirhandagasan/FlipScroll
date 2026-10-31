# FlipScroll

A small macOS menu bar app that lets the mouse and the trackpad scroll in different directions.

Keep "Natural scrolling" on in System Settings, and FlipScroll reverses only the mouse wheel.

Works on macOS 13 or later, on both Apple Silicon and Intel Macs.

## Install

1. Download the latest `FlipScroll-x.y.z.dmg` from [Releases](https://github.com/emirhandagasan/FlipScroll/releases/latest).
2. Open it and drag **FlipScroll** into **Applications**.
3. Open FlipScroll from Applications.

FlipScroll is not notarized by Apple, so macOS blocks the first launch. To allow it:

1. Click **Done** on the warning.
2. Go to **System Settings → Privacy & Security**.
3. Scroll down and click **Open Anyway** next to the FlipScroll message, then confirm.

This is needed only once.

## Permission

FlipScroll needs Accessibility access to change scroll events. On first launch, allow it in **System Settings → Privacy & Security → Accessibility**.

If it stops working after an update, remove FlipScroll from that list with **–** and allow it again.

## Menu

- **Enabled**: turns all reversing on or off
- **Reverse Mouse**: reverses the mouse wheel
- **Reverse Trackpad**: reverses the trackpad
- **Speed Keys** (off by default): hold ⌥ to scroll the mouse 4x faster, or ⌃ to scroll it 4x slower
- **Launch at Login**: starts FlipScroll when you log in

## Known limitations

Magic Mouse and some free-spinning wheels send smooth scroll events, so FlipScroll may treat them as a trackpad.

## Build from source

Requires Swift 5.9 or later. If you don't have it, install the Command Line Tools:

```bash
xcode-select --install
```

Then build and install:

```bash
git clone https://github.com/emirhandagasan/FlipScroll.git
cd FlipScroll
./scripts/install.sh
```

This builds the app, copies it to `/Applications` and opens it.

Other scripts:

- `./scripts/build-app.sh`: builds `build/FlipScroll.app` only
- `./scripts/make-dmg.sh`: builds a DMG into `build/`

## Uninstall

Quit FlipScroll from its menu and move `/Applications/FlipScroll.app` to the Trash.
