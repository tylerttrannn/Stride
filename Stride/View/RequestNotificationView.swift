//
//  RequestNotificationView.swift
//  Stride
//
//  Created by Tyler Tran on 2/11/26.
//


import SwiftUI
import UserNotifications


struct RequestNotificationView : View {
    @Binding var path : NavigationPath

    var body : some View {
        VStack{
            VStack(spacing: 12) {
                Image(systemName : "bell.badge.waveform.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width : 100, height : 100)
                
                Text("Request Notification")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Stride needs access to notificaitons to be able to nudge you to go on a walk!")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 40)
            
            Spacer()
            
            Button(action: {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        Task { @MainActor in 
                            path.append(ScreenTimeSetupPage.selectApps)
                        }
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }) {
                Text("Request")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 7)
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
    }
    
    
    
}

