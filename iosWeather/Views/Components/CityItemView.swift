//
//  CityItemView.swift
//  iosWeather
//
//  Created by Liubov on 05/03/2025.
//

import SwiftUI

struct CityItemView: View {
    let item: CityWeather
    let isPressable: Bool
    var onRemove: (() -> Void)?
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(item.icon).png")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(item.city)
                    .font(.headline)
                Text(item.descr)
                    .font(.subheadline)
            }
            Spacer()
            
            Text("\(item.temp, specifier: "%.1f")°F")
                .font(.title2)
                
            if isPressable {
                Button(action: {
                    onRemove?() 
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(8)
                }
                .buttonStyle(PlainButtonStyle()) // Ensures button doesn't trigger navigation
                        }
        }
        .padding()
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .bold()
            Spacer()
            Text(value)
                .font(.body)
        }
    }
}

