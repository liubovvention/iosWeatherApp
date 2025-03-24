//
//  ApiService.swift
//  iosWeather
//
//  Created by Liubov on 05/03/2025.
//

import Foundation
import Combine

struct APIConfig {
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    static let apiKey = "ef7547eb05ea5d4514dc2aa20c325dbb"
}

class ApiService {
    static let shared = ApiService()
    private init() {}
    
    func get<T: Decodable>(endpoint: String, params: [String: String] = [:]) -> AnyPublisher<T, Error> {
        var urlComponents = URLComponents(string: "\(APIConfig.baseURL)/\(endpoint)")
        var queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(URLQueryItem(name: "appid", value: APIConfig.apiKey))
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

