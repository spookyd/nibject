// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NibJect",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "NibJectCLI", targets: ["NibJectCLI"])
//        .library(
//            name: "NibJectCLI",
//            type: .dynamic,
//            targets: ["NibJectCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.5.0"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(path: "../CodeWriter")
    ],
    targets: [
        .target(name: "NibJectCLI",
                dependencies: ["SPMUtility", "NibJect"]),
        .target(
            name: "NibJect",
            dependencies: ["Files", "CodeWriter"]),
        .testTarget(
            name: "NibJectTests",
            dependencies: ["NibJect", "Files"]),
    ]
)
