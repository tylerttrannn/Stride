import SwiftUI
import Supabase
import Combine

@MainActor
class RatingViewModel: ObservableObject {
    @Published var ratings: [String: Int] = [:]
    let service = TrailRatingService()
    
    func loadUserRatings() async {
        do {
            let userRatings = try await service.fetchUserRatings()
            
            // map trails to user's rating
            var map: [String: Int] = [:]
            for rating in userRatings {
                map[rating.trail_id] = rating.rating
            }
            
            ratings = map
        } catch {
            print("Failed to load ratings: ", error)
        }
    }
    
    func updateRating(for trailId: String, rating: Int) async {
        ratings[trailId] = rating
        
        do {
            try await service.addRating(trailId: trailId, rating: rating)
        } catch {
            print("Failed to add rating: ", error)
        }
    }
}
