//
//  TrailDetailedInfo.swift
//  Stride
//
//  Created by Kathy Lo on 1/29/26.
//


import SwiftUI
import MapKit
import CoreLocation

struct TrailDetailedInfo: View {
    var trail: Trail
    @State private var address: String = "Unknown"
    
    var body: some View {
        VStack {
            MapView(coordinate: CLLocationCoordinate2D(latitude: trail.latitude, longitude: trail.longitude))
                .frame(height: 300)
            
            VStack(alignment: .leading) {
                Text(trail.name)
                    .font(Font.system(size: 32, design: .serif))
                let trail_distance_from_user_miles = trail.distance_from_user / 1609.344
                Text("\(trail_distance_from_user_miles, specifier: "%.2f") mi away")
                    .font(Font.system(size: 16, design: .serif))
                    .foregroundColor(.gray)
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Address: \(address)")
                        .onAppear {
                            getAddress(latitude: trail.latitude, longitude: trail.longitude) { result in
                                if let result = result {
                                    address = result
                                }
                            }
                        }
                    Text("Coordinates: (\(trail.latitude), \(trail.longitude))")
                    Divider()
                    Text("Approx. \(trail.estimated_steps, specifier: "%.0f") steps")
                    Text("Length: \(trail.length_miles, specifier: "%.2f") miles")
                    if let difficulty = trail.difficulty {
                        Text("Diffculty: \(String(difficulty))/5")
                    }
                    Text("Terrain type: \(trail.terrain_type)")
                }
                .font(Font.system(size: 16, design: .serif))
                .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.058823529411764705)) // #00000f
            }
        }
        .padding()
    }
}
    

struct MapView: View {
    var coordinate: CLLocationCoordinate2D


    var body: some View {
        Map(position: .constant(.region(region)))
    }


    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

func getAddress(
    latitude: Double,
    longitude: Double,
    completion: @escaping (String?) -> Void
) {
    let geocoder = CLGeocoder()
    let location = CLLocation(latitude: latitude, longitude: longitude)
    
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        if let error = error {
            print("Reverse geocode failed:", error)
            completion(nil)
            return
        }
        
        // take the first placemark retrieved, contains the most specific detail
        guard let placemark = placemarks?.first else {
            completion(nil)
            return
        }
        
        let address = [
            placemark.name,
            placemark.locality,
            placemark.administrativeArea,
            placemark.postalCode,
            placemark.country
        ]
        .compactMap { $0 }  // remove nils
        .joined(separator: ", ")
        
        completion(address)
    }
}

#Preview {
    TrailDetailedInfo(trail: Trail(id: "1", name: "Turtle Rock", length_miles: 1.2, difficulty: 1, distance_from_user: 1.2, estimated_steps: 2400, latitude: 33.6405, longitude: -117.8443, score: 1, terrain_type:"dirt"))
}
