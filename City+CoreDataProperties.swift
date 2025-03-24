//
//  City+CoreDataProperties.swift
//  iosWeather
//
//  Created by Liubov on 24/03/2025.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?

}

extension City : Identifiable {

}
