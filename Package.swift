// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "FinnUI",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "FinnUI",
            targets: ["FinnUI"]
        ),
    ],
    dependencies: [
//        .package(name: "FinniversKit", url: "https://github.com/finn-no/FinniversKit.git", .exact("91.0.0"))
        .package(name: "FinniversKit", url: "https://github.com/finn-no/FinniversKit.git", .branch("combine-extension"))
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
