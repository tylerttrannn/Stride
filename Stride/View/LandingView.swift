//
//  ContentView.swift
//  Stride
//
//  Created by Tyler Tran on 1/20/26.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var userVM = UserProfileViewModel()

    var body: some View {
        BottomNavBarView()
            .environmentObject(userVM)
            .task {
                await userVM.loadProfile()
            }
    }
}

#Preview {
    LandingView()
}
