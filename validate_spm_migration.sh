#!/bin/bash

# SPM Migration Validation Script
# Run this script on macOS after performing the SPM migration in Xcode
# This validates that the migration was successful

set -e

echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                              ║"
echo "║      SPM Migration Validation Script                                        ║"
echo "║                                                                              ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This script must be run on macOS"
    echo "   The SzContext project is a macOS-only application"
    exit 1
fi

echo "✅ Running on macOS"
echo ""

# Check if swift is available
if ! command -v swift &> /dev/null; then
    echo "❌ Error: Swift is not installed"
    echo "   Please install Xcode from the App Store"
    exit 1
fi

echo "✅ Swift is available"
swift --version
echo ""

# Check if Package.swift exists
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Package.swift not found"
    echo "   Please ensure you're in the project root directory"
    exit 1
fi

echo "✅ Package.swift exists"
echo ""

# Validate Package.swift can be resolved
echo "📦 Resolving Swift Package Dependencies..."
if swift package resolve; then
    echo "✅ Package dependencies resolved successfully"
else
    echo "❌ Failed to resolve package dependencies"
    exit 1
fi
echo ""

# Try to build the package (this tests if the package structure is valid)
echo "🔨 Building Swift Package..."
if swift build --target SzContextShared; then
    echo "✅ Package built successfully"
else
    echo "⚠️  Package build failed (this is expected if Xcode project files haven't been updated)"
    echo "   Continue with manual Xcode migration steps"
fi
echo ""

# Run tests if available
echo "🧪 Running Tests..."
if swift test; then
    echo "✅ All tests passed"
else
    echo "⚠️  Some tests failed or could not run"
    echo "   Check test output above for details"
fi
echo ""

# Check migration documentation exists
echo "📚 Checking Migration Documentation..."
DOCS=("MIGRATION_GUIDE.md" "SPM_QUICK_REFERENCE.md" "WHY_SPM_MIGRATION.md" "START_HERE.md")
for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        echo "  ✅ $doc"
    else
        echo "  ❌ $doc missing"
    fi
done
echo ""

# Check if .gitignore has SPM entries
echo "📝 Checking .gitignore..."
if grep -q ".swiftpm/" .gitignore && grep -q ".build/" .gitignore; then
    echo "✅ .gitignore includes SPM artifacts"
else
    echo "⚠️  .gitignore may need updating for SPM"
fi
echo ""

# Check cleanup status
echo "🧹 Checking CocoaPods Cleanup Status..."
if [ -d "Pods" ]; then
    echo "  ⚠️  Pods directory still exists (run cleanup_cocoapods.sh)"
else
    echo "  ✅ Pods directory removed"
fi

if [ -f "Podfile" ]; then
    echo "  ⚠️  Podfile still exists (run cleanup_cocoapods.sh)"
else
    echo "  ✅ Podfile removed"
fi

if [ -f "Podfile.lock" ]; then
    echo "  ⚠️  Podfile.lock still exists (run cleanup_cocoapods.sh)"
else
    echo "  ✅ Podfile.lock removed"
fi

if [ -d "SzContext.xcworkspace" ]; then
    echo "  ⚠️  .xcworkspace still exists (optional: can be removed)"
else
    echo "  ✅ .xcworkspace removed"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Validation Summary"
echo ""
echo "Next Steps:"
echo "  1. If CocoaPods files remain, run: ./cleanup_cocoapods.sh"
echo "  2. Open SzContext.xcodeproj in Xcode (not .xcworkspace)"
echo "  3. Build the project (⌘B) to verify everything works"
echo "  4. Run the app to test functionality"
echo "  5. Commit the changes to git"
echo ""
echo "For more information, see:"
echo "  - START_HERE.md for quick start"
echo "  - MIGRATION_GUIDE.md for detailed steps"
echo "  - SPM_QUICK_REFERENCE.md for daily use"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
