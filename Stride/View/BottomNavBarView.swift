//
//  NavBarView.swift
//  Stride
//
//  Created by Kathy Lo on 1/28/26.
//

import SwiftUI
import Foundation

struct BottomNavBarView: View {
    @State var selectedTab: Int = 0;
    @State var errorMessage: String?
    @State var isLoading: Bool = false
    @State private var stepCount: Double = 1


    private let healthStore = HealthStore()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412));
    }

    var body: some View {
        TabView (selection: $selectedTab) {
            HomePageView(stepsCount: Int(stepCount))
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .aspectRatio(contentMode: .fit)
                .tag(0)
            
            TrailList()
                .tabItem {
                    Image(systemName: "map")
                    Text("Trails")
                }
                .aspectRatio(0.55, contentMode: .fit)
                .tag(1)
        }
        .onAppear {
            requestHealthKitAccess() // Request HealthKit permissions when view appears
        }
        .task {
            await loadSteps()
        }
    }

    func requestHealthKitAccess() {
        healthStore.requestAuthorization { success, error in
            if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            } else {
                print("HealthKit authorization was successful")
            }
        }
    }
    
    func loadSteps() async {
        do {
            stepCount = try await healthStore.fetchStepsAsync()
        } catch {
            errorMessage = error.localizedDescription
            print("Error:", errorMessage ?? "")
        }
    }

}

#Preview {
    BottomNavBarView()
}

