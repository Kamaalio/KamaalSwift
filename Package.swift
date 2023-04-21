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
            targets: ["KamaalUI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KamaalUI",
            dependencies: []),
        .testTarget(
            name: "KamaalUITests",
            dependencies: ["KamaalUI"]),
    ]
)
