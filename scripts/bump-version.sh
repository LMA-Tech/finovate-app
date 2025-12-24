#!/bin/bash

# Version Bump Script for Flutter
# Usage: ./scripts/bump-version.sh [major|minor|patch]
#
# Examples:
#   ./scripts/bump-version.sh patch   # 1.1.0+2 → 1.1.1+3
#   ./scripts/bump-version.sh minor   # 1.1.0+2 → 1.2.0+3
#   ./scripts/bump-version.sh major   # 1.1.0+2 → 2.0.0+3

set -e

PUBSPEC="pubspec.yaml"

# Check if pubspec.yaml exists
if [ ! -f "$PUBSPEC" ]; then
    echo "Error: $PUBSPEC not found. Run this script from the project root."
    exit 1
fi

# Get current version
CURRENT_VERSION=$(grep "^version:" "$PUBSPEC" | sed 's/version: //')
echo "Current version: $CURRENT_VERSION"

# Parse version parts
VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

MAJOR=$(echo "$VERSION_NAME" | cut -d'.' -f1)
MINOR=$(echo "$VERSION_NAME" | cut -d'.' -f2)
PATCH=$(echo "$VERSION_NAME" | cut -d'.' -f3)

# Increment based on argument
case "$1" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
    *)
        echo "Usage: $0 [major|minor|patch]"
        echo ""
        echo "  major  - Breaking changes (1.0.0 → 2.0.0)"
        echo "  minor  - New features (1.0.0 → 1.1.0)"
        echo "  patch  - Bug fixes (1.0.0 → 1.0.1)"
        exit 1
        ;;
esac

# Always increment build number
NEW_BUILD=$((BUILD_NUMBER + 1))
NEW_VERSION="$MAJOR.$MINOR.$PATCH+$NEW_BUILD"

echo "New version: $NEW_VERSION"

# Update pubspec.yaml
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC"
else
    # Linux
    sed -i "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC"
fi

echo "✓ Updated $PUBSPEC"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff pubspec.yaml"
echo "  2. Commit: git add pubspec.yaml && git commit -m \"chore: bump version to $NEW_VERSION\""
echo "  3. Push to trigger build"
