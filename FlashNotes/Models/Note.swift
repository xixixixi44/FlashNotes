import Foundation
import SwiftUI

struct Note: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var content: String
    var colorHex: String
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(), title: String, content: String, colorHex: String? = nil, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.colorHex = colorHex ?? Note.randomColorHex()
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var color: Color {
        Color(hex: colorHex)
    }
    
    // Generate a random card background color
    static func randomColorHex() -> String {
        let colors = [
            "#FFD8CC", // Light Coral
            "#FFE4B5", // Moccasin
            "#E6E6FA", // Lavender
            "#F0FFF0", // Honeydew
            "#F5F5DC", // Beige
            "#FFF0F5", // Lavender Blush
            "#F0F8FF", // Alice Blue
            "#F5FFFA", // Mint Cream
            "#FAEBD7", // Antique White
            "#E0FFFF"  // Light Cyan
        ]
        return colors.randomElement() ?? "#FFE4B5"
    }
    
    // Example notes
    static var examples: [Note] {
        [
            Note(title: "Welcome to FlashNotes", content: "This is a lightweight flashcard note application that helps you randomly review important information."),
            Note(title: "How to Use", content: "Click the + button to add a new note, use the play button to automatically rotate your note cards."),
            Note(title: "Markdown Support", content: "You can use **bold**, *italic* and other Markdown formatting to enrich your note content.")
        ]
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
