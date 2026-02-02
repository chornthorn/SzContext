# Swift Package Manager Migration Checklist

Use this checklist to ensure a smooth migration from CocoaPods to Swift Package Manager.

## Pre-Migration

- [ ] **Backup the project**
  - [ ] Commit all changes: `git add . && git commit -m "Pre-SPM migration backup"`
  - [ ] Or create a copy: `cp -r SzContext SzContext-backup`

- [ ] **Verify current state**
  - [ ] Project builds successfully with CocoaPods
  - [ ] All tests pass
  - [ ] Note current Sparkle version: 1.24.0

## Migration Steps (In Xcode)

- [ ] **Open project correctly**
  - [ ] Close Xcode if open
  - [ ] Open `SzContext.xcodeproj` (NOT the .xcworkspace)

- [ ] **Add Swift Package Manager dependencies**
  - [ ] Click on project in Navigator (blue icon)
  - [ ] Select "SzContext" target
  - [ ] Go to "Package Dependencies" or "Swift Packages" tab
  - [ ] Click "+" to add package
  - [ ] Add Sparkle: `https://github.com/sparkle-project/Sparkle`
  - [ ] Select version 2.0.0 or later
  - [ ] Ensure Sparkle is linked to "SzContext" target
  - [ ] Let Xcode resolve packages

- [ ] **Remove CocoaPods integration from Xcode**
  - [ ] In project navigator, find and delete Pods folder reference
  - [ ] Go to Build Phases → Remove these phases:
    - [ ] "[CP] Check Pods Manifest.lock"
    - [ ] "[CP] Embed Pods Frameworks"  
    - [ ] "[CP] Copy Pods Resources"
  - [ ] Go to Build Settings → Search "FRAMEWORK_SEARCH_PATHS"
    - [ ] Remove any Pods-related paths
  - [ ] Go to General → Remove Pods frameworks from "Frameworks and Libraries"

## Post-Migration (Terminal)

- [ ] **Clean build artifacts**
  ```bash
  # In Xcode: Product → Clean Build Folder (Cmd+Shift+K)
  # Or in terminal:
  rm -rf ~/Library/Developer/Xcode/DerivedData/SzContext-*
  ```

- [ ] **Run cleanup script**
  ```bash
  ./cleanup_cocoapods.sh
  ```
  
  Or manually:
  ```bash
  rm Podfile
  rm Podfile.lock
  rm -rf Pods/
  rm -rf SzContext.xcworkspace/  # Optional
  ```

## Verification

- [ ] **Build verification**
  - [ ] Open `SzContext.xcodeproj` in Xcode
  - [ ] Clean build folder (Cmd+Shift+K)
  - [ ] Build project (Cmd+B)
  - [ ] Verify no build errors
  - [ ] Check that Sparkle framework is properly linked

- [ ] **Runtime verification**
  - [ ] Run the application
  - [ ] Test basic functionality
  - [ ] Verify app launches without crashes
  - [ ] (If Sparkle is actively used) Test update checking

- [ ] **Code review**
  - [ ] Review changed files: `git status`
  - [ ] Review diff: `git diff`
  - [ ] Ensure only expected files changed:
    - [ ] .gitignore (added SPM entries)
    - [ ] README.md (updated with SPM info)
    - [ ] SzContext.xcodeproj/project.pbxproj (removed CocoaPods, added SPM)
    - [ ] Removed: Podfile, Podfile.lock, Pods/, .xcworkspace

## Commit Changes

- [ ] **Stage changes**
  ```bash
  git add .gitignore README.md MIGRATION_GUIDE.md cleanup_cocoapods.sh
  git add SzContext.xcodeproj/
  ```

- [ ] **Review what will be committed**
  ```bash
  git status
  git diff --staged
  ```

- [ ] **Commit the migration**
  ```bash
  git commit -m "Migrate from CocoaPods to Swift Package Manager

  - Add Sparkle 2.x via Swift Package Manager
  - Remove CocoaPods integration (Podfile, Pods/, workspace)
  - Update .gitignore for SPM artifacts
  - Add migration guide and cleanup script
  - Update README with SPM build instructions"
  ```

- [ ] **Push changes**
  ```bash
  git push origin <your-branch-name>
  ```

## Troubleshooting

If you encounter issues:

- [ ] **Package resolution fails**
  - Try: File → Packages → Reset Package Caches
  - Try: File → Packages → Resolve Package Versions

- [ ] **Build errors**
  - Verify Sparkle is version 2.0+
  - Clean derived data completely
  - Restart Xcode

- [ ] **Need to rollback**
  ```bash
  git checkout -- .
  git clean -fd
  pod install
  # Then open .xcworkspace
  ```

## Documentation Updates

- [ ] Update CI/CD scripts (if any) to remove pod install
- [ ] Update team documentation about build process
- [ ] Notify team members about the change
- [ ] Update any build automation scripts

## Success Criteria

✅ Migration is complete when:
- Project builds successfully without CocoaPods
- App runs without crashes
- All functionality works as expected
- CocoaPods files are removed
- Changes are committed to git
- Team is notified

---

## Notes

- Swift Package Manager is now the official Apple dependency manager
- No need for `pod install` anymore
- Xcode will automatically resolve packages
- Dependencies are cached in ~/Library/Developer/Xcode/DerivedData/
- For team projects, package resolution is automatic on first build

## Additional Resources

- See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed instructions
- [Apple's SPM Documentation](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)
- [Sparkle 2.0 Release Notes](https://sparkle-project.org/)
