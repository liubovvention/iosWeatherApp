//
//  LoginModel.swift
//  iosWeather
//
//  Created by Liubov on 12/03/2025.
//

import Foundation
import SwiftUI

class LoginModel: ObservableObject {
    @SceneStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @Published var rememberMe: Bool = UserDefaults.standard.bool(forKey: "rememberMe")
    @Published var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var password: String = UserDefaults.standard.string(forKey: "password") ?? ""
    
    func handleLogin(username: String, password: String, shouldRememberMe: Bool) -> Bool {
        if let userData: [String: String] = UtilityServices.shared.load("user.json") {
            let storedEmail = userData["email"]
            let storedPassword = userData["password"]
            
            
            // Check if the entered username and password match the stored data
            if username == storedEmail && password == storedPassword {
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(password, forKey: "password")
                if (shouldRememberMe) {
                    UserDefaults.standard.set(true, forKey: "rememberMe")
                    rememberMe = true
                }
                isAuthenticated = true
                return true
            }
        }
        return false
    }
    
    func logout() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.clearAllCoreData()
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.set(false, forKey: "rememberMe")
        rememberMe = false
        isAuthenticated = false
    }
}

