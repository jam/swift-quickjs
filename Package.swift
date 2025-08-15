// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-quickjs",
    platforms: [.macOS(.v12)],
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
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.50.0")
    ],
    targets: [
        .target(
            name: "CQuickJS",
            path: "Sources/CQuickJS",
            publicHeadersPath: "."
        ),
        .target(
            name: "QuickJSKit",
            dependencies: ["CQuickJS"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
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
