import Foundation
import Supabase
import Combine

class UserService: ObservableObject {
    @Published var currentUserProfile: UserProfile?
    
    @MainActor
    func fetchProfile() async throws  -> UserProfile {
        guard let user = supabase.auth.currentUser else {
            throw NSError(domain: "NoUser", code: 0)
        }

        let response: UserProfile = try await supabase
            .from("profiles")
            .select()
            .eq("id", value: user.id)
            .single()
            .execute()
            .value

        self.currentUserProfile = response
        return response
    }
    
    @MainActor
    func updateStepsGoal(newStepsGoal: Int) async {
        guard let profile = currentUserProfile else { return }
        do {
            try await supabase
                .from("profiles")
                .update(["steps_goal": newStepsGoal])
                .eq("id", value: profile.id)
                .execute()
            
            self.currentUserProfile?.steps_goal = newStepsGoal
            print("Updated steps goal to \(newStepsGoal)")
        } catch {
            print("Error in updateStepsGoal: \(error.localizedDescription)")
        }
        return
    }
    
    @MainActor
    func updatePreferredDifficulty(newDifficulty: Int) async {
        guard let profile = currentUserProfile else { return }
        do {
            try await supabase
                .from("profiles")
                .update(["preferred_difficulty": newDifficulty])
                .eq("id", value: profile.id)
                .execute()
            
            self.currentUserProfile?.preferred_difficulty = newDifficulty
            print("Updated preferred difficulty to \(newDifficulty)")
        } catch {
            print("Error in updateStepsGoal: \(error.localizedDescription)")
        }
        return
    }
    
    @MainActor
    func updatePreferredTerrain(newTerrain: String) async {
        guard let profile = currentUserProfile else { return }
        do {
            try await supabase
                .from("profiles")
                .update(["preferred_terrain": newTerrain])
                .eq("id", value: profile.id)
                .execute()
            
            self.currentUserProfile?.preferred_terrain = newTerrain
            print("Updated preferred difficulty to \(newTerrain)")
        } catch {
            print("Error in updatePreferredTerrain: \(error.localizedDescription)")
        }
        return
    }
}

