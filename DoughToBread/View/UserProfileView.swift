//
//  UserProfileView.swift
//  DoughToBread
//
//  Created by Nona Nersisyan on 10/3/24.
//

import SwiftUI
import FirebaseAuth

struct UserProfileView: View {
    @State private var errorMessage: String?
    var shouldNavigate: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            if let user = Auth.auth().currentUser {
                Text("Name: \(user.displayName ?? "Unknown")")
                    .font(.headline)
                Text("Email: \(user.email ?? "No Email")")
                    .font(.subheadline)
            }
            
            Text("Selection: \(shouldNavigate ? "Yes" : "No")")
                .font(.headline)
            
            Button {
                Task {
                    do {
                        try await Authentication().logout()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Text("Log Out")
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.white)
    }
}
