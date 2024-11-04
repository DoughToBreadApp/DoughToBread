import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    @State private var hasCompletedPoll = false
    
    var body: some View {
        VStack {
            if userLoggedIn {
                if hasCompletedPoll {
                    MainAppView(shouldNavigate: true)
                } else {
                    PollView()
                }
            } else {
                NavigationView {
                    LoginView()
                }
            }
        }
        .onAppear {
            setupAuthListener()
        }
    }
    
    private func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                userLoggedIn = true
                // Check Firestore for poll completion status
                checkPollStatus(for: user.uid)
            } else {
                userLoggedIn = false
                hasCompletedPoll = false
            }
        }
    }
    
    private func checkPollStatus(for userID: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                // Assuming you store a boolean field called "hasCompletedPoll"
                hasCompletedPoll = document.data()?["hasCompletedPoll"] as? Bool ?? false
            } else {
                // If document doesn't exist, user hasn't completed poll
                hasCompletedPoll = false
            }
        }
    }
}

#Preview {
    ContentView()
}
