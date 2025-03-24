//
//  CoreDataManager.swift
//  iosWeather
//
//  Created by Liubov on 07/03/2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "Model")

        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("❌ Failed to load Core Data store: \(error), \(error.userInfo)")
            }
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Core Data saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("❌ Core Data save error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
