// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "AdventOfCodeRunner",
            targets: [
                "AdventOfCodeRunner"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-algorithms",
            from: "0.0.1"
        ),
        .package(
            url: "https://github.com/Apple/swift-argument-parser",
            from: "0.3.0"
        ),
        .package(
            url: "https://github.com/Realm/SwiftLint",
            from: "0.41.0"
        ),
        .package(
            url: "https://github.com/shibapm/Komondor.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "AdventOfCodeRunner",
            dependencies: [
                "AdventOfCode",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ]
        ),
        .target(
            name: "AdventOfCode",
            dependencies: [
                .product(
                    name: "Algorithms",
                    package: "swift-algorithms"
                )
            ],
            resources: [
                .copy("Resources/inputs")
            ]
        ),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: [
                "AdventOfCode"
            ]
        )
    ]
)

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfiguration([
    "komondor": [
        "pre-commit": [
            "sh Scripts/swiftlint-hook.sh"
        ]
    ]
]).write()
#endif
