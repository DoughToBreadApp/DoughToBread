//
//  SignupView.swift
//  DoughToBread
//
//  Created by Kevin Gerges on 10/6/24.
//
//  Description:
//  This SwiftUI view provides the user interface for the sign-up screen in the "DoughToBread" app.
//  It includes input fields for email, password, and password confirmation, as well as a button 
//  to trigger the sign-up process through the LoginViewModel.
//
//  Key Features:
//  - TextField for entering an email address with validation for email format.
//  - SecureField for entering and confirming the password securely.
//  - Sign-Up button to invoke the sign-up action using the view model.
//  - Error message display in case of invalid inputs or failed sign-up attempts.
//  - SwiftUI layout with responsive spacing and styling for a clean, user-friendly design.

import Foundation
import SwiftUI

// Sign-up view structure
struct SignUpView: View {
    // Observed object for managing authentication state
    // Uses the same view model as login for consistency
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        // Main container with vertical stack
        VStack(spacing: 16) {
            // Email input field
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress) // Set keyboard type for email input
                .autocapitalization(.none) // Disable auto-capitalization for email
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            // Password input field
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            // Confirm password field for validation
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            // Sign-Up Button with async action
            Button(action: {
                Task {
                    await viewModel.signUp() // Async call to sign up method
                }
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top)

            // Error message display
            // Only shown when there is an error message
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 10)
            }

            // Flexible space to push content to the top
            Spacer()
        }
        .padding() // Add padding around the entire form
        .navigationTitle("Sign Up") // Set navigation bar title
        .navigationBarTitleDisplayMode(.inline) // Set title display mode
    }
}
