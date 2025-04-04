// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BackendAPI",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BackendAPI",
            targets: ["BackendAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.2"))
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BackendAPI",
            dependencies: ["Alamofire"]
        ),
        .testTarget(
            name: "BackendAPITests",
            dependencies: ["BackendAPI"],
            path: "Tests/BackendAPITests",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
