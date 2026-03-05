import Foundation

struct UserProfile: Identifiable, Decodable {
    let id: String
    var preferred_difficulty: Int?
    var steps_goal: Int?
    var preferred_terrain: String?
    let email: String
}
