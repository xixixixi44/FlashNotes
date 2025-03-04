import SwiftUI

@main
struct FlashNotesApp: App {
    @AppStorage("selectedLanguage") private var selectedLanguage = LocalizationManager.systemLanguage
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, .init(identifier: selectedLanguage))
                .preferredColorScheme(colorScheme)
                .frame(minWidth: 600, minHeight: 400)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            SidebarCommands()
            CommandGroup(replacing: .appInfo) {
                Button(L10n.about) {
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                            string: "FlashNotes - " + L10n.tagline,
                            attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 11)]
                        )]
                    )
                }
            }
            CommandMenu(L10n.settings) {
                Button(L10n.preferences) {
                    SettingsManager.shared.showSettings()
                }
                .keyboardShortcut(",", modifiers: [.command])
                
                Menu(L10n.language) {
                    ForEach(LocalizationManager.availableLanguages, id: \.self) { language in
                        Button(LocalizationManager.languageNames[language] ?? language) {
                            selectedLanguage = language
                        }
                        .checkmark(selectedLanguage == language)
                    }
                }
            }
        }
    }
}

// Button checkmark extension
extension Button {
    func checkmark(_ checked: Bool) -> some View {
        if checked {
            return AnyView(HStack {
                self
                Spacer()
                Image(systemName: "checkmark")
            })
        } else {
            return AnyView(self)
        }
    }
}
