//
//  DeviceActivityMonitorExtension.swift
//  StrideActivityMonitor
//
//  Created by Tyler Tran on 2/1/26.
//

import DeviceActivity
import SwiftData
import Foundation
import FamilyControls
import ManagedSettings

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    let defaults = UserDefaults(suiteName: "group.com.Stride.appblocker")
    let alertStore = ManagedSettingsStore()

    func decodeSelection() -> FamilyActivitySelection? {
        guard let defaults = defaults else {
            return nil
        }
    
        guard let data = defaults.data(forKey: "alertSystem") else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let selection = try decoder.decode(FamilyActivitySelection.self, from: data)
            return selection
        } catch {
            return nil
        }
    }
    
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        // something is going wrong here basically in the decoding i think 
        if let selection = decodeSelection() {
            alertStore.shield.applications = selection.applicationTokens
            alertStore.shield.applicationCategories = .specific(selection.categoryTokens)
        }
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
                
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
