//
//  ContentView.swift
//  iosWeather
//
//  Created by Liubov on 04/03/2025.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @AppStorage("rememberMe") private var rememberMe: Bool = false
    
    var body: some View {
        if (isAuthenticated || rememberMe) {
            TabView {
                CitiesWeatherView()
                    .tabItem {
                            Label("Home", systemImage: "house")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
