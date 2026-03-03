//
//  StrideApp.swift
//  Stride
//
//  Created by Tyler Tran on 1/20/26.
//

import SwiftUI

@main
struct StrideApp: App {
<<<<<<< HEAD
    @StateObject private var authService = AuthService()
=======
    init() {
        Task {
            await AuthService.shared.establishAnonSession()
        }
    }
>>>>>>> df6eff5 (add establish anon session)
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authService.isAuthenticated {
                    LandingView(authService: authService)
                } else {
                    LoginView(authService: authService)
                }
            }
            .task {
                await authService.getInitialSession()
            }
        }
    }
}
