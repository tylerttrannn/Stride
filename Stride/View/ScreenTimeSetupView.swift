//
//  ScreenTimeSetupView.swift
//  Stride
//
//  Created by Tyler Tran on 1/22/26.
//


// todo will probably have some form of navigation later to get
// to this view

import SwiftUI


struct ScreenTimeSetupView : View {
    @StateObject var authorizationManager : AuthorizationManager = AuthorizationManager()
    
    var body : some View {
        VStack{
            Text("hello")
            
            Button("Request Authorization"){
                Task {
                    await authorizationManager.requestAuthorization()
                }
            }
        }
    }
}

#Preview{
    ScreenTimeSetupView()
}
