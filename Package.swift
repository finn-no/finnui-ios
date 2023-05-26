// swift-tools-version:5.7

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
        .package(url: "https://github.com/finn-no/FinniversKit.git", "111.4.0"..."999.0.0")
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
