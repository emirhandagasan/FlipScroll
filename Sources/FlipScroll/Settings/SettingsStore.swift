import Foundation

protocol SettingsStore: AnyObject {
    var options: ScrollOptions { get set }
}

final class UserDefaultsSettingsStore: SettingsStore {
    private enum Key {
        static let enabled = "enabled"
        static let reverseMouse = "reverseMouse"
        static let reverseTrackpad = "reverseTrackpad"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let fallback = ScrollOptions()
        defaults.register(defaults: [
            Key.enabled: fallback.enabled,
            Key.reverseMouse: fallback.reverseMouse,
            Key.reverseTrackpad: fallback.reverseTrackpad,
        ])
    }

    var options: ScrollOptions {
        get {
            ScrollOptions(
                enabled: defaults.bool(forKey: Key.enabled),
                reverseMouse: defaults.bool(forKey: Key.reverseMouse),
                reverseTrackpad: defaults.bool(forKey: Key.reverseTrackpad)
            )
        }
        set {
            defaults.set(newValue.enabled, forKey: Key.enabled)
            defaults.set(newValue.reverseMouse, forKey: Key.reverseMouse)
            defaults.set(newValue.reverseTrackpad, forKey: Key.reverseTrackpad)
        }
    }
}
