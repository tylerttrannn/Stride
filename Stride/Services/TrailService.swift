import Foundation
import Supabase

class TrailService {
    
    func fetchRankedTrails (
        latitude: Double,
        longitude: Double,
        remainingSteps: Double
    ) async throws -> [Trail] {
        
        let response = try await supabase
            .rpc(
                "rank_trails",
                params: [
                    "user_lat": latitude,
                    "user_lon": longitude,
                    "remaining_steps": remainingSteps
                ]
            )
            .execute()
        
        let data = response.data

        let decoder = JSONDecoder()
        let trails = try decoder.decode([Trail].self, from: data)
        return trails
    }
}
