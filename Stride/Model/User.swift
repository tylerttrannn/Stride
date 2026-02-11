import Foundation

struct UserProfile: Identifiable, Decodable {
    let id: String
    let preferred_difficulty: Int?
}
