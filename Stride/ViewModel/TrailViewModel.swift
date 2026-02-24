import CoreLocation
import Foundation
import Combine

@MainActor
class TrailViewModel: ObservableObject {
    @Published var trails: [Trail] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var stepsToday: Double = 0.0
    @Published var preferredDifficulty: Int?
    
    private let trailSerice = TrailService()
    private let healthStore = HealthStore()
    private let locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    private let userService = UserService()
    
    // TEMPORARYYYYYY
    let goalSteps = 10000.0
    
    func loadTrails() async {
        
        isLoading = true
        errorMessage = nil
        
        while locationManager.userLocation == nil {
            try? await Task.sleep(nanoseconds: 300_000_000)
        }
        
        guard let location = locationManager.userLocation else {
            errorMessage = "Location not available"
            isLoading = false
            return
        }
        
        do {
            let authorized = try await requestHealthAuthorization()
            print("HealthKit step authorization:", authorized)
            guard authorized else {
                errorMessage = "HealthKit authorization denied"
                isLoading = false
                return
            }
            
            // let steps = try await healthStore.fetchStepsAsync()
            // temporary idkkkkk for simualtor
            let steps = 5000.0
            stepsToday = steps
            
            stepsToday = steps
            let remainingSteps = max(goalSteps - stepsToday, 0)
            
            // fetch user profile
            let profile = try await userService.fetchProfile()
            preferredDifficulty = profile.preferred_difficulty
            
            print("User Id: ", profile.id)
            print("User preferred difficulty:", preferredDifficulty as Any)

            // fetch ranked trails
            trails = try await trailSerice.fetchRankedTrails(
                latitude: location.latitude,
                longitude: location.longitude,
                remainingSteps: remainingSteps
            )
            
            print("Num of trails:" ,trails.count)
        } catch {
            errorMessage = error.localizedDescription
            print("Error: ", error.localizedDescription)
        }
        
        isLoading = false
    }
    
    private func requestHealthAuthorization() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
}
