//
//  SelectAppsView.swift
//  Stride
//
//  Created by Tyler Tran on 1/22/26.
//
import SwiftUI
import FamilyControls

struct SelectAppsView : View {
    @State private var activitySelection = FamilyActivitySelection()
    @State private var pickerPresented = false
    
    var body : some View {
        VStack (spacing : 20){
            Image(systemName : "app.badge.clock.fill")
                .resizable()
                .scaledToFit()
                .frame(width : 100, height : 100)
    
            VStack (spacing: 10){
                Text("Select Apps")
                    .fontWeight(.bold)
                    .font(.title)
                
                Text("Select the apps you want Stride to track your usage on to provide reminders to take a break and go on a walk ")
                    .padding()
            }
            
            Button("Select"){
                pickerPresented = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .familyActivityPicker(isPresented: $pickerPresented, selection: $activitySelection)
        .onChange(of: activitySelection) {
            print("need to store the selection in SwiftData later!")
        }
    }
}


#Preview {
    SelectAppsView()
}
