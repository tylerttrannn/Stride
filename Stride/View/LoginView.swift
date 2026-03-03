//
//  LoginView.swift
//  Stride
//
//  Created by Kathy Lo on 3/2/26.
//

import SwiftUI

struct LoginView : View {
    @ObservedObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    
    var body : some View {
        TextField("Email", text: $email)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .padding(CGFloat(5))
        
        SecureField("password", text: $password)
            .textFieldStyle(.roundedBorder)
        
        Button("Sign In") {
            Task {
                await authService.signIn(email: email, password: password)
            }
        }
        .buttonStyle(.borderedProminent)
        
        Button("Sign Up") {
            Task {
                await authService.signUp(email: email, password: password)
            }
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    LoginView(authService: .shared)
}