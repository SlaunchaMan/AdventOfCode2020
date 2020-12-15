// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "AdventOfCodeConfigurator",
            targets: [
                "AdventOfCodeConfigurator"
            ]
        ),
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
            url: "https://github.com/apple/swift-crypto",
            from: "1.1.2"
        ),
        .package(
            url: "https://github.com/Realm/SwiftLint",
            from: "0.41.0"
        ),
        .package(
            url: "git@github.com:SlaunchaMan/StringDecoder.git",
            from: "0.0.2"
        ),
        .package(
            url: "https://github.com/shibapm/Komondor.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "AdventOfCodeConfigurator",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ]
        ),
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
                ),
                .product(
                    name: "Crypto",
                    package: "swift-crypto"
                ),
                "StringDecoder"
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
