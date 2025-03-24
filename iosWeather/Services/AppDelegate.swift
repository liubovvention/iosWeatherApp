//
//  AppDelegate.swift
//  iosWeather
//
//  Created by Liubov on 24/03/2025.
//

import SwiftUI
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    // Triggered when the app is being terminated, either by the user closing it or by the system shutting it down
    func applicationWillTerminate(_ application: UIApplication) {
        clearWeatherCoreData()
    }

    // Triggered when the app is about to go into the background (e.g., user presses the home button, app switches to another app, or the app gets interrupted by a phone call)
    //func applicationWillResignActive(_ application: UIApplication) {
    //    clearWeatherCoreData()
    //}

    func clearWeatherCoreData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CityWeatherEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete data: \(error)")
        }
    }
    
    func clearAllCoreData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
            
        // Fetch all entities in Core Data
        let entityNames = CoreDataManager.shared.persistentContainer.managedObjectModel.entities.map { $0.name! }

        // Iterate over each entity and delete all objects of that entity
        for entityName in entityNames {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
            do {
                // Execute the delete request for the entity
                try context.execute(deleteRequest)
            } catch {
                print("Failed to delete data for entity \(entityName): \(error)")
            }
        }
            
        // Save context after deletion
        do {
            try context.save()
        } catch {
            print("Failed to save context after clearing Core Data: \(error)")
        }
    }
}


