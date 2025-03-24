//
//  CitiesWeatherView.swift
//  iosWeather
//
//  Created by Liubov on 05/03/2025.
//

import SwiftUI

struct CitiesWeatherView: View {
    @StateObject private var viewModel = CitiesWeatherViewModel()
    
    @State private var isShowingModal = false
    @State private var newCity = ""

    private func addCity() {
        print ("Add city \(newCity)")
        guard !newCity.isEmpty else { return }
        viewModel.addCityToCoreData(newCity)
        viewModel.fetchCitiesWeather()
        
        isShowingModal = false
        newCity = ""
    }
    
    private func removeCity(cityName: String) {
        viewModel.removeCity(cityName)
        viewModel.fetchCitiesWeather()
        
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("You can add your city here")
                        .font(.subheadline)
                    Button(action: {
                        isShowingModal = true
                    }) {
                        Label("Add City", systemImage: "plus")
                    }
                }
                .padding()

                if viewModel.loading {
                    ProgressView()
                        .onAppear {
                            print("Started loading cities weather data")  // Log when loading starts
                        }
                } else if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .onAppear {
                            print("Error occurred: \(error)")  // Log any error
                        }
                } else {
                    List(viewModel.citiesWeather, id: \.city) { cityWeather in
                        NavigationLink(destination: CityWeatherView(cityName: cityWeather.city)) {
                            CityItemView(item: cityWeather, isPressable: true, onRemove: {
                                        removeCity(cityName: cityWeather.city)
                                                        })
                                .padding(.vertical, 5)
                        }
                    }
                    .onAppear {
                        print("Data loaded, displaying weather for cities.")  // Log when data is available
                    }
                }
            }
            .onAppear {
                viewModel.fetchCitiesWeather()  // Fetch the weather when the view appears
            }
            .navigationTitle("Weather App")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingModal) {
                AddCityModal(isShowingModal: $isShowingModal, newCity: $newCity, addCity: addCity)
                    .presentationDetents([.fraction(0.25)])
                    .presentationDragIndicator(.visible) // Optional: Show a drag handle
            }
        }
    }
}


#Preview {
    CitiesWeatherView()
}
