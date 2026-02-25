
import Foundation

struct TrailRating: Codable {
    let user_id: UUID
    let trail_id: String
    let rating: Int
}
