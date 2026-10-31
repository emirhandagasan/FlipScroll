import Foundation

protocol SettingsStore: AnyObject {
    var options: ScrollOptions { get set }
}

final class UserDefaultsSettingsStore: SettingsStore {
    private enum Key {
        static let enabled = "enabled"
        static let reverseMouse = "reverseMouse"
        static let reverseTrackpad = "reverseTrackpad"
        static let speedKeys = "speedKeys"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let fallback = ScrollOptions()
        defaults.register(defaults: [
            Key.enabled: fallback.enabled,
            Key.reverseMouse: fallback.reverseMouse,
            Key.reverseTrackpad: fallback.reverseTrackpad,
            Key.speedKeys: fallback.speedKeys,
        ])
    }

    var options: ScrollOptions {
        get {
            ScrollOptions(
                enabled: defaults.bool(forKey: Key.enabled),
                reverseMouse: defaults.bool(forKey: Key.reverseMouse),
                reverseTrackpad: defaults.bool(forKey: Key.reverseTrackpad),
                speedKeys: defaults.bool(forKey: Key.speedKeys)
            )
        }
        set {
            defaults.set(newValue.enabled, forKey: Key.enabled)
            defaults.set(newValue.reverseMouse, forKey: Key.reverseMouse)
            defaults.set(newValue.reverseTrackpad, forKey: Key.reverseTrackpad)
            defaults.set(newValue.speedKeys, forKey: Key.speedKeys)
        }
    }
}
