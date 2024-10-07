//
//  LoginView.swift
//  DoughToBread
//
//  Created by Kevin Gerges on 10/6/24.
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 50) {
            Spacer()

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 40)

            VStack(spacing: 8) {
                Text("Welcome to")
                    .font(.system(size: 24, weight: .medium, design: .default))
                    .foregroundColor(.secondary)

                Text("Dough To Bread")
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundColor(.primary)
            }

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
            }
            .padding(.horizontal, 16)

            Button(action: {
                Task {
                    await viewModel.emailLogin()
                }
            }) {
                Text("Login with Email")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

        
            Button(action: {
                Task {
                    await viewModel.googleLogin()
                }
            }) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.white)
                    Text("Sign in with Google")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 320, height: 50)
                .background(Color.green)
                .cornerRadius(25)
            }
            .padding(.horizontal)
            
            
             // might add it later
//            // Forgot Password
//            Button(action: {
//                // Add forgot password functionality here
//            }) {
//                Text("Forgot Password?")
//                    .font(.footnote)
//                    .foregroundColor(.blue)
//            }
//            .padding(.top)

            
            NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                Text("Don't have an account? Sign Up")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(.top)
            }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 10)
            }

            Text("By signing in, you agree to our terms and conditions.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}
