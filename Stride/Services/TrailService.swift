import Foundation
import CoreLocation
import Supabase
import WeatherKit

class TrailService {
    
    func fetchRankedTrails (
        latitude: Double,
        longitude: Double,
        remainingSteps: Double,
        difficulty_pref: DifficultySelection = DifficultySelection.one,
        user_steps_per_mile: Int = 2000,
        terrain_pref: TerrainSelection = TerrainSelection.dirt
    ) async throws -> [Trail] {
        let weatherSeverity = await TrailWeatherScoringService.shared
            .fetchWeatherSeverity(latitude: latitude, longitude: longitude)
        
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

private actor TrailWeatherScoringService {
    static let shared = TrailWeatherScoringService()
    private let service = WeatherService.shared

    func fetchWeatherSeverity(latitude: Double, longitude: Double) async -> Double {
        do {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let weather = try await service.weather(for: location)
            return score(for: weather.currentWeather)
        } catch {
            return 0.35
        }
    }

    private func score(for current: CurrentWeather) -> Double {
        let temperatureF = current.temperature.converted(to: .fahrenheit).value
        let windMph = current.wind.speed.converted(to: .milesPerHour).value
        let condition = String(describing: current.condition).lowercased()

        var severity = 0.0

        if temperatureF < 50 {
            severity += min((50 - temperatureF) / 30.0, 1.0) * 0.25
        } else if temperatureF > 80 {
            severity += min((temperatureF - 80) / 25.0, 1.0) * 0.25
        }

        if windMph > 10 {
            severity += min((windMph - 10) / 25.0, 1.0) * 0.25
        }

        if condition.contains("thunder") || condition.contains("storm") || condition.contains("hurricane") {
            severity += 0.50
        } else if condition.contains("snow") || condition.contains("sleet") || condition.contains("hail") {
            severity += 0.35
        } else if condition.contains("rain") || condition.contains("drizzle") || condition.contains("shower") {
            severity += 0.25
        } else if condition.contains("fog") || condition.contains("smoke") || condition.contains("haze") {
            severity += 0.15
        }

        return min(max(severity, 0.0), 1.0)
    }
}
