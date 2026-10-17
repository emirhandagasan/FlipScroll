import CoreGraphics

extension CGEvent {
    // Flips every delta together so momentum scrolling stays consistent.
    func invertScrollDeltas() {
        // Read first: writing one field can make macOS recompute the others.
        let lineY = getIntegerValueField(.scrollWheelEventDeltaAxis1)
        let lineX = getIntegerValueField(.scrollWheelEventDeltaAxis2)
        let fixedY = getDoubleValueField(.scrollWheelEventFixedPtDeltaAxis1)
        let fixedX = getDoubleValueField(.scrollWheelEventFixedPtDeltaAxis2)
        let pointY = getIntegerValueField(.scrollWheelEventPointDeltaAxis1)
        let pointX = getIntegerValueField(.scrollWheelEventPointDeltaAxis2)

        setIntegerValueField(.scrollWheelEventDeltaAxis1, value: -lineY)
        setIntegerValueField(.scrollWheelEventDeltaAxis2, value: -lineX)
        setDoubleValueField(.scrollWheelEventFixedPtDeltaAxis1, value: -fixedY)
        setDoubleValueField(.scrollWheelEventFixedPtDeltaAxis2, value: -fixedX)
        setIntegerValueField(.scrollWheelEventPointDeltaAxis1, value: -pointY)
        setIntegerValueField(.scrollWheelEventPointDeltaAxis2, value: -pointX)
    }
}
