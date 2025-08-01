import SwiftUI

struct ContentView: View {
    @StateObject private var automationManager = AutomationManager.shared
    @State private var isAlwaysOnTop = false
    @State private var playbackSpeed: Double = 1.0
    @State private var showingFileImporter = false
    @State private var showingFileExporter = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("LittleTask")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Status
            Text(automationManager.status)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            
            // Main Controls
            HStack(spacing: 15) {
                // Record Button
                Button(action: {
                    if automationManager.isRecording {
                        automationManager.stopRecording()
                    } else {
                        automationManager.startRecording()
                    }
                }) {
                    HStack {
                        Image(systemName: automationManager.isRecording ? "stop.circle.fill" : "record.circle")
                            .font(.title2)
                        Text(automationManager.isRecording ? "Stop" : "Record")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(automationManager.isRecording ? .red : .primary)
                    .frame(width: 80)
                }
                .buttonStyle(.borderedProminent)
                .tint(automationManager.isRecording ? .red : .blue)
                .disabled(automationManager.isPlaying)
                
                // Play Button
                Button(action: {
                    if automationManager.isPlaying {
                        automationManager.stopPlayback()
                    } else {
                        automationManager.startPlayback(speed: playbackSpeed)
                    }
                }) {
                    HStack {
                        Image(systemName: automationManager.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                            .font(.title2)
                        Text(automationManager.isPlaying ? "Stop" : "Play")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(automationManager.isPlaying ? .orange : .primary)
                    .frame(width: 80)
                }
                .buttonStyle(.borderedProminent)
                .tint(automationManager.isPlaying ? .orange : .green)
                .disabled(automationManager.isRecording || automationManager.recordedActions.isEmpty)
            }
            
            // Playback Speed Control
            HStack {
                Text("Speed:")
                    .font(.caption)
                Slider(value: $playbackSpeed, in: 0.1...5.0, step: 0.1)
                    .frame(width: 100)
                Text("\(playbackSpeed, specifier: "%.1f")x")
                    .font(.caption)
                    .frame(width: 30)
            }
            .disabled(automationManager.isRecording || automationManager.isPlaying)
            
            // File Controls
            HStack(spacing: 10) {
                Button("Open") {
                    showingFileImporter = true
                }
                .disabled(automationManager.isRecording || automationManager.isPlaying)
                
                Button("Save") {
                    showingFileExporter = true
                }
                .disabled(automationManager.recordedActions.isEmpty || automationManager.isRecording || automationManager.isPlaying)
                
                Button("Clear") {
                    automationManager.clearRecording()
                }
                .disabled(automationManager.recordedActions.isEmpty || automationManager.isRecording || automationManager.isPlaying)
            }
            .buttonStyle(.bordered)
            
            // Options
            Toggle("Always on Top", isOn: $isAlwaysOnTop)
                .font(.caption)
                .onChange(of: isAlwaysOnTop) { newValue in
                    setWindowAlwaysOnTop(newValue)
                }
        }
        .padding(20)
        .fileImporter(
            isPresented: $showingFileImporter,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                automationManager.loadRecording(from: url)
            }
        }
        .fileExporter(
            isPresented: $showingFileExporter,
            document: TaskDocument(actions: automationManager.recordedActions),
            contentType: .json,
            defaultFilename: "LittleTask Recording"
        ) { result in
            if case .success(let url) = result {
                print("Saved recording to: \(url)")
            }
        }
    }
    
    private func setWindowAlwaysOnTop(_ alwaysOnTop: Bool) {
        if let window = NSApplication.shared.windows.first {
            window.level = alwaysOnTop ? .floating : .normal
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 