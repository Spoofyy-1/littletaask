# LittleTask 🤖

A lightweight, native macOS automation tool inspired by the original TinyTask for Windows. Record and replay mouse movements, clicks, and keyboard inputs with ease!

**[🌐 Live Website](https://littletaask.vercel.app) • [⬇️ Download](https://github.com/Spoofyy-1/littletaask/releases)**

## Features

- 🎬 **Record & Replay**: Capture any sequence of mouse and keyboard actions
- ⚡ **Variable Speed**: Adjust playback speed from 0.1x to 5.0x
- 💾 **Save & Load**: Store recordings as JSON files for later use
- 🖼️ **Always on Top**: Keep the app visible while working
- 🔒 **Privacy-First**: All processing happens locally on your Mac
- 🪶 **Lightweight**: Built with Swift for optimal performance

## Quick Start

### Download & Install

1. **Download the latest release:**
   ```bash
   # Clone and build from source:
   git clone https://github.com/your-username/littletask.git
   cd littletask
   ./build.sh
   ```

2. **Install and run:**
   ```bash
   open LittleTask.app
   ```

3. **Grant permissions:** When prompted, add LittleTask to Accessibility in System Settings

### Usage

1. **Record:** Click the Record button (🔴) and perform your actions
2. **Play:** Click Play (▶️) to replay your recorded sequence  
3. **Save:** Export recordings as `.json` files for reuse
4. **Speed Control:** Adjust playback speed with the slider

## Distribution

### Building for Distribution

The project includes an automated build script that creates both the app bundle and a distributable DMG:

```bash
./build.sh
```

This creates:
- `LittleTask.app` - The application bundle
- `LittleTask-v1.0.0.dmg` - Distributable disk image

### Website

A professional landing page is included at `website/index.html`. Features:
- Modern, responsive design
- Download button with progress feedback
- Feature showcase
- System requirements
- Mobile-optimized layout

To serve the website locally:
```bash
cd website
python3 -m http.server 8000
# Visit http://localhost:8000
```

## System Requirements

- macOS 13.0 (Ventura) or later
- Apple Silicon (M1/M2/M3) or Intel Mac
- 10 MB free disk space
- Accessibility permissions (granted during setup)

## Architecture

### Project Structure
```
LittleTask/
├── Sources/LittleTask/          # Swift source files
│   ├── main.swift              # Application entry point
│   ├── ContentView.swift       # Main UI
│   ├── AutomationManager.swift # Core recording/playback logic
│   ├── AutomationAction.swift  # Data structures
│   └── TaskDocument.swift      # File handling
├── website/                    # Landing page
│   └── index.html             # Marketing website
├── build.sh                   # Distribution build script
├── Package.swift              # Swift Package Manager config
└── README.md                  # This file
```

### Technical Implementation
- **Swift 5.8+**: Native performance and system integration
- **SwiftUI**: Modern, declarative user interface
- **Core Graphics**: Low-level event handling and simulation
- **Accessibility APIs**: Secure input monitoring and control
- **JSON Storage**: Cross-platform recording format

## Development

### Building for Development
```bash
swift build                   # Debug build
swift run                     # Run in debug mode
swift package generate-xcodeproj  # Generate Xcode project
```

### Testing
```bash
# Build and test the app
./build.sh
open LittleTask.app

# Test the website
cd website && python3 -m http.server 8000
```

## Distribution Checklist

Before releasing a new version:

- [ ] Update version number in `build.sh` 
- [ ] Update version in `website/index.html`
- [ ] Test app bundle creation: `./build.sh`
- [ ] Test DMG creation and mounting
- [ ] Verify accessibility permissions workflow
- [ ] Test website download flow
- [ ] Create GitHub release with DMG file
- [ ] Update download links

## Privacy & Security

LittleTask prioritizes user privacy:
- ✅ All processing happens locally on your Mac
- ✅ No data sent to external servers
- ✅ Open source - fully auditable code
- ✅ Minimal permissions (only Accessibility)
- ✅ Transparent about what data is accessed

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly (including website)
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the original TinyTask for Windows by Tamir Khason
- Built with ❤️ for the Mac automation community
- Uses Apple's Accessibility APIs for secure system integration 