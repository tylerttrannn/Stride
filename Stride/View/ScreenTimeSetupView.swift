//
//  ScreenTimeSetupView.swift
//  Stride
//
//  Created by Tyler Tran on 1/22/26.
//
import SwiftUI
import FamilyControls

enum ScreenTimeSetupPage{
    case selectApps, selectTime, activate
}

struct ScreenTimeSetupView : View {
    @State var path = NavigationPath()
    @State var viewModel : ViewModel = ViewModel()
    
    var body : some View {
        NavigationStack (path : $path ){
            VStack (spacing : 20){
                Image(systemName : "figure.walk.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width : 100, height : 100)
        
                VStack (spacing: 10){
                    Text("Request Authroization")
                        .fontWeight(.bold)
                        .font(.title)
                    
                    Text("To analyse your Screen Time on this iPhone Stride will need your permission")
                        .padding()
                }
                
                Button("Request Authorization"){
                    Task {
                        await viewModel.requestAuthorization()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .onChange(of : viewModel.authorizationStatus){
                if viewModel.authorizationStatus == .approved {
                    path.append(ScreenTimeSetupPage.selectApps)
                }
            }
            .navigationDestination(for : ScreenTimeSetupPage.self) { page in
                switch page {
                    case .selectApps : SelectAppsView(path : $path)
                    case .selectTime : LandingView()
                    case .activate : DummyBlockTest()
                }
            }
        }
    }
    
}

#Preview{
    ScreenTimeSetupView()
}
