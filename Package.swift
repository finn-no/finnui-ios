// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "FinnUI",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "FinnUI",
            targets: ["FinnUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/finn-no/FinniversKit.git", branch: "increase-calltoaction-button")
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
