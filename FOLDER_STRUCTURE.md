# SPM Standard Folder Structure

This document describes the Swift Package Manager standard folder structure implemented in this project.

## Directory Structure

```
SzContext/
├── Sources/                          # All source code (SPM standard)
│   ├── SzContextShared/             # Shared library module
│   │   ├── Constants.swift
│   │   ├── Util.swift
│   │   ├── BookmarkManager.swift
│   │   ├── PreferenceManager.swift
│   │   ├── IconCacheManager.swift
│   │   ├── NotifyManager.swift
│   │   ├── XPCServiceManager.swift
│   │   └── [resources excluded from build]
│   │
│   ├── SzContextApp/                # Main application
│   │   ├── AppDelegate.swift
│   │   ├── MainWindowController.swift
│   │   ├── TabViewController.swift
│   │   ├── Preference*ViewController.swift
│   │   └── [UI resources excluded from build]
│   │
│   ├── SzContextExtension/          # Finder Sync Extension
│   │   ├── FinderSync.swift
│   │   └── [resources excluded from build]
│   │
│   └── SzContextHelper/             # XPC Helper Service
│       ├── main.swift
│       ├── SzContextXPC.swift
│       ├── SzContextXPCDelegate.swift
│       ├── SzContextXPCProtocol.swift
│       └── [resources excluded from build]
│
├── Tests/                            # Test suites (SPM standard)
│   └── SzContextTests/
│       ├── SzContextTests.swift
│       └── DependencyResolutionTests.swift
│
├── Package.swift                     # SPM manifest
├── Package.resolved                  # Dependency lock file
│
├── SzContext.xcodeproj/             # Xcode project (for GUI building)
├── Shared/                          # Legacy directory (kept for Xcode compatibility)
├── SzContext/                       # Legacy directory (kept for Xcode compatibility)
├── SzContextFinderSyncExtension/    # Legacy directory (kept for Xcode compatibility)
└── SzContextXPCHelper/              # Legacy directory (kept for Xcode compatibility)
```

## Why This Structure?

### SPM Standard: `Sources/` Directory

The `Sources/` directory is the standard convention for Swift Package Manager:

✅ **Community Standard**: Recognized by all Swift developers
✅ **Tooling Support**: IDEs and build tools automatically locate code
✅ **Clear Organization**: All source code in one place
✅ **Scalability**: Easy to add new modules
✅ **CI/CD Friendly**: Automated tools know where to find source

### Multiple Targets

This project has multiple targets (app, extension, helper), each in its own subdirectory:

- **SzContextShared**: Common code used by all other targets
- **SzContextApp**: Main application UI and logic
- **SzContextExtension**: Finder Sync Extension
- **SzContextHelper**: XPC Helper for background operations

Each target has dependencies properly declared in Package.swift.

### Legacy Directories

The original directories (`Shared/`, `SzContext/`, etc.) are kept for Xcode project compatibility:

- Xcode project file (`.xcodeproj`) still references these locations
- UI resources (Assets, XIBs, plists) remain in original locations
- Allows gradual migration without breaking builds

## Package.swift Configuration

```swift
targets: [
    .target(
        name: "SzContextShared",
        path: "Sources/SzContextShared",
        exclude: [/* resources */]
    ),
    .target(
        name: "SzContextApp",
        dependencies: ["SzContextShared"],
        path: "Sources/SzContextApp",
        exclude: [/* resources */]
    ),
    .target(
        name: "SzContextExtension",
        dependencies: ["SzContextShared"],
        path: "Sources/SzContextExtension",
        exclude: [/* resources */]
    ),
    .target(
        name: "SzContextHelper",
        dependencies: ["SzContextShared"],
        path: "Sources/SzContextHelper",
        exclude: [/* resources */]
    ),
    .testTarget(
        name: "SzContextTests",
        dependencies: ["SzContextShared"],
        path: "Tests"
    ),
]
```

## Benefits of New Structure

### 1. Standard Compliance
Follows Swift Package Manager conventions accepted by the community.

### 2. Better Discoverability
New developers can immediately locate source code in `Sources/`.

### 3. Improved Tooling
- `swift build` works without custom configuration
- `swift test` finds tests automatically
- IDEs provide better code navigation

### 4. Cleaner Organization
Clear separation between:
- Source code (`Sources/`)
- Tests (`Tests/`)
- Documentation (root level)
- Build artifacts (excluded)

### 5. Multiple Target Support
Maintains separation of concerns:
- Shared code reused across targets
- App code isolated from extension code
- Helper service independent
- Dependencies properly declared

## Working with the New Structure

### Building with SPM

```bash
# Build all targets
swift build

# Build specific target
swift build --target SzContextShared

# Run tests
swift test
```

### Building with Xcode

```bash
# Open Xcode project (not workspace after CocoaPods removal)
open SzContext.xcodeproj

# Build in Xcode (⌘B)
# Xcode will use its project file which references legacy directories
```

### Adding New Files

#### For SPM (Command Line)
Place files in appropriate `Sources/` subdirectory:
```
Sources/SzContextShared/NewFile.swift
```

#### For Xcode (GUI)
Add files through Xcode to legacy directories and copy to Sources/:
```
Shared/NewFile.swift  # Add via Xcode
# Then copy to Sources/SzContextShared/
```

## Migration Status

✅ **Completed**:
- Created `Sources/` directory structure
- Copied all source files to new locations
- Updated `Package.swift` with new paths
- Updated tests to verify new structure
- Documented new structure

⏳ **Optional Future Steps**:
- Remove legacy directories (requires Xcode project update)
- Update Xcode project to reference `Sources/` directly
- Create symbolic links for compatibility

🔄 **Current State**:
- **Sources/**: SPM standard structure (new)
- **Legacy dirs**: Original structure (Xcode compatibility)
- **Both coexist**: Gradual migration without breaking builds

## Validation

Run tests to verify the structure:

```bash
# Validate structure
./validate_spm_migration.sh

# Run structure tests
swift test --filter testSPMStandardStructure
swift test --filter testTargetStructure
```

## References

- [Swift Package Manager Documentation](https://swift.org/package-manager/)
- [Package Manifest API](https://github.com/apple/swift-package-manager/blob/main/Documentation/PackageDescription.md)
- [Swift.org Package Structure Guide](https://swift.org/getting-started/#using-the-package-manager)

## Questions?

See also:
- [IMPLEMENTATION.md](IMPLEMENTATION.md) - Technical implementation details
- [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Step-by-step migration
- [SPM_QUICK_REFERENCE.md](SPM_QUICK_REFERENCE.md) - Quick commands

---

**Last Updated**: 2026-02-02  
**Status**: ✅ Structure Implemented  
**Version**: SPM Standard Layout v1.0
