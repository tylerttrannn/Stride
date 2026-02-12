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
    @State private var time = 0
    @State private var viewModel : ViewModel = ViewModel()

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
                viewModel.startActivity()
            }){
                Text("Activate")
                    .frame(maxWidth : .infinity)
                    .padding(.vertical, 7)
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
    }

}

#Preview {
    SelectTimeLimitView()
}
