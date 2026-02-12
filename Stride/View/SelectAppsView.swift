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
            
            VStack(spacing: 12) {
                Image(systemName : "app.badge.clock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width : 100, height : 100)
                
                Text("Select Apps")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Select the apps you want Stride to track your usage on to provide reminders to take a break and go on a walk ")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 40)
            
            Spacer()
            
            Button(action :{
                viewModel.pickerPresented = true
            }){
                Text("Select")
                    .frame(maxWidth : .infinity)
                    .padding(.vertical, 7)
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
        }
        .familyActivityPicker(isPresented: $viewModel.pickerPresented, selection: $viewModel.activitySelection)
        .onChange(of: viewModel.activitySelection) {
            viewModel.setSelection()
            path.append(ScreenTimeSetupPage.activate)
        }
    }
}


#Preview {
    @Previewable @State var mockPath : NavigationPath = NavigationPath()
    SelectAppsView(path: $mockPath)
}
