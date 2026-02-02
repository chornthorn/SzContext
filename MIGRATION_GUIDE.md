# Migration Guide: CocoaPods to Swift Package Manager

This guide provides step-by-step instructions for migrating the SzContext project from CocoaPods to Swift Package Manager (SPM).

## Overview

The SzContext project currently uses CocoaPods for dependency management with the following dependency:
- **Sparkle** (v1.24.0): Framework for automatic app updates

This migration will replace CocoaPods with Swift Package Manager, which is Apple's official dependency manager and provides better integration with Xcode.

## Prerequisites

- Xcode 12.0 or later
- macOS 10.15 or later
- Existing project checked out from repository

## Migration Steps

### 1. Backup Your Project

Before making any changes, create a backup of your project:

```bash
cp -r ~/path/to/SzContext ~/path/to/SzContext-backup
```

Or commit all current changes to git:

```bash
git add .
git commit -m "Backup before SPM migration"
```

### 2. Open the Project in Xcode

**Important:** Open the `.xcodeproj` file, NOT the `.xcworkspace` file:

```bash
open SzContext.xcodeproj
```

### 3. Add Sparkle via Swift Package Manager

1. In Xcode, select the project in the Navigator (the blue project icon at the top)
2. Select the "SzContext" target
3. Go to the "Swift Packages" tab (or "Package Dependencies" in Xcode 13+)
4. Click the "+" button to add a package dependency
5. Enter the Sparkle repository URL: `https://github.com/sparkle-project/Sparkle`
6. Select version: Choose "2.0.0" or later (Sparkle 2.x has official SPM support)
7. Click "Next" and then "Finish"
8. In the package selection dialog, make sure "Sparkle" is selected for the "SzContext" target

### 4. Remove CocoaPods Integration

#### 4.1. Remove Pod References from Xcode

1. In the project navigator, locate any "Pods" folder or frameworks
2. Select them and delete (choose "Remove Reference" not "Move to Trash")
3. In the project settings, go to the "Build Phases" tab
4. Remove any CocoaPods-related build phases:
   - "[CP] Check Pods Manifest.lock"
   - "[CP] Embed Pods Frameworks"
   - "[CP] Copy Pods Resources"
5. Go to "Build Settings" and search for "FRAMEWORK_SEARCH_PATHS"
6. Remove any paths referencing Pods, such as:
   - `$(inherited)`
   - `"${PODS_ROOT}/Sparkle"`
   - `"${PODS_XCFRAMEWORKS_BUILD_DIR}/Sparkle"`

#### 4.2. Close the Workspace and Use the Project

1. Close the current Xcode workspace
2. From now on, open only `SzContext.xcodeproj` (not the .xcworkspace)

#### 4.3. Remove CocoaPods Files

```bash
# Remove Podfile and lock file
rm Podfile
rm Podfile.lock

# Remove Pods directory
rm -rf Pods/

# Remove workspace (optional - you may want to keep it)
rm -rf SzContext.xcworkspace/
```

### 5. Update .gitignore

Update your `.gitignore` file to exclude Swift Package Manager artifacts and remove CocoaPods entries:

Add these lines:
```
# Swift Package Manager
.swiftpm/
.build/
*.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/
*.xcodeproj/xcshareddata/swiftpm/
```

Remove or comment out CocoaPods-related lines:
```
# Pods/
# Podfile.lock
```

### 6. Verify the Migration

1. Clean the build folder: Product → Clean Build Folder (Cmd+Shift+K)
2. Build the project: Product → Build (Cmd+B)
3. Verify there are no build errors
4. Test the app functionality to ensure everything works as expected

### 7. Update Documentation

Update the README.md file to reflect the new dependency management system (see updated README.md).

## Troubleshooting

### Build Errors Related to Sparkle

If you encounter build errors:
- Ensure you're using Sparkle 2.0 or later (has SPM support)
- Clean build folder and derived data
- Restart Xcode

### Missing Framework Errors

If you get errors about missing Sparkle framework:
- Verify the package was added correctly in Xcode
- Check that the target has the Sparkle package linked in "Frameworks, Libraries, and Embedded Content"

### Workspace Issues

If Xcode still tries to open the workspace:
- Delete the .xcworkspace directory completely
- Clear Xcode's derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/`

## Benefits of Swift Package Manager

- **Native Integration**: Built into Xcode and Swift toolchain
- **Faster Resolution**: Generally faster than CocoaPods
- **No Generated Files**: No Pods directory or .xcworkspace to manage
- **Better Xcode Integration**: Automatic dependency resolution
- **Official Support**: Maintained by Apple

## Rollback Procedure

If you need to rollback to CocoaPods:

1. Restore from backup or use git:
   ```bash
   git checkout -- .
   git clean -fd
   ```

2. Reinstall pods:
   ```bash
   pod install
   ```

3. Open the .xcworkspace file

## Additional Resources

- [Swift Package Manager Documentation](https://swift.org/package-manager/)
- [Sparkle 2.0 Documentation](https://sparkle-project.org/documentation/)
- [Apple's SPM Guide](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

## Support

For issues or questions about this migration:
- Open an issue on the GitHub repository
- Check Sparkle documentation for SPM-specific guidance
