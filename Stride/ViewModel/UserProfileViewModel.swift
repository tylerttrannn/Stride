//
//  UserProfileViewModel.swift
//  Stride
//
//  Created by Kathy Lo on 2/14/26.
//

import Foundation
import SwiftUI
import Combine


@MainActor
class UserProfileViewModel: ObservableObject {
    
    @Published var preferredDifficulty: DifficultySelection = DifficultySelection.one
    @Published var stepsGoal: Int = 5000
    
    func loadProfile() async {
        do {
            let profile = try await UserService().fetchProfile()
//            preferredDifficulty = DifficultySelection(
//                rawValue: profile.preferred_difficulty ?? 1
//            ) ?? .one
        } catch {
            print(error)
        }
    }
}

