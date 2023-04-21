// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KamaalSwift",
    platforms: [
        .macOS(.v10_15), .iOS(.v13),
    ],
    products: [
        .library(
            name: "KamaalUI",
            targets: ["KamaalUI"]
        ),
        .library(
            name: "KamaalExtensions",
            targets: ["KamaalExtensions"]
        ),
        .library(
            name: "KamaalLogger",
            targets: ["KamaalLogger"]
        ),
        .library(
            name: "KamaalStructures",
            targets: ["KamaalStructures"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", "4.0.0" ..< "5.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", "9.0.0" ..< "10.0.0"),
    ],
    targets: [
        .target(
            name: "KamaalUI",
            dependencies: []
        ),
        .target(
            name: "KamaalExtensions",
            dependencies: []
        ),
        .target(
            name: "KamaalLogger",
            dependencies: ["KamaalStructures"]
        ),
        .target(
            name: "KamaalStructures",
            dependencies: []
        ),
        .testTarget(
            name: "KamaalUITests",
            dependencies: ["KamaalUI"]
        ),
        .testTarget(
            name: "KamaalExtensionsTests",
            dependencies: ["KamaalExtensions", "Quick", "Nimble"]
        ),
        .testTarget(
            name: "KamaalLoggerTests",
            dependencies: ["KamaalLogger"]
        ),
        .testTarget(
            name: "KamaalStructuresTests",
            dependencies: ["KamaalStructures"]
        ),
    ]
)
