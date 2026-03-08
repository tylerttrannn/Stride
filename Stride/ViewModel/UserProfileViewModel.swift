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
    @Published var userProfile: UserProfile?
    var preferredDifficulty: DifficultySelection {
        DifficultySelection(rawValue: userProfile?.preferred_difficulty ?? 1) ?? .one
    }
     var stepsGoal: Int {
        userProfile?.steps_goal ?? 5000
    }

    func loadProfile(userService: UserService) async {
        do {
            self.userProfile = try await userService.fetchProfile()
        } catch {
            print("VM Load Error: \(error)")
        }
    }

    func updateSteps(userService: UserService, newGoal: Int) async {
        await userService.updateStepsGoal(newStepsGoal: newGoal)
        self.userProfile = userService.currentUserProfile
    }

    func updateDifficulty(userService: UserService, newDifficulty: Int) async {
        await userService.updatePreferredDifficulty(newDifficulty: newDifficulty)
        self.userProfile = userService.currentUserProfile
    }
}

