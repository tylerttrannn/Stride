//
//  SelectTimeLimitViewModel.swift
//  Stride
//
//  Created by Tyler Tran on 2/11/26.
//


import Foundation
import DeviceActivity
import FamilyControls

extension SelectTimeLimitView{
    
    @Observable
    class ViewModel {
        
        // this will start monitoring a users activity and see
        // when they hit a time limit on a app/category
        func startActivity(){
            let monitor = DeviceActivityCenter()
            let activityName = DeviceActivityName("timeAlert")
            let eventName = DeviceActivityEvent.Name("timeAlert")

            let schedule = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 0, minute: 0),
                intervalEnd: DateComponents(hour: 23, minute : 59),
                repeats: true
            )
            
            let event = DeviceActivityEvent(
                applications : AppSelectionModel.getSelection().applicationTokens,
                threshold : DateComponents(hour : 0, minute : 1)
            )
       
            do {
                try monitor.startMonitoring(
                    activityName,
                    during : schedule,
                    events: [eventName: event]
                )
                print("activity started")
            } catch{
                print("error starting activity \(error.localizedDescription)")
            }
        }
        
        
    }
    
    
}
