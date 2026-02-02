# Release Process

This document describes how to create releases for SzContext using the automated GitHub workflow.

## Overview

The project includes a GitHub Actions workflow that automatically builds an unsigned DMG file for macOS. This workflow is triggered when you create a version tag or can be run manually.

## Creating a Release

### Method 1: Using Git Tags (Recommended)

1. Update the version number in the following files:
   - `Sources/SzContextApp/Info.plist` - Update `CFBundleShortVersionString` and `CFBundleVersion`
   - `Sources/SzContextExtension/Info.plist` - Update `CFBundleShortVersionString` and `CFBundleVersion`
   - `Sources/SzContextHelper/Info.plist` - Update `CFBundleShortVersionString` and `CFBundleVersion`

2. Commit the version changes:
   ```bash
   git add Sources/*/Info.plist
   git commit -m "Bump version to X.Y"
   ```

3. Create and push a version tag:
   ```bash
   git tag v1.5
   git push origin v1.5
   ```

4. The workflow will automatically:
   - Build the SzContext app in unsigned mode
   - Create a DMG file named `SzContext-1.5-unsigned.dmg`
   - Create a GitHub release with the DMG attached
   - Add release notes

### Method 2: Manual Trigger

You can also trigger the workflow manually from the GitHub Actions tab:

1. Go to the Actions tab in the GitHub repository
2. Select "Build and Release DMG" workflow
3. Click "Run workflow"
4. Choose the branch and click "Run workflow"

This will build and upload the DMG as an artifact (available for 90 days) but won't create a GitHub release.

## Workflow Features

### Build Configuration

- **Build Mode**: Unsigned (no code signing required)
- **Configuration**: Release
- **Platform**: macOS (latest runner)
- **Code Signing**: Disabled with:
  - `CODE_SIGN_IDENTITY="-"`
  - `CODE_SIGNING_REQUIRED=NO`
  - `CODE_SIGNING_ALLOWED=NO`

### DMG Creation

The workflow creates a DMG file that includes:
- The SzContext.app bundle
- A symbolic link to the Applications folder for easy installation
- Compressed format (UDZO) for smaller file size

### Artifacts and Releases

- **Artifacts**: DMG files are always uploaded as workflow artifacts (90-day retention)
- **Releases**: When triggered by a tag, a GitHub release is automatically created with:
  - The DMG file attached
  - Auto-generated release notes
  - Installation instructions

## Installation Instructions for Users

Users who download the unsigned DMG should:

1. Download the DMG file from the release
2. Open the DMG file
3. Drag SzContext.app to the Applications folder
4. Right-click on SzContext.app and select "Open" (first time only)
5. Click "Open" in the security dialog
6. Follow the app's setup instructions

## Troubleshooting

### Build Fails

If the build fails:
1. Check the GitHub Actions logs for detailed error messages
2. Verify that all dependencies are properly specified in Package.swift
3. Ensure the Xcode project and scheme are properly configured

### App Won't Open on User's Mac

Since the app is unsigned:
1. Users must right-click and select "Open" the first time
2. They may need to allow it in System Preferences > Security & Privacy
3. For a better user experience, consider getting an Apple Developer certificate for signed builds

## Notes

- This workflow builds unsigned binaries suitable for development and testing
- For production releases on the Mac App Store, use Xcode's Archive and Upload process
- The unsigned build includes Sparkle for auto-updates (non-App Store version)
