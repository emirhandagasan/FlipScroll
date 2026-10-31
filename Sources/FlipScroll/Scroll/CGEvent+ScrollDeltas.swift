import CoreGraphics

extension CGEvent {
    func invertScrollDeltas() {
        multiplyScrollDeltas(by: -1)
    }

    // Changes every delta together so all apps see the same scroll.
    func multiplyScrollDeltas(by factor: Double) {
        // Read first: writing one field can make macOS recompute the others.
        let lineY = getIntegerValueField(.scrollWheelEventDeltaAxis1)
        let lineX = getIntegerValueField(.scrollWheelEventDeltaAxis2)
        let fixedY = getDoubleValueField(.scrollWheelEventFixedPtDeltaAxis1)
        let fixedX = getDoubleValueField(.scrollWheelEventFixedPtDeltaAxis2)
        let pointY = getIntegerValueField(.scrollWheelEventPointDeltaAxis1)
        let pointX = getIntegerValueField(.scrollWheelEventPointDeltaAxis2)

        setIntegerValueField(.scrollWheelEventDeltaAxis1, value: Self.multiply(lineY, by: factor))
        setIntegerValueField(.scrollWheelEventDeltaAxis2, value: Self.multiply(lineX, by: factor))
        setDoubleValueField(.scrollWheelEventFixedPtDeltaAxis1, value: fixedY * factor)
        setDoubleValueField(.scrollWheelEventFixedPtDeltaAxis2, value: fixedX * factor)
        setIntegerValueField(.scrollWheelEventPointDeltaAxis1, value: Self.multiply(pointY, by: factor))
        setIntegerValueField(.scrollWheelEventPointDeltaAxis2, value: Self.multiply(pointX, by: factor))
    }

    // A small delta never rounds to zero, so a wheel tick is not lost.
    private static func multiply(_ value: Int64, by factor: Double) -> Int64 {
        guard value != 0 else { return 0 }
        let result = (Double(value) * factor).rounded()
        if result == 0 {
            return (Double(value) * factor) < 0 ? -1 : 1
        }
        return Int64(result)
    }
}
