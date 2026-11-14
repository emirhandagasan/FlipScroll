import Foundation

// Reads the system "Natural scrolling" setting. FlipScroll never changes it.
enum NaturalScrolling {
    private static let key = "com.apple.swipescrolldirection" as CFString

    static var isEnabled: Bool {
        // Picks up changes made in System Settings since the last read.
        CFPreferencesSynchronize(
            kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesAnyHost
        )
        let value = CFPreferencesCopyValue(
            key, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesAnyHost
        )
        return value as? Bool ?? true
    }
}
