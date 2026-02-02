# SzContext Tests

This directory contains unit tests for the SzContext Swift Package Manager migration.

## Test Structure

### Test Files

1. **SzContextTests.swift**
   - Tests for project structure and migration validation
   - Tests for shared module functionality (Constants, Utilities)
   - Tests for enumerations (TerminalID, EditorID)
   - Performance tests for path checking operations

2. **DependencyResolutionTests.swift**
   - Tests for Package.swift configuration
   - Tests for dependency declarations (Sparkle)
   - Tests for migration cleanup verification
   - Tests for build system compatibility

## Running Tests

### On macOS with Xcode

```bash
# Open the project in Xcode
open SzContext.xcodeproj

# Run tests in Xcode
# Product → Test (⌘U)
```

### On macOS with Swift CLI

```bash
# Run all tests
swift test

# Run specific test suite
swift test --filter SzContextMigrationTests

# Run specific test
swift test --filter testConstants
```

### Validation Script

For complete migration validation:

```bash
# Run the validation script
./validate_spm_migration.sh
```

## Test Coverage

The tests verify:

✅ **Package Structure**
- Package.swift exists and is properly configured
- Shared module structure is correct
- Test infrastructure is set up

✅ **Migration Validation**
- .gitignore includes SPM artifacts
- Migration documentation exists
- Cleanup scripts are available

✅ **Functionality**
- Constants are properly defined
- Enumerations work correctly
- String extensions function as expected

✅ **Build System**
- Swift version compatibility
- macOS platform targeting
- Dependency resolution

## Test Requirements

- macOS 10.15 or later
- Xcode 12.0 or later (for Xcode testing)
- Swift 5.9 or later (for CLI testing)

## Adding New Tests

To add new tests:

1. Create a new test class inheriting from `XCTestCase`
2. Add test methods prefixed with `test`
3. Import necessary modules:
   ```swift
   import XCTest
   @testable import SzContextShared
   ```

Example:

```swift
class MyNewTests: XCTestCase {
    func testSomething() {
        XCTAssertTrue(true, "Test description")
    }
}
```

## Continuous Integration

These tests can be run in CI/CD on macOS runners:

```yaml
# Example GitHub Actions
- name: Run Tests
  run: swift test
```

## Troubleshooting

### Tests Don't Run

- Ensure you're on macOS (tests require macOS APIs)
- Verify Xcode is installed: `xcodebuild -version`
- Check Swift version: `swift --version`

### Import Errors

- Ensure Package.swift is properly configured
- Run `swift package resolve` to fetch dependencies
- Clean build folder: `swift package clean`

### Failed Tests

- Check if migration steps were completed
- Verify .gitignore has SPM entries
- Ensure Package.swift has required configuration

## Documentation

For more information on the migration:

- [START_HERE.md](../START_HERE.md) - Quick start guide
- [MIGRATION_GUIDE.md](../MIGRATION_GUIDE.md) - Detailed migration steps
- [SPM_QUICK_REFERENCE.md](../SPM_QUICK_REFERENCE.md) - Daily reference

## Contributing

When adding tests:

1. Follow existing test patterns
2. Add descriptive test names
3. Include XCTAssert messages
4. Update this README if adding new test files
5. Ensure tests run on macOS

## Test Maintenance

Run tests regularly to ensure:

- Migration documentation stays accurate
- Package.swift configuration is valid
- Dependencies resolve correctly
- Build system works as expected

---

**Note**: These tests validate the Swift Package Manager migration. The main application tests would be separate and test application functionality.
