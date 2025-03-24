//
//  SidebarMenuView.swift
//  iosWeather
//
//  Created by Liubov on 10/03/2025.
//

import SwiftUI

struct SideBarMenuView: View {
    @Binding var isMenuOpen: Bool
    private let menuWidth: CGFloat = 250.0
    
    var body: some View {
        ZStack {
                if isMenuOpen {
                    Button {
                        isMenuOpen.toggle()
                    } label: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .ignoresSafeArea()
                    }
                    .accessibilityLabel("dismiss")
                    
                    HStack {
                        VStack (alignment: .leading) {
                            ScrollView  {
                                SideNavContent(isShowingSideNav: $isMenuOpen)
                                    .frame(width: menuWidth, alignment: .leading)
                            }
                            .frame(width: menuWidth)
                            Spacer()
                        }
                        .padding()
                        .frame(width: menuWidth)
                        .background(Color.gray.opacity(0.3))
                        Spacer()
                    }
                    .transition(.move(edge: .leading))
                }
            }
            .animation(.easeInOut, value: isMenuOpen)
        }
}

#Preview {
    SideBarMenuView(isMenuOpen: .constant(true))
}

struct SideNavContent: View {
    @StateObject private var loginModel = LoginModel()
    @Binding var isShowingSideNav: Bool
    
    @SceneStorage("isAuthenticated") private var isAuthenticated: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            NavigationLink(destination: AppInfoView()) {
                Label("App Info", systemImage: "info")
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            Button(action: {
                loginModel.logout()
                isAuthenticated = false
            }) {
                Label("Logout", systemImage: "arrow.right.square")
                    .foregroundColor(.red)
                    .padding()
            }
            .padding(.bottom, 30)
            
            Spacer()
        }
        .frame(width: 150.0)
    }
}



