# Swift Package Manager Quick Reference

Quick reference card for developers working with the SzContext project after SPM migration.

## 📦 Quick Start

### First Time Setup
```bash
git clone https://github.com/chornthorn/SzContext.git
cd SzContext
open SzContext.xcodeproj  # NOT .xcworkspace!
# Xcode will automatically resolve packages
# Press Cmd+B to build
```

### Existing Developers (After Migration)
```bash
cd SzContext
git pull
open SzContext.xcodeproj  # Dependencies resolve automatically
```

## 🔧 Common Tasks

### Building
```bash
# In Xcode:
Cmd+B - Build
Cmd+R - Run
Cmd+U - Test
Cmd+Shift+K - Clean Build Folder
```

### Managing Dependencies

**Add a new package:**
1. Project Navigator → Click project (blue icon)
2. Select target → "Package Dependencies" tab
3. Click "+" → Enter package URL
4. Choose version → Finish

**Update packages:**
- File → Packages → Update to Latest Package Versions

**Reset packages (if issues):**
- File → Packages → Reset Package Caches

### Troubleshooting

**Problem: Package resolution fails**
```
Solution:
File → Packages → Reset Package Caches
File → Packages → Resolve Package Versions
```

**Problem: Build errors after git pull**
```
Solution:
1. Clean Build Folder (Cmd+Shift+K)
2. Delete Derived Data:
   rm -rf ~/Library/Developer/Xcode/DerivedData/SzContext-*
3. Restart Xcode
```

**Problem: "No such module" errors**
```
Solution:
1. Verify package is added: Project → Package Dependencies
2. Check target membership: Select target → General → Frameworks
3. Clean and rebuild
```

## 📋 Key Differences from CocoaPods

| Task | CocoaPods (Old) | Swift Package Manager (New) |
|------|----------------|----------------------------|
| **Initial Setup** | `pod install` required | Automatic on build |
| **File to Open** | `.xcworkspace` | `.xcodeproj` |
| **Add Dependency** | Edit Podfile + `pod install` | Add in Xcode UI |
| **Update Dependencies** | `pod update` | File → Packages → Update |
| **Clean** | `pod deintegrate` + `pod install` | File → Packages → Reset Caches |
| **Generated Files** | Pods/, .xcworkspace | .swiftpm/ (in .gitignore) |

## 🚫 Don't Do This Anymore

~~`pod install`~~ - Not needed
~~`pod update`~~ - Use Xcode instead
~~`open SzContext.xcworkspace`~~ - Open .xcodeproj instead
~~Edit Podfile~~ - Add packages in Xcode

## ✅ Current Dependencies

| Package | Version | Repository |
|---------|---------|-----------|
| Sparkle | 2.0+ | https://github.com/sparkle-project/Sparkle |

## 🔍 Where Are My Dependencies?

**Cached Location:**
```
~/Library/Developer/Xcode/DerivedData/
```

**Project References:**
```
SzContext.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/
```

You don't need to manually manage these - Xcode handles it automatically.

## 💡 Pro Tips

1. **No more `pod install`** - Just pull and build
2. **Packages resolve automatically** - First build might take longer
3. **Clean is your friend** - When in doubt, clean and rebuild
4. **Use Xcode for package management** - Don't edit project files manually
5. **Cached downloads** - Packages download once, shared across projects

## 🆘 Need Help?

1. Check [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed instructions
2. Review [WHY_SPM_MIGRATION.md](WHY_SPM_MIGRATION.md) for context
3. Use [SPM_MIGRATION_CHECKLIST.md](SPM_MIGRATION_CHECKLIST.md) if migrating
4. Open an issue on GitHub
5. Apple's SPM docs: https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app

## 📱 CI/CD Changes

If you maintain CI/CD:

**Remove:**
```yaml
- pod install  # Not needed anymore
```

**Keep:**
```yaml
- xcodebuild ...  # Packages resolve automatically during build
```

## 🎯 Remember

- **Open**: `SzContext.xcodeproj` (not workspace)
- **No `pod install` needed** - Ever!
- **Dependencies resolve automatically** - On first build
- **File → Packages** - For all package operations

---

**Questions?** See the full migration guide or open an issue!
