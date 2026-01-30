//
//  HomePageView.swift
//  Stride
//
//  Created by Kathy Lo on 1/29/26.
//

import SwiftUI

struct HomePageView: View {
    var stepsCount: Int = 1000;
    var stepsGoal: Int = 2000;
    
    var body: some View {
        ProgressBar(stepsCount: stepsCount, stepsGoal: stepsGoal)
    }
}

#Preview {
    HomePageView()
}
