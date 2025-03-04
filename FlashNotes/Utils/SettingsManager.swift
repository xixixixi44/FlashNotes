import Foundation
import SwiftUI

class SettingsManager {
    static let shared = SettingsManager()
    
    private init() {}
    
    func showSettings() {
        let settingsWindowController = NSWindowController(
            window: NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
        )
        
        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)
        settingsWindowController.window?.contentViewController = hostingController
        settingsWindowController.window?.center()
        settingsWindowController.window?.title = L10n.preferences
        settingsWindowController.showWindow(nil)
    }
}

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = LocalizationManager.systemLanguage
    
    var body: some View {
        Form {
            Section {
                Picker(L10n.language, selection: $selectedLanguage) {
                    ForEach(LocalizationManager.availableLanguages, id: \.self) { language in
                        Text(LocalizationManager.languageNames[language] ?? language)
                            .tag(language)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Text(L10n.preferences)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 200)
    }
}
