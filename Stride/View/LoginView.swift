//
//  LoginView.swift
//  Stride
//
//  Created by Kathy Lo on 3/4/26.
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
            .padding(.horizontal, 30)
        
        SecureField("password", text: $password)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 30)
            .padding(.bottom, 10)

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
