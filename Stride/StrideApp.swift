//
//  StrideApp.swift
//  Stride
//
//  Created by Tyler Tran on 1/20/26.
//

import SwiftUI

@main
struct StrideApp: App {
    @State var errorMessage: String?

    @StateObject private var authService = AuthService()
    @StateObject private var userService = UserService()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authService.isAuthenticated {
                    LandingView(authService: authService, userService: userService)
                } else {
                    LoginView(authService: authService)
                }
            }
            .task {
//                await authService.getInitialSession()
//                await userService.fetchProfile()
                
                await getUser()
            }
        }
    }
    
    func getUser() async {
        do {
            await authService.getInitialSession()
            let profile = try await userService.fetchProfile()
            print("Retrieved profile: \(profile)")
        } catch {
            errorMessage = error.localizedDescription
            print("Error: getUser ", errorMessage ?? "")
        }
    }
}
