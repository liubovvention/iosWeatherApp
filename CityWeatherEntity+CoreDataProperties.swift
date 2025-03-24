//
//  CityWeatherEntity+CoreDataProperties.swift
//  iosWeather
//
//  Created by Liubov on 10/03/2025.
//
//

import Foundation
import CoreData


extension CityWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeatherEntityG> {
        return NSFetchRequest<CityWeatherEntityG>(entityName: "CityWeatherEntity")
    }

    @NSManaged public var city: String?
    @NSManaged public var cloud: Int16
    @NSManaged public var descr: String?
    @NSManaged public var humidity: Int16
    @NSManaged public var icon: String?
    @NSManaged public var pressure: Int16
    @NSManaged public var temp: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var wspeed: Double

}

extension CityWeatherEntity : Identifiable {

}
