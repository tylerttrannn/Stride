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
        
    var body: some View {
            VStack {
                Button("sign-out") {
                    Task { await authService.signOut() }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.bordered)
                
                BottomNavBarView(userService: userService)
                    .environmentObject(userVM)
            }
            .task {
                await userVM.loadProfile(userService: userService)
            }
        }
}

#Preview {
    LandingView(authService: AuthService(), userService: UserService())
}
