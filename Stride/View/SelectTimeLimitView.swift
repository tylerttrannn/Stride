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

struct SelectTimeLimitView : View {
    @State private var time = 50

    var body : some View {
        VStack{
            VStack(spacing: 12) {
                Text("Daily Screen Reminder")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("We'll nudge you to take a walk once you reach this limit on your selected apps.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 40)
            
            Spacer()

            TimerPicker(minutes: $time, color: .green)
            
            Spacer()
            
            
            Button(action :{
                startActivity()
            }){
                Text("Continue")
                    .frame(maxWidth : .infinity)
                    .padding(.vertical, 7)
            }
            .padding()
            .buttonStyle(.borderedProminent)
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

#Preview {
    SelectTimeLimitView()
}
