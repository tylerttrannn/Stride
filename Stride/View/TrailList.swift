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
    @State private var showSheet: Bool = false
    
    @State private var latitude: CGFloat
    @State private var longitude: CGFloat
    @State var noticeTextHeight: CGFloat = 0
    
    @StateObject private var ratingsVM = RatingViewModel()

    @StateObject private var locationManager: LocationManager = LocationManager()
    
    private var stepCount: Int
    private var walkingStrideLength: Double
    private let INCHES_PER_MILE: Double = 63360.0

    @EnvironmentObject var userVM: UserProfileViewModel
    
    init (latitude: CGFloat = 33.6405, longitude: CGFloat = -117.8443, stepCount: Int = 0, walkingStrideLength: Double = 25) {
        _latitude = State(initialValue: latitude)
        _longitude = State(initialValue: longitude)
        self.stepCount = stepCount
        self.walkingStrideLength = walkingStrideLength
    }
    
    var body: some View {
        NavigationStack {
            List {
                HStack{
                    Spacer()
                    Button("Info"){
                        showSheet = true
                        print("button pressed")
                    }
                }
                .listRowSeparator(.hidden)
      
                if isLoading {
                    ProgressView("Finding trails...")
                        .padding()
                } else if errorMessage == "Location not available" && !trails.isEmpty {
                    Text("Notice: Current user location is not available. Displaying results based on trails best fit for you near UC Irvine.")
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
                    ForEach(trails) { trail in
                        NavigationLink {
                            TrailDetailedInfo(trail: trail, ratingsVM: ratingsVM)
                        } label: {
                            TrailInfoCard(trail: trail, ratingsVM: ratingsVM)
                        }
                        
                        
                    }
                } else if errorMessage == "Location not available" {
                    Text("Notice: Current user location is not available. Please fix in settings.")
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if trails.isEmpty {
                    Text("No trails found.")
                        .padding()
                } else {
                    ForEach(trails) { trail in
                        NavigationLink {
                            TrailDetailedInfo(trail: trail, ratingsVM: ratingsVM)
                        } label: {
                            TrailInfoCard(trail: trail, ratingsVM: ratingsVM)
                        }
                    }
                }
            }
        }
        .task {
            print("Running task for getLocation and loadTrails")
            errorMessage = nil
            await getLocation()
            await loadTrails()
            await ratingsVM.loadUserRatings()
        }
        .sheet(isPresented: $showSheet){
            ExplanationView()
        }
    }
    
    private func getLocation() async {
//        while locationManager.userLocation == nil {
//            try? await Task.sleep(nanoseconds: 300_000_000)
//        }
        
        print("\tgetLocation: \(locationManager.userLocation)")
        guard let location = locationManager.userLocation else {
            print("getLocation: no user location available")
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
                remainingSteps: Double(Int(userVM.stepsGoal) - stepCount),
                difficulty_pref: userVM.preferredDifficulty,
                user_steps_per_mile: Int(INCHES_PER_MILE / walkingStrideLength),
                terrain_pref: userVM.preferredTerrain
            )
            trails = results
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}


struct ExplanationView : View {
    var body : some View {
        VStack{
            Text("hello world ")
        }
    }
}


#Preview {
    TrailList(stepCount: 0, walkingStrideLength: 1)
        .environmentObject(UserProfileViewModel())
}
