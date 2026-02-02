//
//  DependencyResolutionTests.swift
//  SzContextTests
//
//  Tests for verifying dependency resolution after SPM migration
//

import XCTest

/// Tests to verify dependencies are properly resolved in SPM
class DependencyResolutionTests: XCTestCase {
    
    // MARK: - Dependency Configuration Tests
    
    func testPackageSwiftConfiguration() {
        let packagePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Package.swift")
        
        guard let packageContent = try? String(contentsOf: packagePath) else {
            XCTFail("Package.swift should be readable")
            return
        }
        
        // Verify package name
        XCTAssertTrue(
            packageContent.contains("name: \"SzContext\""),
            "Package should be named SzContext"
        )
        
        // Verify platform requirement
        XCTAssertTrue(
            packageContent.contains(".macOS(.v10_15)") || packageContent.contains(".macOS(.v11)"),
            "Package should target macOS 10.15 or higher"
        )
        
        // Verify Sparkle dependency
        XCTAssertTrue(
            packageContent.contains("sparkle-project/Sparkle"),
            "Package should declare Sparkle dependency"
        )
    }
    
    func testSparkleVersionRequirement() {
        let packagePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Package.swift")
        
        guard let packageContent = try? String(contentsOf: packagePath) else {
            XCTFail("Package.swift should be readable")
            return
        }
        
        // Verify Sparkle version is 2.0.0 or higher (required for SPM)
        XCTAssertTrue(
            packageContent.contains("from: \"2.0.0\"") || 
            packageContent.contains("from: \"2.") ||
            packageContent.contains(".upToNextMajor(from: \"2.0.0\")"),
            "Sparkle should be version 2.0.0+ for SPM support"
        )
    }
    
    // MARK: - Migration Cleanup Tests
    
    func testPodfileNotInRepository() {
        // After full SPM migration, Podfile should be completely removed
        let podfilePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Podfile")
        
        // Podfile should not exist - migration is complete
        XCTAssertFalse(
            FileManager.default.fileExists(atPath: podfilePath.path),
            "Podfile should be removed after complete SPM migration"
        )
    }
    
    func testPodsDirectoryHandling() {
        let podsPath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Pods")
        
        // Pods directory should not exist - migration is complete
        XCTAssertFalse(
            FileManager.default.fileExists(atPath: podsPath.path),
            "Pods directory should be removed after complete SPM migration"
        )
    }
    
    // MARK: - Build Configuration Tests
    
    func testSwiftToolsVersion() {
        let packagePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Package.swift")
        
        guard let packageContent = try? String(contentsOf: packagePath) else {
            XCTFail("Package.swift should be readable")
            return
        }
        
        // Verify swift-tools-version is specified
        XCTAssertTrue(
            packageContent.contains("swift-tools-version"),
            "Package.swift should specify swift-tools-version"
        )
        
        // Should be 5.9 or higher for modern SPM features
        XCTAssertTrue(
            packageContent.contains("swift-tools-version:5.9") ||
            packageContent.contains("swift-tools-version:5.10") ||
            packageContent.contains("swift-tools-version:6"),
            "Swift tools version should be 5.9 or higher"
        )
    }
    
    func testTargetStructure() {
        let packagePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Package.swift")
        
        guard let packageContent = try? String(contentsOf: packagePath) else {
            XCTFail("Package.swift should be readable")
            return
        }
        
        // Verify all targets exist
        let expectedTargets = [
            "SzContextShared",
            "SzContextApp",
            "SzContextExtension",
            "SzContextHelper"
        ]
        
        for target in expectedTargets {
            XCTAssertTrue(
                packageContent.contains(target),
                "Package should define \(target) target"
            )
        }
        
        // Verify test target exists
        XCTAssertTrue(
            packageContent.contains("testTarget"),
            "Package should define test targets"
        )
        
        XCTAssertTrue(
            packageContent.contains("SzContextTests"),
            "Package should have SzContextTests test target"
        )
        
        // Verify Sources paths
        XCTAssertTrue(
            packageContent.contains("Sources/SzContextShared"),
            "Package should reference Sources/SzContextShared path"
        )
    }
    
    // MARK: - Workspace Tests
    
    func testXcodeProjectExists() {
        let projectPath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("SzContext.xcodeproj")
        
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: projectPath.path),
            "Xcode project should still exist (SPM is complementary)"
        )
    }
    
    func testWorkspaceHandling() {
        let workspacePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("SzContext.xcworkspace")
        
        // Workspace is CocoaPods-generated and should be removed after full migration
        XCTAssertFalse(
            FileManager.default.fileExists(atPath: workspacePath.path),
            "Workspace should be removed - use .xcodeproj directly after SPM migration"
        )
    }
}

// MARK: - Integration Tests

extension DependencyResolutionTests {
    
    func testPackageCanBeResolved() {
        // This test validates that the Package.swift is syntactically correct
        // by attempting to read and parse its structure
        let packagePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Package.swift")
        
        do {
            let packageContent = try String(contentsOf: packagePath)
            
            // Basic validation that it's a valid Swift package manifest
            XCTAssertTrue(packageContent.contains("import PackageDescription"))
            XCTAssertTrue(packageContent.contains("let package = Package"))
            XCTAssertTrue(packageContent.contains("targets:"))
            XCTAssertTrue(packageContent.contains("dependencies:"))
            
        } catch {
            XCTFail("Failed to read Package.swift: \(error)")
        }
    }
    
    func testMigrationComplete() {
        let projectRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        
        // Verify Package.swift exists (the only critical file for SPM)
        let packagePath = projectRoot.appendingPathComponent("Package.swift")
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: packagePath.path),
            "Package.swift is required for SPM"
        )
        
        // Verify migration artifacts are removed
        let removedFiles = [
            "Podfile",
            "Podfile.lock",
            "cleanup_cocoapods.sh",
            "validate_spm_migration.sh"
        ]
        
        for file in removedFiles {
            let filePath = projectRoot.appendingPathComponent(file)
            XCTAssertFalse(
                FileManager.default.fileExists(atPath: filePath.path),
                "\(file) should be removed after complete migration"
            )
        }
        
        // Verify Pods directory is removed
        let podsPath = projectRoot.appendingPathComponent("Pods")
        XCTAssertFalse(
            FileManager.default.fileExists(atPath: podsPath.path),
            "Pods directory should be removed after complete migration"
        )
    }
}
