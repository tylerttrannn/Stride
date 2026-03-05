//
//  NavBarView.swift
//  Stride
//
//  Created by Kathy Lo on 1/28/26.
//

import SwiftUI
import Foundation

@MainActor
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
            ProgressBar(stepsCount: Int(stepCount), stepsGoal: userVM.stepsGoal)
                .environmentObject(self.userVM)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .aspectRatio(contentMode: .fit)
                .tag(0)
            
            TrailList(stepCount: Int(stepCount), walkingStrideLength: walkingStrideLength)
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
        .onAppear {
            requestHealthKitAccess() // Request HealthKit permissions when view appears
        }
        .onChange(of: selectedTab) {
            Task {
                print("Running task for loadSteps and loadWalkingStrideLength, on change")
                await loadSteps()
                await loadWalkingStrideLength()
            }
        }
        .task {
            print("Running task for loadSteps and loadWalkingStrideLength, task")
            await loadSteps()
            await loadWalkingStrideLength()
            
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

