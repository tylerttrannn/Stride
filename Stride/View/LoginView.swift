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
    
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
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

        if let error = authService.authErrorMessage {
            Text(error)
                .foregroundColor(.red)
                .font(.footnote)
                .padding(.horizontal, 30)
        }
        
        Button("Sign In") {
            Task {
                await authService.signIn(email: email, password: password)
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(!isFormValid)
        
        Button("Sign Up") {
            Task {
                await authService.signUp(email: email, password: password)
                let error = authService.authErrorMessage ?? ""
                if error == "" {
                    self.password = ""
                    self.email = ""
                }
            }
        }
        .buttonStyle(.bordered)
        .disabled(!isFormValid)
    }
}

#Preview {
    LoginView(authService: AuthService())
}
