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

    @EnvironmentObject var userVM: UserProfileViewModel
    
    var walkingStrideLength: Double
    
    private let INCHES_PER_MILE: Double = 63360.0

    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Goals")){
                    HStack {
                        Text("Steps Goal ")
                        TextField("Enter you steps goal", value: $userVM.stepsGoal, format: .number)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5) // Creates a shape for the border
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
                Section (header: Text("Preferences")){
                    VStack (alignment: .leading){
                        Text("Trail Difficulty")
                        Picker("difficulty", selection: $userVM.preferredDifficulty) {
                            ForEach(DifficultySelection.allCases, id: \.self) { option in
                                Text("\(option.rawValue)")
                                    .tag(option.rawValue)
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
    SettingsPageView(walkingStrideLength: 26.0)
        .environmentObject(UserProfileViewModel())
}
