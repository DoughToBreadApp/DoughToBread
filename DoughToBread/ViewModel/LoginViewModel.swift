//
//  LoginViewModel.swift
//  DoughToBread
//
//  Created by Kevin Gerges on 10/6/24.
//

import FirebaseAuth
import SwiftUI
import FirebaseAuth
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignedUp: Bool = false
    @Published var isLoggedIn: Bool = false // Track login status

    // Email Login Function
    func emailLogin() async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            isLoggedIn = true // User successfully logged in
        } catch {
            self.errorMessage = "Login failed: \(error.localizedDescription)"
        }
    }

    // Email Sign-Up Function
    func signUp() async {
        guard password == confirmPassword else {
            self.errorMessage = "Passwords do not match"
            return
        }

        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            isSignedUp = true // Mark as signed up
            isLoggedIn = true // Log the user in automatically
        } catch {
            self.errorMessage = "Sign-up failed: \(error.localizedDescription)"
        }
    }

    // Google Login Function
    func googleLogin() async {
        do {
            try await Authentication().googleOauth()
            isLoggedIn = true // Mark the user as logged in after Google OAuth success
        } catch let error as AuthenticationError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "An unknown error occurred."
        }
    }
}
