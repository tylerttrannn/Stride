//
//  TrailDetailedInfo.swift
//  Stride
//
//  Created by Kathy Lo on 1/29/26.
//


import SwiftUI
import MapKit

struct TrailDetailedInfo: View {
    var trail: Trail

    var body: some View {
        VStack {
            MapView(coordinate: CLLocationCoordinate2D(latitude: trail.latitude, longitude: trail.longitude))
                .frame(height: 300)
            
            VStack(alignment: .leading) {
                Text(trail.name)
                    .font(Font.system(size: 32, design: .serif))
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("About \(trail.name)")
                        .font(.title2)
                    Text("Address: ")
                    
                    let trail_distance_from_user_miles = trail.distance_from_user / 1609.344
                    Text("\(trail_distance_from_user_miles, specifier: "%.2f") mi away")
                    Text("Approx. \(trail.estimated_steps, specifier: "%.0f") steps")
                    Text("Length: \(trail.length_miles, specifier: "%.2f") miles")
                    if let difficulty = trail.difficulty {
                        Text("Diffculty: \(String(difficulty))/5")
                    }
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

#Preview {
    TrailDetailedInfo(trail: Trail(id: "1", name: "Turtle Rock", length_miles: 1.2, difficulty: 1, distance_from_user: 1.2, estimated_steps: 2400, latitude: 33.6405, longitude: -117.8443, score: 1))
}
