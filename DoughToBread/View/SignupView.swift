//
//  SignupView.swift
//  DoughToBread
//
//  Created by Kevin Gerges on 10/6/24.
//

// Import required frameworks
import Foundation
import SwiftUI
import SwiftUI // Note: Duplicate import can be removed

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
