enum ScrollSource: Sendable {
    case mouse
    case trackpad
}

struct ScrollOptions: Equatable, Sendable {
    var enabled = true
    var reverseMouse = true
    var reverseTrackpad = false

    func shouldInvert(_ source: ScrollSource) -> Bool {
        guard enabled else { return false }
        switch source {
        case .mouse: return reverseMouse
        case .trackpad: return reverseTrackpad
        }
    }
}
