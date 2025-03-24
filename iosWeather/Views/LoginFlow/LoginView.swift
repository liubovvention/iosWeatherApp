//
//  LoginView.swift
//  iosWeather
//
//  Created by Liubov on 12/03/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginModel = LoginModel()
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    @SceneStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    
    var body: some View {
        VStack {
            Text("Log In")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            
            VStack (alignment: .center, spacing: 24)  {
                
                TextField("Username", text: $username)
                    .padding()
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
               
                HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .padding()
                                
                        } else {
                            SecureField("Password", text: $password)
                                .padding()
                        }

                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                 
                Toggle(isOn: $rememberMe) {
                    Text("Remember Me")
                }
                
                
                Button(action: {
                    if loginModel.handleLogin(username: username, password: password, shouldRememberMe: rememberMe) {
                        isAuthenticated = true
                        } else {
                        errorMessage = "Incorrect username or password"
                        showErrorAlert = true
                    }
                }) {
                    Text("LogIn")
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.302, green: 0.831, blue: 0.982))
                .cornerRadius(10)
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                    )
                
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
             }
            }
            .padding(.horizontal, 30.0)
        }
        
    }
}

#Preview {
    LoginView()
}
