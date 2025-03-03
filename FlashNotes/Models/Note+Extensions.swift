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
    
    var timeAgoFormatted: String {
        guard let date = modifiedAt else {
            return "Unknown time"
        }
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: date, to: now)
        
        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
        
        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }
        
        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        }
        
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        }
        
        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        }
        
        return "Just now"
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
    
    // More sample data for different preview scenarios
    static var oldPreview: Note {
        let viewContext = DataManager.shared.viewContext
        let note = Note(context: viewContext)
        note.id = UUID()
        note.title = "Old Note"
        note.content = "This note was created a week ago."
        
        // Set date to one week ago
        let calendar = Calendar.current
        note.createdAt = calendar.date(byAdding: .day, value: -7, to: Date())
        note.modifiedAt = calendar.date(byAdding: .day, value: -7, to: Date())
        
        return note
    }
}
