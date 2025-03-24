//
//  CityWeatherView.swift
//  iosWeather
//
//  Created by Liubov on 05/03/2025.
//

import Foundation
import SwiftUI

struct CityWeatherView: View {
    @StateObject private var viewModel = CityWeatherViewModel()
    let cityName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            if let cityWeather = viewModel.cityWeather {
                
                CityItemView(item: cityWeather, isPressable: false)
                
                VStack(alignment: .leading, spacing: 10) {
                    DetailRow(label: "Humidity:", value: "\(cityWeather.humidity)%")
                    DetailRow(label: "Pressure:", value: "\(cityWeather.pressure) hPa")
                    DetailRow(label: "Wind Speed:", value: "\(cityWeather.wspeed) mph")
                    DetailRow(label: "Cloud Cover:", value: "\(cityWeather.cloud)%")
                }
                .padding()
            } else if viewModel.loading {
                ProgressView()
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            viewModel.fetchCityWeather(for: cityName)
        }
        .navigationTitle(cityName)
        .navigationBarTitleDisplayMode(.automatic)
    }
}

#Preview {
    CityWeatherView(cityName: "Vilnius")
}

