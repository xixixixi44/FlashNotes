import Foundation
import SwiftUI

struct LocalizationManager {
    // Supported languages
    static let availableLanguages = ["en", "zh-Hans"]
    
    // Language display names
    static let languageNames = [
        "en": "English",
        "zh-Hans": "简体中文"
    ]
    
    // Get system language
    static var systemLanguage: String {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        if preferredLanguage.starts(with: "zh") {
            return "zh-Hans"
        }
        return availableLanguages.contains(preferredLanguage) ? preferredLanguage : "en"
    }
}

// Localized strings
struct L10n {
    @Environment(\.locale) static var locale
    
    // App general
    static var about: String { NSLocalizedString("about", comment: "About menu item") }
    static var tagline: String { NSLocalizedString("tagline", comment: "Application tagline") }
    static var settings: String { NSLocalizedString("settings", comment: "Settings menu") }
    static var preferences: String { NSLocalizedString("preferences", comment: "Preferences menu item") }
    static var language: String { NSLocalizedString("language", comment: "Language menu") }
    
    // Note related
    static var newNote: String { NSLocalizedString("newNote", comment: "New note button") }
    static var save: String { NSLocalizedString("save", comment: "Save button") }
    static var cancel: String { NSLocalizedString("cancel", comment: "Cancel button") }
    static var title: String { NSLocalizedString("title", comment: "Title field") }
    static var content: String { NSLocalizedString("content", comment: "Content field") }
    static var cardColor: String { NSLocalizedString("cardColor", comment: "Card color selection") }
    static var noNotes: String { NSLocalizedString("noNotes", comment: "No notes message") }
    static var addFirstNote: String { NSLocalizedString("addFirstNote", comment: "Add first note button") }
}
