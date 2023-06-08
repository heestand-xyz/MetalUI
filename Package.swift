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
    targets: [
        .target(
            name: "MetalUI"),
    ]
)
