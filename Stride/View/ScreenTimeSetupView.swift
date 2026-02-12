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
                
                VStack(spacing: 12) {
                    Image(systemName : "figure.walk.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width : 100, height : 100)
                    
                    Text("Request Authorization")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("To analyse your Screen Time on this iPhone Stride will need your permission")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 40)
                
                Spacer()
                
                Button(action :{
                    Task {
                        await viewModel.requestAuthorization()
                    }
                }){
                    Text("Request Authorization")
                        .frame(maxWidth : .infinity)
                        .padding(.vertical, 7)
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
            
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
                    case .activate : SelectTimeLimitView()
                }
            }
        }
    }
    
}

#Preview{
    ScreenTimeSetupView()
}
