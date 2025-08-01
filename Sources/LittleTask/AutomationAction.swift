import Foundation

struct AutomationAction: Codable {
    let type: ActionType
    var timestamp: TimeInterval
    let x: Double?
    let y: Double?
    let button: MouseButton?
    let isDown: Bool?
    let keyCode: Int?
    let deltaY: Double?
    
    init(type: ActionType, timestamp: TimeInterval, x: Double? = nil, y: Double? = nil, button: MouseButton? = nil, isDown: Bool? = nil, keyCode: Int? = nil, deltaY: Double? = nil) {
        self.type = type
        self.timestamp = timestamp
        self.x = x
        self.y = y
        self.button = button
        self.isDown = isDown
        self.keyCode = keyCode
        self.deltaY = deltaY
    }
}

enum ActionType: String, Codable {
    case mouseClick
    case mouseMove
    case keyPress
    case scroll
}

enum MouseButton: String, Codable {
    case left
    case right
} 