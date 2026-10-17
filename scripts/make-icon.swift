import AppKit

// Draws the app icon on a 1024 grid and writes every size an iconset needs.

let topColor = NSColor(srgbRed: 0.36, green: 0.55, blue: 1.0, alpha: 1)
let bottomColor = NSColor(srgbRed: 0.24, green: 0.23, blue: 0.84, alpha: 1)

func upArrow(centerX x: CGFloat) -> (head: NSBezierPath, shaft: NSBezierPath) {
    let head = NSBezierPath()
    head.move(to: NSPoint(x: x, y: 682))
    head.line(to: NSPoint(x: x + 75, y: 567))
    head.line(to: NSPoint(x: x - 75, y: 567))
    head.close()
    let shaft = NSBezierPath(
        roundedRect: NSRect(x: x - 21, y: 342, width: 42, height: 240),
        xRadius: 21, yRadius: 21
    )
    return (head, shaft)
}

func drawIcon(scale: CGFloat) {
    let tile = NSBezierPath(
        roundedRect: NSRect(x: 100, y: 100, width: 824, height: 824),
        xRadius: 185, yRadius: 185
    )

    // Soft drop shadow like system icons.
    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow()
    shadow.shadowColor = NSColor.black.withAlphaComponent(0.3)
    shadow.shadowBlurRadius = 24 * scale
    shadow.shadowOffset = NSSize(width: 0, height: -10 * scale)
    shadow.set()
    bottomColor.setFill()
    tile.fill()
    NSGraphicsContext.restoreGraphicsState()

    NSGradient(starting: topColor, ending: bottomColor)?.draw(in: tile, angle: -90)

    // Mouse body and wheel.
    NSColor.white.setFill()
    NSBezierPath(
        roundedRect: NSRect(x: 362, y: 282, width: 300, height: 460),
        xRadius: 150, yRadius: 150
    ).fill()
    bottomColor.setFill()
    NSBezierPath(
        roundedRect: NSRect(x: 494, y: 590, width: 36, height: 96),
        xRadius: 18, yRadius: 18
    ).fill()

    // Opposite arrows: one scrolls up, the other down.
    NSColor.white.setFill()
    let left = upArrow(centerX: 230)
    left.head.fill()
    left.shaft.fill()

    let flip = AffineTransform(m11: 1, m12: 0, m21: 0, m22: -1, tX: 0, tY: 1024)
    let right = upArrow(centerX: 794)
    right.head.transform(using: flip)
    right.shaft.transform(using: flip)
    right.head.fill()
    right.shaft.fill()
}

func render(pixels: Int, to url: URL) throws {
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: pixels, pixelsHigh: pixels,
        bitsPerSample: 8, samplesPerPixel: 4,
        hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0, bitsPerPixel: 0
    ) else { throw CocoaError(.fileWriteUnknown) }

    let scale = CGFloat(pixels) / 1024
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    let transform = NSAffineTransform()
    transform.scale(by: scale)
    transform.concat()
    drawIcon(scale: scale)
    NSGraphicsContext.restoreGraphicsState()

    guard let png = rep.representation(using: .png, properties: [:]) else {
        throw CocoaError(.fileWriteUnknown)
    }
    try png.write(to: url)
}

let outputDir = URL(fileURLWithPath: CommandLine.arguments[1])
try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

for size in [16, 32, 128, 256, 512] {
    try render(pixels: size, to: outputDir.appendingPathComponent("icon_\(size)x\(size).png"))
    try render(pixels: size * 2, to: outputDir.appendingPathComponent("icon_\(size)x\(size)@2x.png"))
}
