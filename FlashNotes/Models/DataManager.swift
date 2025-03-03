import Foundation
import CoreData

enum DataError: Error {
    case fetchFailed
    case saveFailed
    case deleteFailed
    case invalidData
    case contextError
    
    var localizedDescription: String {
        switch self {
        case .fetchFailed:
            return "Failed to fetch data"
        case .saveFailed:
            return "Failed to save data"
        case .deleteFailed:
            return "Failed to delete data"
        case .invalidData:
            return "Invalid data provided"
        case .contextError:
            return "Core Data context error"
        }
    }
}

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
    
    // MARK: - Background Operations
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { (context) in
            block(context)
        }
    }
    
    func performBackgroundTaskAndWait(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { (context) in
            block(context)
        }
    }
    
    // MARK: - Core Data Operations
    
    func saveContext() -> Result<Void, DataError> {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return .success(())
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                return .failure(.saveFailed)
            }
        }
        return .success(())
    }
    
    // MARK: - Note Operations
    
    func createNote(title: String, content: String) -> Result<Note, DataError> {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.title = title
        note.content = content
        note.createdAt = Date()
        note.modifiedAt = Date()
        
        let saveResult = saveContext()
        switch saveResult {
        case .success:
            return .success(note)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchNotes() -> Result<[Note], DataError> {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        
        do {
            let notes = try viewContext.fetch(request)
            return .success(notes)
        } catch {
            print("Error fetching notes: \(error)")
            return .failure(.fetchFailed)
        }
    }
    
    func updateNote(note: Note, title: String, content: String) -> Result<Note, DataError> {
        note.title = title
        note.content = content
        note.modifiedAt = Date()
        
        let saveResult = saveContext()
        switch saveResult {
        case .success:
            return .success(note)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func deleteNote(note: Note) -> Result<Void, DataError> {
        viewContext.delete(note)
        return saveContext()
    }
    
    func searchNotes(query: String) -> Result<[Note], DataError> {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        
        if !query.isEmpty {
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
            let contentPredicate = NSPredicate(format: "content CONTAINS[cd] %@", query)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, contentPredicate])
            request.predicate = compoundPredicate
        }
        
        do {
            let notes = try viewContext.fetch(request)
            return .success(notes)
        } catch {
            print("Error searching notes: \(error)")
            return .failure(.fetchFailed)
        }
    }
    
    // Background operations example
    func createNoteInBackground(title: String, content: String, completion: @escaping (Result<Void, DataError>) -> Void) {
        performBackgroundTask { context in
            let note = Note(context: context)
            note.id = UUID()
            note.title = title
            note.content = content
            note.createdAt = Date()
            note.modifiedAt = Date()
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.saveFailed))
                }
            }
        }
    }
}
