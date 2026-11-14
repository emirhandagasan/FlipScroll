import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let settings: SettingsStore = UserDefaultsSettingsStore()
    private let eventTap = ScrollEventTap(detector: ContinuityScrollSourceDetector())
    private var menuBar: MenuBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let menuBar = MenuBarController(settings: settings)
        menuBar.onChange = { [eventTap] options in eventTap.update(options) }
        self.menuBar = menuBar

        eventTap.update(settings.options)
        watchNaturalScrolling()
        startEventTap()
    }

    // The user can change the system setting at any time.
    private func watchNaturalScrolling() {
        Task {
            while true {
                eventTap.updateSystemNaturalScrolling(NaturalScrolling.isEnabled)
                try? await Task.sleep(for: .seconds(5))
            }
        }
    }

    private func startEventTap() {
        if eventTap.start() { return }

        menuBar?.showPermissionWarning(true)
        Accessibility.requestAccess()

        // Retry until the user grants access.
        Task {
            while !eventTap.start() {
                try? await Task.sleep(for: .seconds(2))
            }
            menuBar?.showPermissionWarning(false)
        }
    }
}
