// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-diagnostics",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27")
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
