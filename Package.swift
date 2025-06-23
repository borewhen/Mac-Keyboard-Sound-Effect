// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MacKeyTalk",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "MacKeyTalk",
            targets: ["MacKeyTalk"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MacKeyTalk",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("soundbite.wav")
            ]
        )
    ]
) 
