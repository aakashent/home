// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LookAwayClone",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "LookAwayClone", targets: ["LookAwayClone"])
    ],
    targets: [
        .executableTarget(
            name: "LookAwayClone",
            path: "Sources/LookAwayClone"
        )
    ]
)
