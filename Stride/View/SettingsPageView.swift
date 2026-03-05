//
//  SettingsPageView.swift
//  Stride
//
//  Created by Kathy Lo on 2/14/26.
//


import SwiftUI

enum DifficultySelection : Int, CaseIterable {
    case one = 1
    case two
    case three
    case four
    case five
}

enum DisplayModeSelection : String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}


struct SettingsPageView: View {
    @State var displayModeSelection: DisplayModeSelection = .light
    @State var userService: UserService
    

    @EnvironmentObject var userVM: UserProfileViewModel
    
    var walkingStrideLength: Double
    
    private let INCHES_PER_MILE: Double = 63360.0

    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Goals")){
                    HStack {
                        TextField("Goal", value: Binding(
                            get: { userVM.userProfile?.steps_goal ?? 0 },
                            set: { newValue in
                                Task { await userVM.updateSteps(userService: userService, newGoal: newValue) }
                            }
                        ), format: .number)
                    }
                }
                
                Section(header: Text("Preferences")) {
                    VStack(alignment: .leading) {
                        Text("Trail Difficulty")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Picker("Difficulty", selection: Binding(
                            get: {
                                // Supabase stores it as just a plain Int, convert to DifficultySelection Enum
                                DifficultySelection(rawValue: userVM.userProfile?.preferred_difficulty ?? 1) ?? .one
                            },
                            set: { newValue in
                                Task {
                                    await userVM.updateDifficulty(userService: userService, newDifficulty: newValue.rawValue)
                                }
                            }
                        )) {
                            ForEach(DifficultySelection.allCases, id: \.self) { option in
                                Text("\(option.rawValue)").tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                
                Section (header: Text("App Settings")){
                    VStack (alignment: .leading){
                        Text("Appearance")
                        Picker("displayMode", selection: $displayModeSelection) {
                            ForEach(DisplayModeSelection.allCases, id: \.self) { option in
                                Text(option.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Section (header: Text("Your Data")) {
                    Text("Walking stride length: \(walkingStrideLength, specifier: "%.1f") inches")
                    Text("Approx. steps per mile: \(INCHES_PER_MILE / walkingStrideLength, specifier: "%.0f")")
                }
                
            }
            .navigationTitle("Setting")
        }
    }
}

#Preview {
    SettingsPageView(userService: UserService(), walkingStrideLength: 26.0)
        .environmentObject(UserProfileViewModel())
}
