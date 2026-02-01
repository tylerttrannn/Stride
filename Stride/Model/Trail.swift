//
//  Trail.swift
//  Stride
//
//  Created by Kathy Lo on 1/29/26.
//

import Foundation
import SwiftUI
import CoreLocation

struct Trail: Hashable, Codable, Identifiable {
    var trailId: String
    var trailName: String
    var lengthMiles: Double
    var difficulty: Int?
    private var location: Coordinates
    
    var id: String { trailId }  // For Identifiable compliance

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: location.latitude,
            longitude: location.longitude
        )
    }

    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
        
        enum CodingKeys: String, CodingKey {
            case latitude, longitude
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            latitude = try Coordinates.decodeDoubleOrArray(
                forKey: .latitude,
                from: container
            )

            longitude = try Coordinates.decodeDoubleOrArray(
                forKey: .longitude,
                from: container
            )
        }

        // Helper: decode Double OR [Double]
        static func decodeDoubleOrArray(
            forKey key: CodingKeys,
            from container: KeyedDecodingContainer<CodingKeys>
        ) throws -> Double {
            
            // Try single Double first
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }

            // Try array of Doubles
            if let array = try? container.decode([Double].self, forKey: key),
               let first = array.first {
                return first
            }

            // Fallback if missing or malformed
            return 0.0
        }
    }
}
