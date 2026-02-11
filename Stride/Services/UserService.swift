import Foundation
import Supabase

class UserService {

    func fetchProfile() async throws -> UserProfile {
        guard let user = supabase.auth.currentUser else {
            throw NSError(domain: "NoUser", code: 0)
        }

        let response = try await supabase
            .from("profiles")
            .select()
            .eq("id", value: user.id)
            .single()
            .execute()

        return try JSONDecoder().decode(UserProfile.self, from: response.data)
    }
}

