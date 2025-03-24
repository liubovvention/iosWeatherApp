//
//  SettingsView.swift
//  iosWeather
//
//  Created by Liubov on 06/03/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var isMenuOpen = false
    
    var username: String = UserDefaults.standard.string(forKey: "username") ?? "User"
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Hey, \(username)!")
                        .font(.title)
                        .padding()
                    Text("Settings will be here, soon")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                }
                .navigationTitle(isMenuOpen ? "" : "Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                isMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.subheadline)
                        }
                    }
                }
                .toolbarColorScheme(.light, for: .navigationBar)

                // Overlay for menu
                if isMenuOpen {
                    Color.white.opacity(1.0)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isMenuOpen.toggle()  
                            }
                        }
                }

                // Side menu
                SideBarMenuView(isMenuOpen: $isMenuOpen)
                    .offset(x: isMenuOpen ? 0 : -250)
                    .animation(.easeInOut, value: isMenuOpen)
            }
        }
    }
}


#Preview {
    SettingsView()
}
