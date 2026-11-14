enum ScrollSource: Sendable {
    case mouse
    case trackpad
}

struct ScrollOptions: Equatable, Sendable {
    var enabled = true
    var reverseMouse = false
    var reverseTrackpad = false
    var speedKeys = false

    // Unreversed, the mouse scrolls the classic way and the trackpad the natural way,
    // whatever the system setting is.
    func shouldInvert(_ source: ScrollSource, systemNatural: Bool) -> Bool {
        guard enabled else { return false }
        switch source {
        case .mouse: return systemNatural != reverseMouse
        case .trackpad: return systemNatural == reverseTrackpad
        }
    }

    func usesSpeedKeys(_ source: ScrollSource) -> Bool {
        enabled && speedKeys && source == .mouse
    }
}
