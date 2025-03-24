//
//  iosWeatherApp.swift
//  iosWeather
//
//  Created by Liubov on 04/03/2025.
//

import SwiftUI
import CoreData

@main
struct iosWeatherApp: App {
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
            WindowGroup {
                ContentView()
                    .environment(\.managedObjectContext, persistentContainer.viewContext)
            }
        }
}
