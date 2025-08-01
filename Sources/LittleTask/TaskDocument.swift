import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct TaskDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    
    var actions: [AutomationAction]
    
    init(actions: [AutomationAction] = []) {
        self.actions = actions
    }
    
    init(configuration: FileDocumentReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        self.actions = try JSONDecoder().decode([AutomationAction].self, from: data)
    }
    
    func fileWrapper(configuration: FileDocumentWriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(actions)
        return FileWrapper(regularFileWithContents: data)
    }
} 