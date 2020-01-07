// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NibJect",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "nibject", targets: ["nibject"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.0.1"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(path: "../CodeWriter")
    ],
    targets: [
        .target(name: "nibject",
                dependencies: ["SwiftToolsSupport-auto", "NibJectKit"]),
        .target(
            name: "NibJectKit",
            dependencies: ["Files", "CodeWriter"]),
        .testTarget(
            name: "NibJectKitTests",
            dependencies: ["NibJectKit", "Files"]),
    ]
)
