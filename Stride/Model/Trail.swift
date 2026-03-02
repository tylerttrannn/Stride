import Foundation

struct Trail: Identifiable, Decodable {
    let id: String
    let name: String
    let length_miles: Double
    let difficulty: Int?
    let distance_from_user: Double
    let estimated_steps: Double
    let latitude: Double
    let longitude: Double
    let score: Double
    let terrain_type: String
}
