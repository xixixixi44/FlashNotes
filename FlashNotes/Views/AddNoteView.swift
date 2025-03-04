import SwiftUI

struct AddNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var content = ""
    @State private var selectedColorHex = Note.randomColorHex()
    
    var onSave: (Note) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(L10n.newNote)
                    .font(.headline)
                Spacer()
                Button(L10n.cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.escape, modifiers: [])
                
                Button(L10n.save) {
                    saveNote()
                }
                .keyboardShortcut(.return, modifiers: [.command])
                .disabled(title.isEmpty)
            }
            .padding()
            .background(Color(.windowBackgroundColor))
            
            Divider()
            
            VStack(spacing: 15) {
                TextField(L10n.title, text: $title)
                    .font(.title3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                ColorPickerView(selectedColorHex: $selectedColorHex)
                
                Text(L10n.content)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextEditor(text: $content)
                    .font(.body)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.separatorColor), lineWidth: 1)
                    )
                    .frame(minHeight: 200)
            }
            .padding()
        }
        .frame(width: 500, height: 400)
    }
    
    private func saveNote() {
        let newNote = Note(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            colorHex: selectedColorHex
        )
        onSave(newNote)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ColorPickerView: View {
    @Binding var selectedColorHex: String
    
    private let colors = [
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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(L10n.cardColor)
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(colors, id: \.self) { colorHex in
                        ColorCircle(
                            colorHex: colorHex,
                            isSelected: selectedColorHex == colorHex
                        )
                        .onTapGesture {
                            selectedColorHex = colorHex
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .frame(height: 40)
        }
    }
}

struct ColorCircle: View {
    let colorHex: String
    let isSelected: Bool
    
    var body: some View {
        Circle()
            .fill(Color(hex: colorHex))
            .frame(width: 30, height: 30)
            .overlay(
                Circle()
                    .stroke(Color.primary, lineWidth: isSelected ? 2 : 0)
            )
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView { _ in }
    }
}
