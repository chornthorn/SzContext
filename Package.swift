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
        .library(
            name: "SzContextApp",
            targets: ["SzContextApp"]),
        .library(
            name: "SzContextExtension",
            targets: ["SzContextExtension"]),
        .library(
            name: "SzContextHelper",
            targets: ["SzContextHelper"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package.
        // Shared library target
        .target(
            name: "SzContextShared",
            dependencies: [],
            path: "Sources/SzContextShared",
            exclude: [
                "SzContext.xcdatamodeld",
                "de.lproj",
                "en.lproj", 
                "zh-Hans.lproj",
                "finderGoto.scpt"
            ]
        ),
        
        // Main app target
        .target(
            name: "SzContextApp",
            dependencies: ["SzContextShared"],
            path: "Sources/SzContextApp",
            exclude: [
                "Assets.xcassets",
                "Base.lproj",
                "de.lproj",
                "en.lproj",
                "zh-Hans.lproj",
                "Info.plist",
                "SzContext.entitlements"
            ]
        ),
        
        // Finder Sync Extension target
        .target(
            name: "SzContextExtension",
            dependencies: ["SzContextShared"],
            path: "Sources/SzContextExtension",
            exclude: [
                "Media.xcassets",
                "Info.plist",
                "SzContextFinderSyncExtension.entitlements"
            ]
        ),
        
        // XPC Helper target
        .target(
            name: "SzContextHelper",
            dependencies: ["SzContextShared"],
            path: "Sources/SzContextHelper",
            exclude: [
                "Assets.xcassets",
                "Info.plist",
                "LQ3C7Y6F8J.com.roadtodream.SzContextXPCHelper.entitlements",
                "AppIcon.icns",
                "finderBridge.applescript"
            ]
        ),
        
        // Test target
        .testTarget(
            name: "SzContextTests",
            dependencies: ["SzContextShared"],
            path: "Tests"
        ),
    ]
)
