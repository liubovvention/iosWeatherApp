//
//  CityWeatherModelData.swift
//  iosWeather
//
//  Created by Liubov on 05/03/2025.
//

import Foundation
import Combine

class CityWeatherViewModel: ObservableObject {
    @Published var cityWeather: CityWeather?
    @Published var loading: Bool = true
    @Published var error: String?
    
    private var cancellable: AnyCancellable?
    
    func fetchCityWeather(for city: String) {
        loading = true
        error = nil
        
        cancellable = ApiService.shared.get(endpoint: "weather", params: ["q": city])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error.localizedDescription
                case .finished:
                    break
                }
                self.loading = false
            }, receiveValue: { (result: WeatherResponse) in
                self.cityWeather = CityWeather(
                    city: result.name,
                    icon: result.weather.first?.icon ?? "",
                    descr: result.weather.first?.main ?? "",
                    temp: result.main.temp,
                    humidity: result.main.humidity,
                    pressure: result.main.pressure,
                    wspeed: result.wind.speed,
                    cloud: result.clouds.all
                )
            })
    }
}
