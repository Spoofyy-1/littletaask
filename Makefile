.PHONY: build run clean install

# Default target
all: build

# Build the application
build:
	swift build -c release

# Run the application in debug mode
run:
	swift run

# Clean build artifacts
clean:
	swift package clean

# Install to /usr/local/bin (requires sudo)
install: build
	sudo cp .build/release/LittleTask /usr/local/bin/

# Create an app bundle (basic version)
app: build
	mkdir -p LittleTask.app/Contents/MacOS
	mkdir -p LittleTask.app/Contents/Resources
	cp .build/release/LittleTask LittleTask.app/Contents/MacOS/
	echo '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n<plist version="1.0">\n<dict>\n\t<key>CFBundleExecutable</key>\n\t<string>LittleTask</string>\n\t<key>CFBundleIdentifier</key>\n\t<string>com.littletask.app</string>\n\t<key>CFBundleName</key>\n\t<string>LittleTask</string>\n\t<key>CFBundleVersion</key>\n\t<string>1.0.0</string>\n\t<key>CFBundleShortVersionString</key>\n\t<string>1.0.0</string>\n\t<key>LSMinimumSystemVersion</key>\n\t<string>13.0</string>\n\t<key>NSHumanReadableCopyright</key>\n\t<string>© 2024 LittleTask</string>\n</dict>\n</plist>' > LittleTask.app/Contents/Info.plist

# Help target
help:
	@echo "Available targets:"
	@echo "  build    - Build the application"
	@echo "  run      - Run the application in debug mode"
	@echo "  clean    - Clean build artifacts"
	@echo "  install  - Install to /usr/local/bin (requires sudo)"
	@echo "  app      - Create a basic app bundle"
	@echo "  help     - Show this help message" 