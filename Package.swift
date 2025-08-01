// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "LittleTask",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "LittleTask",
            targets: ["LittleTask"]
        ),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "LittleTask",
            dependencies: [],
            path: "Sources/LittleTask"
        ),
    ]
) 