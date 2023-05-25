// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "FinnUI",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "FinnUI",
            targets: ["FinnUI"]
        ),
    ],
    dependencies: [
        .package(name: "FinniversKit", url: "https://github.com/finn-no/FinniversKit.git", "109.1.0"..."999.0.0")
    ],
    targets: [
    	.target(
            name: "FinnUI",
            dependencies: [
                "FinniversKit",
            ],
            path: "Sources"
        ),
    ]
)
