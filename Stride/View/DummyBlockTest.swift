//
//  DummyBlockTest.swift
//  Stride
//
//  Created by Tyler Tran on 1/31/26.
//

import SwiftUI
import DeviceActivity
import SwiftData
import FamilyControls

struct DummyBlockTest : View {
    
    var body : some View {
        VStack{
            Text("sdfsdfsfsd")
            
            Button("Press me"){
                print("pressed")
                startActivity()
            }
        }
    }
    
    func startActivity(){
        let monitor = DeviceActivityCenter()
        let activityName = DeviceActivityName("timeAlert")
        let eventName = DeviceActivityEvent.Name("timeAlert")

        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute : 59),
            repeats: true
        )
        
        


    }
}
