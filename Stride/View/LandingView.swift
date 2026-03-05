//
//  ContentView.swift
//  Stride
//
//  Created by Tyler Tran on 1/20/26.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var userVM = UserProfileViewModel()
    @ObservedObject var authService: AuthService
    @ObservedObject var userService: UserService
    
    let defaultProfile = UserProfile(id: "-1", email: "noUserProfile@email.com")
    
    var body: some View {
        Button("sign-out") {
            Task {
                await authService.signOut()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
        .buttonStyle(.bordered)
        
        BottomNavBarView(userService: userService, userProfile: userService.currentUserProfile ?? defaultProfile)
            .environmentObject(userVM)
            .task {
                await userVM.loadProfile()
            }
    }
}

#Preview {
    LandingView(authService: AuthService(), userService: UserService())
}
