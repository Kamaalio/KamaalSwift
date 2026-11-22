# Get started

KamaalSwift uses Swift 6.1 or later. The [package manifest](../Package.swift)
declares macOS 13, iOS 16, and watchOS 7 deployment floors. Check the guide for
the product you use for APIs that require a specific platform or OS version.

In Xcode, choose **File → Add Package Dependencies**, enter
`https://github.com/Kamaalio/KamaalSwift.git`, and select each product for
the target that imports it.

In a Swift package, add the package to `dependencies` and a product to the
target's dependencies.

```swift
// Package dependencies
.package(url: "https://github.com/Kamaalio/KamaalSwift.git", from: "3.6.0")

// Target dependencies
.product(name: "KamaalLogger", package: "KamaalSwift")
```

Import the product's module, such as `import KamaalLogger`. The
[product index](../README.md) links to every module. The [Example app](../Example)
shows how to combine UI, navigation, settings, and persistence.
