//
//  NavBarView.swift
//  Stride
//
//  Created by Kathy Lo on 1/28/26.
//

import SwiftUI

struct BottomNavBarView: View {
    @State var selectedTab: Int = 0;
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412));
    }

    var body: some View {
        TabView (selection: $selectedTab) {
            HomePageView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .aspectRatio(contentMode: .fit)
                .tag(0)
            
            TrailInfoCard(trailName: "Turtle Rock", trailDistanceFromUser: 1.2, trailDifficulty: 1, trailLength: 1.1, trailSteps: 2000)
                .tabItem {
                    Image(systemName: "map")
                    Text("Trails")
                }
                .aspectRatio(contentMode: .fit)
                .tag(1)
        }
    }
}

#Preview {
    BottomNavBarView()
}

