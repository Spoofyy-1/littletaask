import Foundation
import AppKit
import CoreGraphics
import ApplicationServices

class AutomationManager: ObservableObject {
    static let shared = AutomationManager()
    
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var status = "Ready"
    @Published var recordedActions: [AutomationAction] = []
    
    private var eventTap: CFMachPort?
    private var recordingStartTime: Date?
    private var playbackTask: Task<Void, Never>?
    
    private init() {}
    
    func checkAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        let trusted = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if !trusted {
            status = "Accessibility permissions required - please grant access in System Preferences"
        } else {
            status = "Ready"
        }
    }
    
    func startRecording() {
        guard !isRecording else { return }
        
        // Check accessibility permissions
        let trusted = AXIsProcessTrusted()
        guard trusted else {
            status = "Accessibility permissions required"
            checkAccessibilityPermissions()
            return
        }
        
        recordedActions.removeAll()
        recordingStartTime = Date()
        isRecording = true
        status = "Recording... Press Stop to finish"
        
        createEventTap()
    }
    
    func stopRecording() {
        guard isRecording else { return }
        
        destroyEventTap()
        isRecording = false
        status = "Recording stopped - \(recordedActions.count) actions captured"
    }
    
    func startPlayback(speed: Double = 1.0) {
        guard !isPlaying && !recordedActions.isEmpty else { return }
        
        isPlaying = true
        status = "Playing back recording..."
        
        playbackTask = Task {
            await performPlayback(speed: speed)
            
            await MainActor.run {
                isPlaying = false
                status = "Playback complete"
            }
        }
    }
    
    func stopPlayback() {
        playbackTask?.cancel()
        isPlaying = false
        status = "Playback stopped"
    }
    
    func clearRecording() {
        recordedActions.removeAll()
        status = "Recording cleared"
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func togglePlayback() {
        if isPlaying {
            stopPlayback()
        } else if !recordedActions.isEmpty {
            startPlayback(speed: 1.0)
        }
    }
    
    func loadRecording(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let actions = try JSONDecoder().decode([AutomationAction].self, from: data)
            recordedActions = actions
            status = "Loaded \(actions.count) actions from file"
        } catch {
            status = "Failed to load recording: \(error.localizedDescription)"
        }
    }
    
    private func createEventTap() {
        let leftMouseDownMask = 1 << CGEventType.leftMouseDown.rawValue
        let leftMouseUpMask = 1 << CGEventType.leftMouseUp.rawValue
        let rightMouseDownMask = 1 << CGEventType.rightMouseDown.rawValue
        let rightMouseUpMask = 1 << CGEventType.rightMouseUp.rawValue
        let mouseMovedMask = 1 << CGEventType.mouseMoved.rawValue
        let leftMouseDraggedMask = 1 << CGEventType.leftMouseDragged.rawValue
        let rightMouseDraggedMask = 1 << CGEventType.rightMouseDragged.rawValue
        let keyDownMask = 1 << CGEventType.keyDown.rawValue
        let keyUpMask = 1 << CGEventType.keyUp.rawValue
        let scrollWheelMask = 1 << CGEventType.scrollWheel.rawValue
        
        let eventMask = leftMouseDownMask | leftMouseUpMask | rightMouseDownMask | 
                       rightMouseUpMask | mouseMovedMask | leftMouseDraggedMask | 
                       rightMouseDraggedMask | keyDownMask | keyUpMask | scrollWheelMask
        
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                let manager = Unmanaged<AutomationManager>.fromOpaque(refcon!).takeUnretainedValue()
                manager.handleEvent(event: event, type: type)
                return Unmanaged.passRetained(event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )
        
        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
    }
    
    private func destroyEventTap() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
        }
    }
    
    private func handleEvent(event: CGEvent, type: CGEventType) {
        guard let startTime = recordingStartTime else { return }
        
        let timestamp = Date().timeIntervalSince(startTime)
        let location = event.location
        
        var action: AutomationAction?
        
        switch type {
        case .leftMouseDown:
            action = AutomationAction(type: .mouseClick, timestamp: timestamp, x: location.x, y: location.y, button: .left, isDown: true)
        case .leftMouseUp:
            action = AutomationAction(type: .mouseClick, timestamp: timestamp, x: location.x, y: location.y, button: .left, isDown: false)
        case .rightMouseDown:
            action = AutomationAction(type: .mouseClick, timestamp: timestamp, x: location.x, y: location.y, button: .right, isDown: true)
        case .rightMouseUp:
            action = AutomationAction(type: .mouseClick, timestamp: timestamp, x: location.x, y: location.y, button: .right, isDown: false)
        case .mouseMoved, .leftMouseDragged, .rightMouseDragged:
            action = AutomationAction(type: .mouseMove, timestamp: timestamp, x: location.x, y: location.y)
        case .keyDown:
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            action = AutomationAction(type: .keyPress, timestamp: timestamp, isDown: true, keyCode: Int(keyCode))
        case .keyUp:
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            action = AutomationAction(type: .keyPress, timestamp: timestamp, isDown: false, keyCode: Int(keyCode))
        case .scrollWheel:
            let deltaY = event.getDoubleValueField(.scrollWheelEventDeltaAxis1)
            action = AutomationAction(type: .scroll, timestamp: timestamp, x: location.x, y: location.y, deltaY: deltaY)
        default:
            break
        }
        
        if let action = action {
            DispatchQueue.main.async {
                self.recordedActions.append(action)
            }
        }
    }
    
    private func performPlayback(speed: Double) async {
        guard !recordedActions.isEmpty else { return }
        
        let adjustedActions = recordedActions.map { action in
            var adjusted = action
            adjusted.timestamp /= speed
            return adjusted
        }
        
        var lastTimestamp: TimeInterval = 0
        
        for action in adjustedActions {
            if Task.isCancelled { return }
            
            let delay = action.timestamp - lastTimestamp
            if delay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            if Task.isCancelled { return }
            
            executeAction(action)
            lastTimestamp = action.timestamp
        }
    }
    
    private func executeAction(_ action: AutomationAction) {
        switch action.type {
        case .mouseClick:
            let point = CGPoint(x: action.x ?? 0, y: action.y ?? 0)
            let eventType: CGEventType = action.isDown == true ? 
                (action.button == .right ? .rightMouseDown : .leftMouseDown) :
                (action.button == .right ? .rightMouseUp : .leftMouseUp)
            
            if let event = CGEvent(mouseEventSource: nil, mouseType: eventType, mouseCursorPosition: point, mouseButton: action.button == .right ? .right : .left) {
                event.post(tap: .cghidEventTap)
            }
            
        case .mouseMove:
            let point = CGPoint(x: action.x ?? 0, y: action.y ?? 0)
            if let event = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .left) {
                event.post(tap: .cghidEventTap)
            }
            
        case .keyPress:
            guard let keyCode = action.keyCode else { return }
            if let event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(keyCode), keyDown: action.isDown == true) {
                event.post(tap: .cghidEventTap)
            }
            
        case .scroll:
            if let event = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: 1, wheel1: Int32(action.deltaY ?? 0), wheel2: 0, wheel3: 0) {
                event.post(tap: .cghidEventTap)
            }
        }
    }
} 