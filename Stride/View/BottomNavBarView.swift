//
//  NavBarView.swift
//  Stride
//
//  Created by Kathy Lo on 1/28/26.
//

import SwiftUI
import Foundation
import HealthKit

struct BottomNavBarView: View {
    @State var selectedTab: Int = 0;
    @State var errorMessage: String?
    @State var isLoading: Bool = false
    @State private var stepCount: Double = 1
    @State private var walkingStrideLength: Double = 25  // 25 inches
    
    @EnvironmentObject var userVM: UserProfileViewModel

    private let healthStore = HealthStore()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412));
    }

    var body: some View {
        TabView (selection: $selectedTab) {
            HomePageView(stepsCount: Int(stepCount))
                .environmentObject(self.userVM)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .aspectRatio(contentMode: .fit)
                .tag(0)
            
            TrailList(stepsCount: Int(stepCount), walkingStrideLength: walkingStrideLength)
                .environmentObject(self.userVM)
                .tabItem {
                    Image(systemName: "map")
                    Text("Trails")
                }
                .aspectRatio(0.55, contentMode: .fit)
                .tag(1)
            
            SettingsPageView(walkingStrideLength: Double(walkingStrideLength))
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .aspectRatio(0.55, contentMode: .fit)
                .tag(2)
        }
        .task {
            await authorizeAndLoad()
            
        }
    }
    
    func authorizeAndLoad() async {
        do {
            let success = try await healthStore.requestAuthorizationAsync()
            if success {
                stepCount = try await healthStore.fetchStepsAsync()
                walkingStrideLength = try await healthStore.fetchWalkingStrideLengthAsync()
            } else {
                print("HealthKit permission denied")
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Authorization error:", error.localizedDescription)
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
            print("Error: loadSteps", errorMessage ?? "")
        }
    }
    
    func loadWalkingStrideLength() async {
        do {
            walkingStrideLength = try await healthStore.fetchWalkingStrideLengthAsync()
            print("walkingStrideLength: ", walkingStrideLength)
        } catch {
            errorMessage = error.localizedDescription
            print("Error: loadWalkingStrideLength ", errorMessage ?? "")
        }
    }

}

#Preview {
    BottomNavBarView()
        .environmentObject(UserProfileViewModel())
}

