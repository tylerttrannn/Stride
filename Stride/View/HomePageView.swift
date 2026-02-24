//
//  HomePageView.swift
//  Stride
//
//  Created by Kathy Lo on 1/29/26.
//

import SwiftUI

struct HomePageView: View {
    var stepsCount: Int;
    var stepsGoal: Int = 5000;

    @EnvironmentObject var userVM: UserProfileViewModel
    
    var body: some View {
        ProgressBar(stepsCount: stepsCount, stepsGoal: userVM.stepsGoal)
    }
}

#Preview {
    HomePageView(stepsCount: 1000, stepsGoal: 7000)
        .environmentObject(UserProfileViewModel())
}
