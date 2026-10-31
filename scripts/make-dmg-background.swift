import AppKit

// Draws the DMG window background: a hint and an arrow between the two icons.

let width = 660
let height = 400

func drawBackground() {
    let bounds = NSRect(x: 0, y: 0, width: width, height: height)
    NSGradient(
        starting: NSColor(srgbRed: 0.97, green: 0.98, blue: 1.0, alpha: 1),
        ending: NSColor(srgbRed: 0.87, green: 0.91, blue: 1.0, alpha: 1)
    )?.draw(in: bounds, angle: -90)

    let accent = NSColor(srgbRed: 0.24, green: 0.23, blue: 0.84, alpha: 1)

    let hint = NSAttributedString(
        string: "Drag FlipScroll to Applications",
        attributes: [
            .font: NSFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: accent,
        ]
    )
    hint.draw(at: NSPoint(x: (CGFloat(width) - hint.size().width) / 2, y: 330))

    // Arrow between the icons, at their vertical center.
    accent.setFill()
    NSBezierPath(
        roundedRect: NSRect(x: 280, y: 160, width: 80, height: 12),
        xRadius: 6, yRadius: 6
    ).fill()
    let head = NSBezierPath()
    head.move(to: NSPoint(x: 385, y: 166))
    head.line(to: NSPoint(x: 350, y: 188))
    head.line(to: NSPoint(x: 350, y: 144))
    head.close()
    head.fill()
}

func render(scale: Int, to path: String) throws {
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: width * scale, pixelsHigh: height * scale,
        bitsPerSample: 8, samplesPerPixel: 4,
        hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0, bitsPerPixel: 0
    ) else { throw CocoaError(.fileWriteUnknown) }
    rep.size = NSSize(width: width, height: height)

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    drawBackground()
    NSGraphicsContext.restoreGraphicsState()

    guard let png = rep.representation(using: .png, properties: [:]) else {
        throw CocoaError(.fileWriteUnknown)
    }
    try png.write(to: URL(fileURLWithPath: path))
}

let outputDir = CommandLine.arguments[1]
try render(scale: 1, to: "\(outputDir)/background.png")
try render(scale: 2, to: "\(outputDir)/background@2x.png")
