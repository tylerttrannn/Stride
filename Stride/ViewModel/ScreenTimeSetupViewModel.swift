//
//  RequestScreenTime.swift
//  Stride
//
//  Created by Tyler Tran on 1/22/26.
//

import SwiftUI
import FamilyControls
import Combine

extension ScreenTimeSetupView{
    @Observable
    class ViewModel {
        var authorizationStatus : FamilyControls.AuthorizationStatus = .notDetermined
        
        init(){
            checkAuthorization()
        }
        
        func requestAuthorization() async{
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for : .individual)
                self.authorizationStatus = AuthorizationCenter.shared.authorizationStatus
            } catch{
                print("authorization did not work ")
                self.authorizationStatus = .denied
            }
        }
        
        func checkAuthorization() {
            self.authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        }
    }

}
