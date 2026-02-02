//
//  SelectAppsView.swift
//  Stride
//
//  Created by Tyler Tran on 1/22/26.
//
import SwiftUI
import FamilyControls

struct SelectAppsView : View {
    @Binding var path : NavigationPath 
    @State private var activitySelection = FamilyActivitySelection()
    @Bindable var viewModel : ViewModel = ViewModel()
    
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
                viewModel.pickerPresented = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .familyActivityPicker(isPresented: $viewModel.pickerPresented, selection: $viewModel.activitySelection)
        .onChange(of: viewModel.activitySelection) {
            viewModel.setSelection()
            path.append(ScreenTimeSetupPage.activate)
        }
    }
}
