//
//  AddCityModal.swift
//  iosWeather
//
//  Created by Liubov on 24/03/2025.
//

import SwiftUI

struct AddCityModal: View {
    @Binding var isShowingModal: Bool
    @Binding var newCity: String
    var addCity: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 4) { // Minimal spacing
                TextField("Enter city name", text: $newCity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isShowingModal = false
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Add City")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addCity()
                        isShowingModal = false
                    }
                    .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.fraction(0.25)]) // Keeps it compact
    }
}
