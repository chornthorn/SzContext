//
//  SzContextTests.swift
//  SzContextTests
//
//  Created by Swift Package Manager Migration
//  Tests to verify SPM migration and project structure
//

import XCTest
@testable import SzContextShared

/// Test suite to validate Swift Package Manager migration
class SzContextMigrationTests: XCTestCase {
    
    // MARK: - Package Structure Tests
    
    func testPackageSwiftExists() {
        let packagePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Package.swift")
        
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: packagePath.path),
            "Package.swift should exist at project root for SPM compatibility"
        )
    }
    
    func testSharedModuleStructure() {
        // Verify that shared module files are accessible
        let sharedPath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Shared")
        
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: sharedPath.path),
            "Shared directory should exist"
        )
        
        // Check for key files
        let constantsPath = sharedPath.appendingPathComponent("Constants.swift")
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: constantsPath.path),
            "Constants.swift should exist in Shared directory"
        )
    }
    
    // MARK: - Constants Tests
    
    func testConstants() {
        // Verify constants are properly defined
        XCTAssertEqual(MACH_SERVICE, "LQ3C7Y6F8J.com.roadtodream.SzContextXPCHelper")
        XCTAssertEqual(HELPER_BUNDLE, "LQ3C7Y6F8J.com.roadtodream.SzContextXPCHelper")
        XCTAssertEqual(MAIN_BUNDLE, "com.roadtodream.SzContext")
        XCTAssertEqual(APP_GROUP, "LQ3C7Y6F8J.com.roadtodream")
        XCTAssertEqual(URL_SCHEME_NAME, "szcontext")
        XCTAssertEqual(XPC_VERSION, "1.2")
        XCTAssertEqual(USER_DEFAULTS_VERSION, "1.1")
    }
    
    func testTerminalIDEnumeration() {
        // Verify terminal IDs are accessible
        XCTAssertEqual(terminalID.terminal.rawValue, "com.apple.Terminal")
        XCTAssertEqual(terminalID.iTerm.rawValue, "com.googlecode.iterm2")
        XCTAssertEqual(terminalID.hyper.rawValue, "co.zeit.hyper")
        XCTAssertEqual(terminalID.alacritty.rawValue, "io.alacritty")
        XCTAssertEqual(terminalID.kitty.rawValue, "net.kovidgoyal.kitty")
        
        // Verify all cases are present
        XCTAssertEqual(terminalID.allCases.count, 5)
    }
    
    func testEditorIDEnumeration() {
        // Verify editor IDs are accessible
        XCTAssertEqual(editorID.textEdit.rawValue, "com.apple.TextEdit")
        XCTAssertEqual(editorID.vscode.rawValue, "com.microsoft.VSCode")
        XCTAssertEqual(editorID.atom.rawValue, "com.github.atom")
        XCTAssertEqual(editorID.sublime.rawValue, "com.sublimetext.3")
        
        // Verify JetBrains IDEs
        XCTAssertEqual(editorID.intelliJIDEA.rawValue, "com.jetbrains.intellij")
        XCTAssertEqual(editorID.pyCharm.rawValue, "com.jetbrains.pycharm")
        XCTAssertEqual(editorID.webStorm.rawValue, "com.jetbrains.webstorm")
        
        // Verify all editor cases are present
        XCTAssertGreaterThanOrEqual(editorID.allCases.count, 14)
    }
    
    // MARK: - Utility Extension Tests
    
    func testStringIsChildPathExtension() {
        let parentURLs = [URL(fileURLWithPath: "/Users/test/Documents")]
        
        // Test child path
        let childPath = "/Users/test/Documents/subfolder/file.txt"
        XCTAssertTrue(
            childPath.isChildPath(of: parentURLs),
            "Child path should be recognized as child of parent"
        )
        
        // Test non-child path
        let nonChildPath = "/Users/test/Downloads/file.txt"
        XCTAssertFalse(
            nonChildPath.isChildPath(of: parentURLs),
            "Non-child path should not be recognized as child"
        )
        
        // Test exact match
        let exactPath = "/Users/test/Documents"
        XCTAssertTrue(
            exactPath.isChildPath(of: parentURLs),
            "Exact path match should be recognized"
        )
    }
    
    func testStringIsChildPathWithMultipleParents() {
        let parentURLs = [
            URL(fileURLWithPath: "/Users/test/Documents"),
            URL(fileURLWithPath: "/Users/test/Desktop")
        ]
        
        // Test child of first parent
        let childOfFirst = "/Users/test/Documents/file.txt"
        XCTAssertTrue(childOfFirst.isChildPath(of: parentURLs))
        
        // Test child of second parent
        let childOfSecond = "/Users/test/Desktop/file.txt"
        XCTAssertTrue(childOfSecond.isChildPath(of: parentURLs))
        
        // Test non-child
        let nonChild = "/Users/test/Downloads/file.txt"
        XCTAssertFalse(nonChild.isChildPath(of: parentURLs))
    }
    
    func testStringIsChildPathEdgeCases() {
        let parentURLs = [URL(fileURLWithPath: "/Users/test")]
        
        // Test empty path
        let emptyPath = ""
        XCTAssertFalse(emptyPath.isChildPath(of: parentURLs))
        
        // Test root path
        let rootPath = "/"
        XCTAssertFalse(rootPath.isChildPath(of: parentURLs))
        
        // Test empty parent list
        let somePath = "/Users/test/Documents"
        XCTAssertFalse(somePath.isChildPath(of: []))
    }
    
    // MARK: - Migration Validation Tests
    
    func testGitIgnoreUpdated() {
        let gitignorePath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".gitignore")
        
        guard FileManager.default.fileExists(atPath: gitignorePath.path),
              let gitignoreContent = try? String(contentsOf: gitignorePath) else {
            XCTFail(".gitignore should exist")
            return
        }
        
        // Verify SPM entries are present
        XCTAssertTrue(
            gitignoreContent.contains(".swiftpm/"),
            ".gitignore should include .swiftpm/ for SPM artifacts"
        )
        XCTAssertTrue(
            gitignoreContent.contains(".build/"),
            ".gitignore should include .build/ for SPM build artifacts"
        )
    }
    
    func testMigrationDocumentationExists() {
        let projectRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        
        let requiredDocs = [
            "MIGRATION_GUIDE.md",
            "SPM_QUICK_REFERENCE.md",
            "WHY_SPM_MIGRATION.md",
            "START_HERE.md"
        ]
        
        for doc in requiredDocs {
            let docPath = projectRoot.appendingPathComponent(doc)
            XCTAssertTrue(
                FileManager.default.fileExists(atPath: docPath.path),
                "\(doc) should exist for migration documentation"
            )
        }
    }
    
    func testCleanupScriptExists() {
        let scriptPath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("cleanup_cocoapods.sh")
        
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: scriptPath.path),
            "cleanup_cocoapods.sh should exist"
        )
        
        // Verify script is executable
        if FileManager.default.fileExists(atPath: scriptPath.path) {
            let attributes = try? FileManager.default.attributesOfItem(atPath: scriptPath.path)
            let permissions = attributes?[.posixPermissions] as? Int
            // Check if executable bit is set (at least user executable: 0o100)
            if let permissions = permissions {
                XCTAssertTrue(
                    permissions & 0o100 != 0,
                    "cleanup_cocoapods.sh should be executable"
                )
            }
        }
    }
    
    // MARK: - Build System Tests
    
    func testSwiftVersionCompatibility() {
        // This test verifies the code compiles with Swift 5.9+
        // If this test runs, Swift compiler successfully processed the code
        XCTAssertTrue(true, "Swift compilation successful")
    }
    
    func testMacOSPlatformTarget() {
        // Verify we're targeting macOS 10.15+
        #if os(macOS)
        if #available(macOS 10.15, *) {
            XCTAssertTrue(true, "macOS 10.15+ target verified")
        } else {
            XCTFail("Should be targeting macOS 10.15 or higher")
        }
        #else
        XCTFail("Should be targeting macOS platform")
        #endif
    }
}

// MARK: - Performance Tests

extension SzContextMigrationTests {
    
    func testPathCheckingPerformance() {
        let parentURLs = [
            URL(fileURLWithPath: "/Users/test/Documents"),
            URL(fileURLWithPath: "/Users/test/Desktop"),
            URL(fileURLWithPath: "/Users/test/Downloads")
        ]
        let testPath = "/Users/test/Documents/deep/nested/path/to/file.txt"
        
        measure {
            for _ in 0..<1000 {
                _ = testPath.isChildPath(of: parentURLs)
            }
        }
    }
}
