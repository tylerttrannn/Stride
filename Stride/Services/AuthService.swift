import Foundation
import Supabase

@MainActor
final class AuthService {
    static let shared = AuthService()
    private init() {}
    
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
}
