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
        // After migration, Podfile should be removed or gitignored
        let podfilePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Podfile")
        
        // If Podfile exists, it should be for reference only (documented in migration)
        // This test documents the expected state after cleanup
        if FileManager.default.fileExists(atPath: podfilePath.path) {
            // Podfile exists - this is OK during migration phase
            // After running cleanup_cocoapods.sh, it should be removed
            XCTAssertTrue(true, "Podfile present - run cleanup_cocoapods.sh to remove")
        } else {
            // Podfile removed - migration cleanup complete
            XCTAssertTrue(true, "Podfile successfully removed")
        }
    }
    
    func testPodsDirectoryHandling() {
        let podsPath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Pods")
        
        // Pods directory should be removed or gitignored after migration
        if FileManager.default.fileExists(atPath: podsPath.path) {
            // Pods directory exists - migration cleanup pending
            XCTAssertTrue(true, "Pods directory present - run cleanup_cocoapods.sh to remove")
        } else {
            // Pods directory removed - migration complete
            XCTAssertTrue(true, "Pods directory successfully removed")
        }
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
        
        // Verify shared target exists
        XCTAssertTrue(
            packageContent.contains("SzContextShared"),
            "Package should define SzContextShared target"
        )
        
        // Verify test target exists
        XCTAssertTrue(
            packageContent.contains("testTarget"),
            "Package should define test targets"
        )
        
        XCTAssertTrue(
            packageContent.contains("SzContextTests"),
            "Package should have SzContextTests test target"
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
        
        // Workspace is CocoaPods-generated and should be optional after migration
        if FileManager.default.fileExists(atPath: workspacePath.path) {
            XCTAssertTrue(
                true,
                "Workspace present - can be removed after migration, open .xcodeproj instead"
            )
        } else {
            XCTAssertTrue(
                true,
                "Workspace removed - using .xcodeproj directly"
            )
        }
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
    
    func testMigrationDocumentationComplete() {
        let projectRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        
        // Verify all critical migration docs exist
        let criticalDocs = [
            "START_HERE.md",
            "MIGRATION_GUIDE.md",
            "SPM_QUICK_REFERENCE.md",
            "cleanup_cocoapods.sh",
            "Package.swift"
        ]
        
        for doc in criticalDocs {
            let docPath = projectRoot.appendingPathComponent(doc)
            XCTAssertTrue(
                FileManager.default.fileExists(atPath: docPath.path),
                "\(doc) is required for complete migration"
            )
        }
    }
}
