#!/bin/bash

# LittleTask for Mac Build Script

set -e

echo "🔨 Building LittleTask for Mac..."

# Clean previous builds
echo "Cleaning previous builds..."
swift package clean

# Build the executable
echo "Building executable..."
swift build -c release

# Create app bundle
echo "Creating app bundle..."
rm -rf LittleTask.app
mkdir -p LittleTask.app/Contents/MacOS
mkdir -p LittleTask.app/Contents/Resources

# Copy executable
cp .build/release/LittleTask LittleTask.app/Contents/MacOS/

# Create Info.plist
cat > LittleTask.app/Contents/Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>LittleTask</string>
    <key>CFBundleIdentifier</key>
    <string>com.littletask.app</string>
    <key>CFBundleName</key>
    <string>LittleTask</string>
    <key>CFBundleDisplayName</key>
    <string>LittleTask</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHumanReadableCopyright</key>
    <string>© 2024 LittleTask</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSUIElement</key>
    <false/>
    <key>NSAppleEventsUsageDescription</key>
    <string>LittleTask needs access to control other applications for automation.</string>
    <key>NSAccessibilityUsageDescription</key>
    <string>LittleTask needs accessibility access to record and replay user actions.</string>
</dict>
</plist>
EOF

echo "✅ Build complete!"
echo "📦 App bundle created: LittleTask.app"
echo "🚀 To run: open LittleTask.app or ./LittleTask.app/Contents/MacOS/LittleTask"

# Make the script executable
chmod +x LittleTask.app/Contents/MacOS/LittleTask

# Create distributable DMG
echo "📦 Creating distributable DMG..."
rm -f LittleTask-v1.0.0.dmg
hdiutil create -volname "LittleTask" -srcfolder LittleTask.app -ov -format UDZO LittleTask-v1.0.0.dmg

echo ""
echo "✅ Distribution package created: LittleTask-v1.0.0.dmg"
echo "⚠️  Note: You'll need to grant Accessibility permissions to use LittleTask."
echo "   Go to System Settings > Privacy & Security > Accessibility" 