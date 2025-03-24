//
//  WeatherAppTypes.swift
//  iosWeather app types
//
//  Created by Liubov on 05/03/2025.
//

import Foundation

import Foundation

struct CityWeather: Codable {
    let city: String
    let icon: String
    let descr: String
    let temp: Double
    let humidity: Int
    let pressure: Int
    let wspeed: Double
    let cloud: Int
}

struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: MainWeather
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let sys: SystemInfo
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Rain: Codable {
    let oneHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

struct Clouds: Codable {
    let all: Int
}

struct SystemInfo: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

