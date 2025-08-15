// swift-tools-version: 6.2

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
        .target(
            name: "CQuickJS",
            path: "Sources",
            publicHeadersPath: "."
        ),
        .testTarget(
            name: "CQuickJSTests",
            dependencies: ["CQuickJS"],
            path: "Tests"
        ),
    ]
)
