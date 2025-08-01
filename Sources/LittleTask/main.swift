import SwiftUI
import AppKit

struct LittleTaskApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 350, maxWidth: 500, minHeight: 200, maxHeight: 300)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(after: .appInfo) {
                Button("Record/Stop") {
                    AutomationManager.shared.toggleRecording()
                }
                .keyboardShortcut("r", modifiers: .command)
                
                Button("Play/Stop") {
                    AutomationManager.shared.togglePlayback()
                }
                .keyboardShortcut("p", modifiers: .command)
                
                Button("Clear Recording") {
                    AutomationManager.shared.clearRecording()
                }
                .keyboardShortcut(.delete, modifiers: .command)
                
                Divider()
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Check for accessibility permissions on startup
        DispatchQueue.main.async {
            AutomationManager.shared.checkAccessibilityPermissions()
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

// Main entry point
LittleTaskApp.main() 