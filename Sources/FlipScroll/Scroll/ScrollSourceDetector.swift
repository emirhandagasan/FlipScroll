import CoreGraphics

protocol ScrollSourceDetector {
    func source(of event: CGEvent) -> ScrollSource
}

// Wheels send line-based events, trackpads send continuous ones.
// Magic Mouse and free-spin wheels are misread as trackpads here.
struct ContinuityScrollSourceDetector: ScrollSourceDetector {
    func source(of event: CGEvent) -> ScrollSource {
        event.getIntegerValueField(.scrollWheelEventIsContinuous) == 0 ? .mouse : .trackpad
    }
}
