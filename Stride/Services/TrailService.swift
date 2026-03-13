import Foundation
import Supabase

class TrailService {
    
    func fetchRankedTrails (
        latitude: Double,
        longitude: Double,
        remainingSteps: Double,
        difficulty_pref: DifficultySelection = DifficultySelection.one,
        user_steps_per_mile: Int = 2000,
        terrain_pref: TerrainSelection = TerrainSelection.dirt
    ) async throws -> [Trail] {
        
        let params: [String: AnyJSON] = [
            "user_lat": .double(latitude),
            "user_lon": .double(longitude),
            "remaining_steps": .double(remainingSteps),
            "user_difficulty_pref": .double(Double(difficulty_pref.rawValue)),
            "user_steps_per_mile": .double(Double(user_steps_per_mile)),
            "user_terrain_pref": .string(terrain_pref.rawValue)
        ]
            
        let response = try await supabase
            .rpc("rank_trails_terrain", params: params)
            .execute()
        
        let data = response.data

        let decoder = JSONDecoder()
        let trails = try decoder.decode([Trail].self, from: data)
        return trails
    }
}
