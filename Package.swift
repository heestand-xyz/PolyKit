// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "PolyKit",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "PolyKit",
            targets: ["PolyKit"]),
    ],
    targets: [
        .target(
            name: "PolyKit",
            dependencies: []),
    ]
)
