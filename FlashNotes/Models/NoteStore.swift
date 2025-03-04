import Foundation
import Combine

class NoteStore: ObservableObject {
    @Published var notes: [Note] = []
    
    private let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("flashnotes.json")
    
    init() {
        loadNotes()
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func deleteNote(at index: Int) {
        guard index >= 0 && index < notes.count else { return }
        notes.remove(at: index)
        saveNotes()
    }
    
    func deleteNote(with id: UUID) {
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes.remove(at: index)
            saveNotes()
        }
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes()
        }
    }
    
    private func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: savePath)
        } catch {
            print("Failed to save notes: \(error.localizedDescription)")
        }
    }
    
    private func loadNotes() {
        do {
            if FileManager.default.fileExists(atPath: savePath.path) {
                let data = try Data(contentsOf: savePath)
                notes = try JSONDecoder().decode([Note].self, from: data)
            } else {
                // First run, load example notes
                notes = Note.examples
                saveNotes()
            }
        } catch {
            print("Failed to load notes: \(error.localizedDescription)")
            notes = Note.examples
            saveNotes()
        }
    }
}
