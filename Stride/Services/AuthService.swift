import Foundation
import Supabase
import Combine

@MainActor
final class AuthService: ObservableObject {
    @Published var session: Session?
    @Published var isAuthenticated = false
    @Published var isLoading = false  // Prevent duplicate requests during auth operation
    
    @Published var authErrorMessage: String?
        
    func establishAnonSession() async {
        if let user = supabase.auth.currentUser {
            print("Existing session found:", user.id)
            return
        }
        
        do {
            let session = try await supabase.auth.signInAnonymously()
            print("Anon session created: ", session.user.id)
        } catch {
            print("Anon sign-in failed: \(error.localizedDescription)")
        }
    }
    
    func getInitialSession() async {
        do {
            let current = try await supabase.auth.session
            self.session = current
            self.isAuthenticated = current != nil
        } catch {
            print("No active session: \(error.localizedDescription)")
            self.session = nil
            self.isAuthenticated = false
        }
    }
    
    func signUp(email: String, password: String) async {
        do {
            guard !isLoading else { return }
            isLoading = true
            authErrorMessage = nil
            defer { isLoading = false }
            
            let response = try await supabase.auth.signUp(email: email, password: password)
            self.session = response.session
            self.isAuthenticated = self.session != nil
            print("Sign up: session is \(self.session == nil ? "nil" : "present")")
        } catch {
            print("Sign up failed: \(error.localizedDescription)")
            self.session = nil
            self.isAuthenticated = false
            self.authErrorMessage = parseAuthError(error)
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            guard !isLoading else { return }
            isLoading = true
            authErrorMessage = nil
            defer { isLoading = false }
            
            let session = try await supabase.auth.signIn(email: email, password: password)
            self.session = session
            self.isAuthenticated = true
            print("Sign in: session is \(self.session == nil ? "nil" : "present")")
        } catch {
            print("Sign in failed: \(error.localizedDescription)")
            self.session = nil
            self.isAuthenticated = false
            self.authErrorMessage = parseAuthError(error)
        }
    }
    
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            self.session = nil
            self.isAuthenticated = false
            print("Signed out")
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }
    
    private func parseAuthError(_ error: Error) -> String {
        let message = error.localizedDescription.lowercased()

        if message.contains("not confirmed") {
            return "Please confirm email to login"
        }

        if message.contains("invalid login credentials") {
            return "Incorrect email or password."
        }

        if message.contains("password") {
            return "Password must be at least 6 characters."
        }

        if message.contains("email") {
            return "Please enter a valid email address."
        }

        if message.contains("already registered") {
            return "An account with this email already exists."
        }

        return "Something went wrong. Please try again."
    }
}
