// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MetalUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "MetalUI",
            targets: ["MetalUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "MetalUI"),
    ]
)
