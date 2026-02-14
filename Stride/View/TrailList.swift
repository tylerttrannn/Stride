//
//  TrailList.swift
//  Stride
//
//  Created by Kathy Lo on 1/29/26.
//
import SwiftUI

struct TrailList: View {
    @State private var trails: [Trail] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
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
            await loadTrails()
        }
    }
    
    private func loadTrails() async {
        do {
            let results = try await TrailService().fetchRankedTrails(
                latitude: 33.6405,
                longitude: -117.8443,
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
