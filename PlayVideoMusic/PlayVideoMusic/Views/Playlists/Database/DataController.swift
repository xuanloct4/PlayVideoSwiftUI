
import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Main")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
}


//struct Student {
//    var id: UUID
//    var name: String
//}
