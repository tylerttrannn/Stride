import Foundation
import Supabase

class TrailRatingService {
    
    func addRating(trailId: String, rating: Int) async throws {
        guard let userId = supabase.auth.currentUser?.id else {return}
        
        let ratingRow = TrailRating(
            user_id: userId,
            trail_id: trailId,
            rating: rating
        )

        try await supabase
            .from("trail_ratings")
            .upsert(ratingRow, onConflict: "user_id,trail_id")
            .execute()
    }
    
    func fetchUserRankings() async throws -> [TrailRating] {
        guard let userId = supabase.auth.currentUser?.id else { return [] }
        
        let response = try await supabase
                .from("trail_ratings")
                .select("*")
                .eq("user_id", value: userId)
                .execute()

            let data = response.data
            return try JSONDecoder().decode([TrailRating].self, from: data)
    }
}
