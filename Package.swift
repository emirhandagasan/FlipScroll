// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FlipScroll",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(name: "FlipScroll", path: "Sources/FlipScroll")
    ]
)
