import CoreGraphics
import Foundation
import os

// Catches scroll events before apps see them and inverts the selected sources.
final class ScrollEventTap {
    private let detector: ScrollSourceDetector
    private let options = OSAllocatedUnfairLock(initialState: ScrollOptions())
    private var tap: CFMachPort?

    init(detector: ScrollSourceDetector) {
        self.detector = detector
    }

    func update(_ newOptions: ScrollOptions) {
        options.withLock { $0 = newOptions }
    }

    // Returns false while Accessibility access is missing.
    func start() -> Bool {
        if tap != nil { return true }

        let mask = CGEventMask(1 << CGEventType.scrollWheel.rawValue)
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: mask,
            callback: handleTapEvent,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else { return false }

        self.tap = tap
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)

        // Own thread, so a busy UI never delays scrolling.
        let thread = Thread {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
            CGEvent.tapEnable(tap: tap, enable: true)
            CFRunLoopRun()
        }
        thread.name = "FlipScroll.EventTap"
        thread.qualityOfService = .userInteractive
        thread.start()
        return true
    }

    fileprivate func process(_ type: CGEventType, _ event: CGEvent) {
        switch type {
        case .tapDisabledByTimeout, .tapDisabledByUserInput:
            // macOS may switch the tap off; turn it back on.
            if let tap { CGEvent.tapEnable(tap: tap, enable: true) }
        case .scrollWheel:
            let current = options.withLock { $0 }
            if current.shouldInvert(detector.source(of: event)) {
                event.invertScrollDeltas()
            }
        default:
            break
        }
    }
}

private func handleTapEvent(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    userInfo: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
    if let userInfo {
        let eventTap = Unmanaged<ScrollEventTap>.fromOpaque(userInfo).takeUnretainedValue()
        eventTap.process(type, event)
    }
    return Unmanaged.passUnretained(event)
}
