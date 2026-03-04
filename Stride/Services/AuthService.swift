import Foundation
import Supabase
import Combine

@MainActor
final class AuthService: ObservableObject {
    @Published var session: Session?
    @Published var isAuthenticated = false
    @Published var isLoading = false  // Prevent duplicate requests during auth operation
        
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
            defer { isLoading = false }
            
            let response = try await supabase.auth.signUp(email: email, password: password)
            self.session = response.session
            self.isAuthenticated = self.session != nil
            print("Sign up: session is \(self.session == nil ? "nil" : "present")")
        } catch {
            print("Sign up failed: \(error.localizedDescription)")
            self.session = nil
            self.isAuthenticated = false
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            
            let session = try await supabase.auth.signIn(email: email, password: password)
            self.session = session
            self.isAuthenticated = true
            print("Sign in: session is \(self.session == nil ? "nil" : "present")")
        } catch {
            print("Sign in failed: \(error.localizedDescription)")
            self.session = nil
            self.isAuthenticated = false
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
}
