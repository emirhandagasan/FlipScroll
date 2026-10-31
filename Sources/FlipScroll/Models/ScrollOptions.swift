enum ScrollSource: Sendable {
    case mouse
    case trackpad
}

struct ScrollOptions: Equatable, Sendable {
    var enabled = true
    var reverseMouse = true
    var reverseTrackpad = false
    var speedKeys = false

    func shouldInvert(_ source: ScrollSource) -> Bool {
        guard enabled else { return false }
        switch source {
        case .mouse: return reverseMouse
        case .trackpad: return reverseTrackpad
        }
    }

    func usesSpeedKeys(_ source: ScrollSource) -> Bool {
        enabled && speedKeys && source == .mouse
    }
}
