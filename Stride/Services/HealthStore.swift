// from lecture

import HealthKit

class HealthStore {
    let healthStore = HKHealthStore()
    
    // request permission from user to read HealthKit data
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }
        
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        else {
            completion(false, nil)
            return
        }

        let typesToRead: Set<HKObjectType> = [stepCountType, calorieType]
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    // fetch user's step count for today
    func fetchSteps(completion: @escaping (Double, Error?) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        // filter for today only
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: Date(),
            options: .strictStartDate
        )
        
        // get step count for today
        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum)
        {_, result, error in
            DispatchQueue.main.async {
                if let error = error {
                    // return the error if query failed
                    completion(0, error)
                    return
                }
                
                // else return the step count (or 0 if nil)
                let stepCount = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                completion(stepCount, nil)
            }
        }
        
        healthStore.execute(query)
    }
    
}

extension HealthStore {
    func fetchStepsAsync() async throws -> Double {
        try await withCheckedThrowingContinuation { continuation in
            fetchSteps { steps, error in
                if let error = error {
                     continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: steps)
                }
            }
        }
    }
}

