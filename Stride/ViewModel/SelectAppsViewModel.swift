//
//  SelectAppsViewModel.swift
//  Stride
//
//  Created by Tyler Tran on 1/31/26.
//

import SwiftUI
import Combine
import FamilyControls
import Foundation


extension SelectAppsView {
    @Observable
    class ViewModel {
        var activitySelection: FamilyActivitySelection = FamilyActivitySelection()
        var timeGoal: Int = 30
        var pickerPresented = false
        var defaults = UserDefaults(suiteName: "group.Stride")

        func setSelection(){
            let encoder = JSONEncoder()

            do {
                let data = try encoder.encode(activitySelection)
                defaults?.set(data, forKey : "alertSystem")
                defaults?.synchronize()
                
                print("saved data to userdefaults")
            } catch {
                print("Error saving data to UserDefaults \(error.localizedDescription)")
            }
            if let savedData = defaults?.data(forKey: "alertSystem") {
                print("Verification: Data was saved, size: \(savedData.count) bytes")
            } else {
                print("Verification failed: No data found after save")
            }
        }

        func getSelection() -> Data?{
            if let savedData = defaults?.data(forKey: "alertSystem") {
                print("Data exists! returning ")
                return savedData
            }
            
            return nil
        }
            
    }
}
