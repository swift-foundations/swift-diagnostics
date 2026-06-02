// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-diagnostics",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(name: "Diagnostics", targets: ["Diagnostics"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-diagnostic-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-source-primitives.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Diagnostics",
            dependencies: [
                .product(name: "Diagnostic Primitives", package: "swift-diagnostic-primitives"),
                .product(name: "Source Primitives", package: "swift-source-primitives")
            ]
        ),
        .testTarget(
            name: "Diagnostics Tests",
            dependencies: [
                "Diagnostics"
            ]
        ),
    ]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
