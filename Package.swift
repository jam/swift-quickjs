// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-quickjs",
    products: [
        .library(
            name: "CQuickJS",
            targets: ["CQuickJS"]
        ),
        .library(
            name: "QuickJSKit",
            targets: ["QuickJSKit"]
        )
    ],
    targets: [
        .target(
            name: "CQuickJS",
            path: "Sources/CQuickJS",
            publicHeadersPath: "."
        ),
        .target(
            name: "QuickJSKit",
            dependencies: ["CQuickJS"]
        ),
        .testTarget(
            name: "CQuickJSTests",
            dependencies: ["CQuickJS"],
            path: "Tests/CQuickJSTests"
        ),
        .testTarget(
            name: "QuickJSKitTests",
            dependencies: ["QuickJSKit"]
        ),
    ]
)
