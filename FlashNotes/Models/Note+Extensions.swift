import Foundation
import CoreData

extension Note {
    var titleDisplay: String {
        return title ?? "Untitled Note"
    }
    
    var contentPreview: String {
        guard let content = content, !content.isEmpty else {
            return "No content"
        }
        
        let maxLength = 100
        if content.count <= maxLength {
            return content
        } else {
            let index = content.index(content.startIndex, offsetBy: maxLength)
            return String(content[..<index]) + "..."
        }
    }
    
    var creationDateFormatted: String {
        guard let date = createdAt else {
            return "Unknown date"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var modificationDateFormatted: String {
        guard let date = modifiedAt else {
            return "Unknown date"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    static func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
}

extension Note {
    // Sample data for previews in SwiftUI
    static var preview: Note {
        let viewContext = DataManager.shared.viewContext
        let note = Note(context: viewContext)
        note.id = UUID()
        note.title = "Sample Note"
        note.content = "This is a sample note content for preview purposes."
        note.createdAt = Date()
        note.modifiedAt = Date()
        return note
    }
    
    static var emptyPreview: Note {
        let viewContext = DataManager.shared.viewContext
        let note = Note(context: viewContext)
        note.id = UUID()
        note.title = "Untitled Note"
        note.content = ""
        note.createdAt = Date()
        note.modifiedAt = Date()
        return note
    }
}
