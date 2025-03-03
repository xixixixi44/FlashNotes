import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FlashNotesDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Core Data Operations
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Note Operations
    
    func createNote(title: String, content: String) -> Note {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.title = title
        note.content = content
        note.createdAt = Date()
        note.modifiedAt = Date()
        saveContext()
        return note
    }
    
    func fetchNotes() -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching notes: \(error)")
            return []
        }
    }
    
    func updateNote(note: Note, title: String, content: String) {
        note.title = title
        note.content = content
        note.modifiedAt = Date()
        saveContext()
    }
    
    func deleteNote(note: Note) {
        viewContext.delete(note)
        saveContext()
    }
    
    func searchNotes(query: String) -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        
        if !query.isEmpty {
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
            let contentPredicate = NSPredicate(format: "content CONTAINS[cd] %@", query)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, contentPredicate])
            request.predicate = compoundPredicate
        }
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error searching notes: \(error)")
            return []
        }
    }
}
