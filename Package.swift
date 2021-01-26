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
        .package(name: "FinniversKit", url: "https://github.com/finn-no/FinniversKit.git", from: "73.1.0"),
    ],
    targets: [
    	.target(
            name: "FinnUI",
            dependencies: [
                "FinniversKit",
            ],
            path: "Sources",
            exclude: [
                "Demo",
            ],
            resources: [
                .process("Assets/Fonts"),
                .process("Assets/Sounds"),
            ]
        ),
        .testTarget(
            name: "FinnUI-Tests",
            dependencies: [
                "FinnUI",
            ],
            path: "UnitTests",
            exclude: [
                "__Snapshots__",
            ]
        ),
    ]
)
