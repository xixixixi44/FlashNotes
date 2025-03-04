import XCTest
@testable import FlashNotes

final class FlashNotesTests: XCTestCase {
    
    func testNoteCreation() {
        // Test note creation with required fields
        let note = Note(title: "Test Title", content: "Test Content")
        
        XCTAssertEqual(note.title, "Test Title")
        XCTAssertEqual(note.content, "Test Content")
        XCTAssertNotNil(note.id)
    }
    
    func testNoteStore() {
        // Test the note store basic operations
        let noteStore = NoteStore()
        let initialCount = noteStore.notes.count
        
        // Add a note
        let note = Note(title: "Test Note", content: "Test Content")
        noteStore.addNote(note)
        
        XCTAssertEqual(noteStore.notes.count, initialCount + 1)
        
        // Check if the note was added correctly
        if let addedNote = noteStore.notes.last {
            XCTAssertEqual(addedNote.title, "Test Note")
            XCTAssertEqual(addedNote.content, "Test Content")
            
            // Test update
            var updatedNote = addedNote
            updatedNote.title = "Updated Title"
            noteStore.updateNote(updatedNote)
            
            // Find the updated note and check it
            if let foundNote = noteStore.notes.first(where: { $0.id == updatedNote.id }) {
                XCTAssertEqual(foundNote.title, "Updated Title")
            } else {
                XCTFail("Failed to find updated note")
            }
            
            // Test deletion
            noteStore.deleteNote(with: addedNote.id)
            XCTAssertEqual(noteStore.notes.count, initialCount)
        } else {
            XCTFail("Failed to add note to store")
        }
    }
}
