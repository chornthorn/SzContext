# SzContext
You may download it from Mac App Store 

[<img src="https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-mac-app-store.svg">](https://apps.apple.com/us/app/szcontext/id1547864620?mt=12)

or download from [latest release](https://github.com/RoadToDream/SzContext/releases/latest). Non App Store version is using Sparkle to realize automatic update.

## Description
Provides your favorite apps at your hands. 
Open files or folders using your favorite app from Finder® context menu. 
[<img src="https://github.com/RoadToDream/SzContext/blob/main/images/basic_video_screenshot.png">](https://user-images.githubusercontent.com/8088354/106392932-eacea980-63a8-11eb-891e-d027753aa1dc.mp4
)
[<img src="https://github.com/RoadToDream/SzContext/blob/main/images/fantastic_video_screenshot.png">](https://user-images.githubusercontent.com/8088354/106392933-eb674000-63a8-11eb-9616-4b0ba51a1139.mp4
)


## System compatibility 
macOS 10.15+ 

## Preview
**Light**
![SzContextDropdown](images/SzContextLight.png)

**Dark**
![SzContextDropdown](images/SzContextDark.png)

## Installation
Download dmg file from [latest release](https://github.com/RoadToDream/SzContext/releases/latest), drag SzContext.app to Application folder. Open SzContext.app and follow the instructions.
![SzContextSystemPreference](images/SzContextLightIntro.png)

## Development

### Building from Source

This project uses **Swift Package Manager** for dependency management.

#### Prerequisites
- Xcode 12.0 or later
- macOS 10.15 or later
- Swift 5.0 or later

#### Dependencies
- [Sparkle](https://github.com/sparkle-project/Sparkle) - Framework for automatic app updates (Non-App Store version only)

#### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/chornthorn/SzContext.git
   cd SzContext
   ```

2. Open the project in Xcode:
   ```bash
   open SzContext.xcodeproj
   ```

3. Dependencies will be automatically resolved by Swift Package Manager when you first open or build the project.

4. Select your target and build (⌘B)

#### Migration from CocoaPods

This project has been migrated from CocoaPods to Swift Package Manager. If you have an older version of the project, please refer to [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed migration instructions.

#### Project Structure

This project follows Swift Package Manager standard folder structure:

```
SzContext/
├── Sources/                    # All source code (SPM standard)
│   ├── SzContextShared/       # Shared library
│   ├── SzContextApp/          # Main application
│   ├── SzContextExtension/    # Finder Sync Extension
│   └── SzContextHelper/       # XPC Helper Service
├── Tests/                      # Test suites
│   └── SzContextTests/
├── Package.swift               # SPM manifest
└── SzContext.xcodeproj/       # Xcode project
```

For more details on the structure, see [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md).

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.


