// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KamaalSwift",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12), .iOS(.v15),
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
        .library(
            name: "KamaalNavigation",
            targets: ["KamaalNavigation"]
        ),
        .library(
            name: "KamaalBrowser",
            targets: ["KamaalBrowser"]
        ),
        .library(
            name: "KamaalPopUp",
            targets: ["KamaalPopUp"]
        ),
        .library(
            name: "KamaalNetworker",
            targets: ["KamaalNetworker"]
        ),
        .library(
            name: "KamaalAPIServices",
            targets: ["KamaalAPIServices"]
        ),
        .library(
            name: "KamaalSettings",
            targets: ["KamaalSettings"]
        ),
        .library(
            name: "KamaalCoreData",
            targets: ["KamaalCoreData"]
        ),
        .library(
            name: "KamaalAlgorithms",
            targets: ["KamaalAlgorithms"]
        ),
        .library(
            name: "KamaalUtils",
            targets: ["KamaalUtils"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", "4.0.0" ..< "5.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", "9.0.0" ..< "10.0.0"),
        .package(url: "https://github.com/simibac/ConfettiSwiftUI.git", "1.0.0" ..< "2.0.0"),
        .package(url: "https://github.com/mattgallagher/CwlPreconditionTesting.git", "2.0.0" ..< "3.0.0"),
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
        .target(
            name: "KamaalNavigation",
            dependencies: ["KamaalStructures", "KamaalUI"]
        ),
        .target(
            name: "KamaalBrowser",
            dependencies: []
        ),
        .target(
            name: "KamaalPopUp",
            dependencies: ["KamaalUI"],
            resources: [.process("Resources")]
        ),
        .target(
            name: "KamaalNetworker",
            dependencies: ["KamaalExtensions"]
        ),
        .target(
            name: "KamaalAPIServices",
            dependencies: ["KamaalNetworker", "KamaalExtensions"]
        ),
        .target(
            name: "KamaalSettings",
            dependencies: [
                "KamaalExtensions",
                "KamaalLogger",
                "KamaalUI",
                "KamaalBrowser",
                "KamaalNavigation",
                "KamaalAPIServices",
                "ConfettiSwiftUI",
                "KamaalPopUp",
                "KamaalAlgorithms",
            ],
            resources: [
                .process("Internal/Resources"),
            ]
        ),
        .target(
            name: "KamaalCoreData",
            dependencies: ["KamaalExtensions"],
            exclude: ["README.md"]
        ),
        .target(
            name: "KamaalAlgorithms",
            dependencies: []
        ),
        .target(
            name: "KamaalUtils",
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
            dependencies: ["KamaalLogger", "CwlPreconditionTesting", "KamaalExtensions"]
        ),
        .testTarget(
            name: "KamaalStructuresTests",
            dependencies: ["KamaalStructures"]
        ),
        .testTarget(
            name: "KamaalNavigationTests",
            dependencies: ["KamaalNavigation"]
        ),
        .testTarget(
            name: "KamaalNetworkerTests",
            dependencies: ["KamaalNetworker", "Quick", "Nimble"]
        ),
        .testTarget(
            name: "KamaalAPIServicesTests",
            dependencies: ["KamaalAPIServices", "Quick", "Nimble"]
        ),
        .testTarget(
            name: "KamaalSettingsTests",
            dependencies: ["KamaalSettings"]
        ),
        .testTarget(
            name: "KamaalCoreDataTests",
            dependencies: ["KamaalCoreData", "KamaalExtensions"]
        ),
        .testTarget(
            name: "KamaalUtilsTests",
            dependencies: ["KamaalUtils"],
            resources: [.process("Internal/Resources")]
        ),
    ]
)
