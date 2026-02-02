// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SzContext",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries produced by a package.
        .library(
            name: "SzContextShared",
            targets: ["SzContextShared"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package.
        .target(
            name: "SzContextShared",
            dependencies: [],
            path: "Shared",
            exclude: [
                "SzContext.xcdatamodeld",
                "de.lproj",
                "en.lproj", 
                "zh-Hans.lproj",
                "finderGoto.scpt"
            ]
        ),
        .testTarget(
            name: "SzContextTests",
            dependencies: ["SzContextShared"],
            path: "Tests"
        ),
    ]
)
