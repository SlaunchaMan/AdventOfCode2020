// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "AdventOfCode2020",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "AdventOfCode2020Runner",
            targets: [
                "AdventOfCode2020Runner"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Apple/swift-argument-parser",
            from: "0.3.0"
        )
    ],
    targets: [
        .target(
            name: "AdventOfCode2020Runner",
            dependencies: [
                "AdventOfCode2020",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
            ]
        ),
        .target(
            name: "AdventOfCode2020",
            resources: [
                .copy("Resources/inputs")
            ]
        ),
        .testTarget(
            name: "AdventOfCode2020Tests",
            dependencies: [
                "AdventOfCode2020"
            ]
        ),
    ]
)
