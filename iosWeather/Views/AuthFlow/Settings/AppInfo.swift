//
//  AppInfo.swift
//  iosWeather
//
//  Created by Liubov on 10/03/2025.
//

import SwiftUI

struct AppInfoView: View {
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("App Version: \(appVersion)")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AppInfoView()
}

