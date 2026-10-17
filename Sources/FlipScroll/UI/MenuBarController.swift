import AppKit

@MainActor
final class MenuBarController: NSObject {
    var onChange: ((ScrollOptions) -> Void)?

    private let settings: SettingsStore
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let permissionItem = NSMenuItem(
        title: "Grant Accessibility Access…",
        action: #selector(MenuBarController.openAccessibilitySettings),
        keyEquivalent: ""
    )
    private let permissionSeparator = NSMenuItem.separator()
    private let enabledItem = NSMenuItem(
        title: "Enabled",
        action: #selector(MenuBarController.toggleEnabled),
        keyEquivalent: ""
    )
    private let mouseItem = NSMenuItem(
        title: "Reverse Mouse",
        action: #selector(MenuBarController.toggleMouse),
        keyEquivalent: ""
    )
    private let trackpadItem = NSMenuItem(
        title: "Reverse Trackpad",
        action: #selector(MenuBarController.toggleTrackpad),
        keyEquivalent: ""
    )
    private let launchAtLoginItem = NSMenuItem(
        title: "Launch at Login",
        action: #selector(MenuBarController.toggleLaunchAtLogin),
        keyEquivalent: ""
    )

    init(settings: SettingsStore) {
        self.settings = settings
        super.init()
        statusItem.button?.image = NSImage(
            systemSymbolName: "computermouse",
            accessibilityDescription: "FlipScroll"
        )
        statusItem.menu = makeMenu()
        showPermissionWarning(false)
        refresh()
    }

    func showPermissionWarning(_ visible: Bool) {
        permissionItem.isHidden = !visible
        permissionSeparator.isHidden = !visible
    }

    private func makeMenu() -> NSMenu {
        let menu = NSMenu()
        menu.delegate = self
        for item in [permissionItem, enabledItem, mouseItem, trackpadItem, launchAtLoginItem] {
            item.target = self
        }
        menu.addItem(permissionItem)
        menu.addItem(permissionSeparator)
        menu.addItem(enabledItem)
        menu.addItem(.separator())
        menu.addItem(mouseItem)
        menu.addItem(trackpadItem)
        menu.addItem(.separator())
        menu.addItem(launchAtLoginItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(
            title: "Quit FlipScroll",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        ))
        return menu
    }

    private func refresh() {
        let options = settings.options
        enabledItem.state = options.enabled ? .on : .off
        mouseItem.state = options.reverseMouse ? .on : .off
        trackpadItem.state = options.reverseTrackpad ? .on : .off
        launchAtLoginItem.state = LaunchAtLogin.isEnabled ? .on : .off
        statusItem.button?.appearsDisabled = !options.enabled
    }

    private func update(_ change: (inout ScrollOptions) -> Void) {
        var options = settings.options
        change(&options)
        settings.options = options
        onChange?(options)
        refresh()
    }

    @objc private func toggleEnabled() { update { $0.enabled.toggle() } }
    @objc private func toggleMouse() { update { $0.reverseMouse.toggle() } }
    @objc private func toggleTrackpad() { update { $0.reverseTrackpad.toggle() } }
    @objc private func openAccessibilitySettings() { Accessibility.openSettings() }

    @objc private func toggleLaunchAtLogin() {
        do {
            try LaunchAtLogin.setEnabled(!LaunchAtLogin.isEnabled)
        } catch {
            NSApp.activate(ignoringOtherApps: true)
            NSAlert(error: error).runModal()
        }
        refresh()
    }
}

extension MenuBarController: NSMenuDelegate {
    // Login items can change in System Settings, so read them on every open.
    func menuWillOpen(_ menu: NSMenu) {
        refresh()
    }
}
