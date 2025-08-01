#!/bin/bash

# LittleTask Deployment Script

set -e

echo "🚀 LittleTask Deployment Script"
echo "==============================="

# Function to serve website locally
serve_website() {
    echo "🌐 Starting local web server..."
    cd website
    echo "📱 Website available at: http://localhost:8000"
    echo "   Press Ctrl+C to stop"
    python3 -m http.server 8000
}

# Function to create release
create_release() {
    echo "📦 Creating release package..."
    
    # Build the app
    ./build.sh
    
    # Create release directory
    mkdir -p releases/v1.0.0
    
    # Copy files to release
    cp LittleTask-v1.0.0.dmg releases/v1.0.0/
    cp README.md releases/v1.0.0/
    cp LICENSE releases/v1.0.0/
    
    # Create release notes
    cat > releases/v1.0.0/RELEASE_NOTES.md << EOF
# LittleTask v1.0.0

## What's New
- 🎬 Record and replay mouse movements, clicks, and keyboard inputs
- ⚡ Variable speed playback (0.1x to 5.0x)
- 💾 Save and load automation sequences as JSON files
- 🖼️ Always on top window mode
- 🔒 Privacy-first design - everything stays on your Mac
- 🪶 Lightweight native Swift application

## Installation
1. Download \`LittleTask-v1.0.0.dmg\`
2. Mount the disk image and drag LittleTask.app to Applications
3. Launch LittleTask and grant Accessibility permissions when prompted

## System Requirements
- macOS 13.0 (Ventura) or later
- Apple Silicon (M1/M2/M3) or Intel Mac
- 10 MB free disk space

## Known Issues
- First launch requires Accessibility permissions setup
- Some system-level actions may not be recordable for security reasons

## Support
- Open an issue on GitHub for bug reports
- Email: support@littletask.app
EOF

    echo "✅ Release package created in releases/v1.0.0/"
    echo "📄 Files included:"
    ls -la releases/v1.0.0/
}

# Function to update website download link
update_download_link() {
    local dmg_path="$1"
    if [ -f "$dmg_path" ]; then
        echo "🔗 Updating website download link..."
        # In a real deployment, this would update the download URL
        echo "   DMG file ready: $dmg_path"
        echo "   Size: $(du -h "$dmg_path" | cut -f1)"
    else
        echo "❌ DMG file not found: $dmg_path"
        exit 1
    fi
}

# Function to show help
show_help() {
    echo "Usage: ./deploy.sh [command]"
    echo ""
    echo "Commands:"
    echo "  serve     - Start local web server for website"
    echo "  release   - Create release package with DMG"
    echo "  upload    - Prepare files for upload to hosting"
    echo "  help      - Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./deploy.sh serve    # Test website locally"
    echo "  ./deploy.sh release  # Create release package"
}

# Main script logic
case "${1:-help}" in
    "serve")
        serve_website
        ;;
    "release")
        create_release
        update_download_link "LittleTask-v1.0.0.dmg"
        ;;
    "upload")
        echo "📤 Preparing files for upload..."
        if [ ! -f "LittleTask-v1.0.0.dmg" ]; then
            echo "Building DMG first..."
            ./build.sh
        fi
        
        mkdir -p upload
        cp website/index.html upload/
        cp LittleTask-v1.0.0.dmg upload/
        
        echo "✅ Files ready for upload in ./upload/"
        echo "   Upload index.html to your web host"
        echo "   Upload LittleTask-v1.0.0.dmg to downloads folder"
        ;;
    "help"|*)
        show_help
        ;;
esac 