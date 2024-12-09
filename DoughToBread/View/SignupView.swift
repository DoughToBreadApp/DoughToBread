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
import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

            // Sign-Up Button
            Button(action: {
                Task {
                    await viewModel.signUp()
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

            // Error Message
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
    }
}
