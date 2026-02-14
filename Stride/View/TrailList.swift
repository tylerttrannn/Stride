//
//  TrailList.swift
//  Stride
//
//  Created by Kathy Lo on 1/29/26.
//
import SwiftUI
import CoreLocation

struct TrailList: View {
    @State private var trails: [Trail] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    @State private var latitude: CGFloat
    @State private var longitude: CGFloat
    
    private let locationManager: LocationManager = LocationManager()
    
    init (latitude: CGFloat = 33.6405, longitude: CGFloat = -117.8443) {
        _latitude = State(initialValue: latitude)
        _longitude = State(initialValue: longitude)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if isLoading {
                    ProgressView("Finding trails...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if trails.isEmpty {
                    Text("No trails found.")
                        .padding()
                } else {
                    ForEach(trails) { trail in
                        TrailInfoCard(trail: trail)
                    }
                }
            }
        }
        .task {
            await getLocation()
            await loadTrails()
        }
    }
    
    private func getLocation() async {
        while locationManager.userLocation == nil {
            try? await Task.sleep(nanoseconds: 300_000_000)
        }
        
        guard let location = locationManager.userLocation else {
            errorMessage = "Location not available"
            isLoading = false
            return
        }
        (latitude, longitude) = (location.latitude, location.longitude)
    }
    
    private func loadTrails() async {
        do {
            let results = try await TrailService().fetchRankedTrails(
                latitude: latitude,
                longitude: longitude,
                remainingSteps: 4000
            )
            trails = results
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

#Preview {
    TrailList()
}
