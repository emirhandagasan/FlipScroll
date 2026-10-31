import CoreGraphics

enum ScrollSpeed {
    case fast
    case precise

    init?(flags: CGEventFlags) {
        if flags.contains(.maskAlternate) {
            self = .fast
        } else if flags.contains(.maskControl) {
            self = .precise
        } else {
            return nil
        }
    }

    var factor: Double {
        switch self {
        case .fast: return 4
        case .precise: return 0.25
        }
    }
}
