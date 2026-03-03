//
//  StrideApp.swift
//  Stride
//
//  Created by Tyler Tran on 1/20/26.
//

import SwiftUI

@main
struct StrideApp: App {
    init() {
        Task {
            await AuthService.shared.establishAnonSession()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
    }
}
