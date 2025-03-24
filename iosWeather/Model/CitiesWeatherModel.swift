//
//  CitiesWeatherModel.swift
//  iosWeather
//
//  Created by Liubov on 05/03/2025.
//

import Foundation
import Combine
import CoreData

class CitiesWeatherViewModel: ObservableObject {
    @Published var citiesWeather: [CityWeather] = []
    @Published var loading: Bool = true
    @Published var error: String?

    private var cancellables = Set<AnyCancellable>()
    private let coreDataManager = CoreDataManager.shared
    private let cacheExpiryTime: TimeInterval = 60 * 60  // 60 min
    
    // Method to remove a city from Core Data
    func removeCity(_ cityName: String) {
        let context = CoreDataManager.shared.context

        // Fetch the city from Core Data
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", cityName)

        do {
            let cities = try context.fetch(fetchRequest)
            if let city = cities.first {
                // Delete the city from Core Data
                context.delete(city)
                try context.save()
                print("✅ City \(cityName) removed from Core Data")
                    
                // Optionally, remove the city from the in-memory list
                self.citiesWeather.removeAll { $0.city == cityName }
                    
                // Re-fetch the weather data after removal (optional)
                fetchCitiesWeather()
            }
        } catch {
            print("❌ Error removing city \(cityName) from Core Data: \(error.localizedDescription)")
        }
    }
    
    // Method to add a new city to Core Data
    func addCityToCoreData(_ cityName: String) {
        let context = CoreDataManager.shared.context
        let city = City(context: context)
        city.name = cityName

        do {
            try context.save()
            print("✅ New city \(cityName) added to Core Data")
        } catch {
            print("❌ Failed to save new city to Core Data: \(error.localizedDescription)")
        }
    }

    // Fetch cities from Core Data
    func fetchCities() -> [City] {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        do {
            return try CoreDataManager.shared.context.fetch(fetchRequest)
        } catch {
            print("❌ Error fetching cities from Core Data: \(error.localizedDescription)")
            return []
        }
    }

    func fetchCitiesWeather() {
        // Fetch cities from Core Data
        var cities = fetchCities().map { $0.name ?? "" }

        // If cities list is empty, initialize it from JSON and save to Core Data
        if cities.isEmpty {
            print("📝 No cities found in Core Data, initializing from JSON")
            let citiesFromJson: [String] = UtilityServices.shared.load("citiesList.json")
            for cityName in citiesFromJson {
                addCityToCoreData(cityName)
            }
            cities = citiesFromJson // Use the cities loaded from JSON
        }

        print("🌍 Started fetching weather for cities: \(cities)")
        
        loading = true
        error = nil

        // ✅ Check cache before fetching
        if let cachedData = fetchCachedWeather(for: cities), isCacheValid(for: cities) {
            print("🟢 Using cached weather data")
            self.citiesWeather = cachedData.sorted { $0.city < $1.city }
            self.loading = false
            return
        }

        print("🔄 Fetching new weather data from API...")
        let group = DispatchGroup()
        var fetchedCitiesWeather: [CityWeather] = []

        for city in cities {
            group.enter()  // Start tracking this request

            let cityViewModel = CityWeatherViewModel()
            cityViewModel.fetchCityWeather(for: city)

            DispatchQueue.global().async {
                while cityViewModel.loading {
                    usleep(100_000)  // Sleep 100ms to avoid busy waiting
                }

                DispatchQueue.main.async {
                    if let cityWeather = cityViewModel.cityWeather {
                        fetchedCitiesWeather.append(cityWeather)
                    } else if let error = cityViewModel.error {
                        print("❌ Failed to fetch weather for: \(city) - Error: \(error)")
                    }
                    group.leave()
                }
            }
        }

        // Update UI and cache
        group.notify(queue: .main) {
            print("✅ All weather data fetched, updating UI")
            self.citiesWeather = fetchedCitiesWeather.sorted { $0.city < $1.city }
            self.loading = false

            // Save fetched data to Core Data cache
            self.cacheWeatherData(fetchedCitiesWeather)
        }
    }

    private func fetchCachedWeather(for cities: [String]) -> [CityWeather]? {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<CityWeatherEntity> = CityWeatherEntity.fetchRequest()

        do {
            let results = try context.fetch(request)
            print("🟢 Cached data found: \(results.count) records")

            let cityWeatherList = results.map { entity in
                return CityWeather(
                    city: entity.city ?? "",
                    icon: entity.icon ?? "",
                    descr: entity.descr ?? "",
                    temp: entity.temp,
                    humidity: Int(entity.humidity),
                    pressure: Int(entity.pressure),
                    wspeed: entity.wspeed,
                    cloud: Int(entity.cloud)
                )
            }

            return cityWeatherList.isEmpty ? nil : cityWeatherList
        } catch {
            print("❌ Error fetching cached data: \(error.localizedDescription)")
            return nil
        }
    }

    private func cacheWeatherData(_ weatherList: [CityWeather]) {
        let context = CoreDataManager.shared.context

        // ✅ Clear old cache before saving new data
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CityWeatherEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("✅ Old cache cleared successfully")
        } catch {
            print("❌ Failed to clear old cache: \(error.localizedDescription)")
        }

        for weather in weatherList {
            let entity = CityWeatherEntity(context: context)
            entity.city = weather.city
            entity.icon = weather.icon
            entity.descr = weather.descr
            entity.temp = weather.temp
            entity.humidity = Int16(weather.humidity)
            entity.pressure = Int16(weather.pressure)
            entity.wspeed = weather.wspeed
            entity.cloud = Int16(weather.cloud)
            entity.timestamp = Date()
        }

        do {
            try context.save()
            print("✅ Weather data saved to Core Data")
        } catch {
            print("❌ Failed to save Core Data: \(error.localizedDescription)")
        }
    }

    private func isCacheValid(for cities: [String]) -> Bool {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<CityWeatherEntity> = CityWeatherEntity.fetchRequest()

        do {
            let results = try context.fetch(request)
            print("🟢 Cached data found: \(results.count) records")
            
            // If the cached data's count does not match the number of cities
            if results.count != cities.count {
                print("⚠️ Cached data count does not match the number of cities")
                return false
            }

            // Check cache expiry by comparing timestamps
            guard let latestTimestamp = results.map({ $0.timestamp! }).max() else {
                print("⚠️ No timestamp found in cache")
                return false
            }

            let timeSinceLastUpdate = Date().timeIntervalSince(latestTimestamp)
            print("🕒 Time since last update: \(timeSinceLastUpdate) seconds")

            // Cache is valid only if it was updated within the last hour (3600 seconds)
            return timeSinceLastUpdate < 3600

        } catch {
            print("❌ Error validating cache: \(error.localizedDescription)")
            return false
        }
    }

}
