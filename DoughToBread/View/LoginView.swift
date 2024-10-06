//
//  Login.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 9/16/24.
//
import SwiftUI

struct Login: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Welcome to")
                        .font(.system(size: 24, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 40)
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
                    HStack {
                        Text("Login with Email")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(width: 320, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
                }

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
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14, weight: .regular))
                        .padding(.top, 10)
                }

                Button(action: {
                    viewModel.sendPasswordReset()
                }) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }

                Spacer()

                Text("By signing in, you agree to our terms and conditions.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
