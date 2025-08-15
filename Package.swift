// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-quickjs",
    products: [
        .library(
            name: "CQuickJS",
            targets: ["CQuickJS"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "swift-quickjs",
            path: "Sources",
            publicHeadersPath: "."
        ),
        .testTarget(
            name: "swift-quickjsTests",
            dependencies: ["swift-quickjs"]
        ),
    ]
)
