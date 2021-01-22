// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "FinnUI",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "FinnUI",
            targets: ["FinnUI"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FinnUI",
            path: "Sources",
            resources: [
                .process("Assets/Fonts"),
                .process("Assets/Sounds"),
            ]
        ),
    ]
)
