//
//  UserProfileView.swift
//  DoughToBread
//
//  Created by Nona Nersisyan on 10/3/24.
//

import SwiftUI
import FirebaseAuth

struct UserProfileView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @StateObject private var quizViewModel = QuizViewModel()
    @State private var errorMessage: String?
    var shouldNavigate: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let user = Auth.auth().currentUser {
                    Text("Name: \(user.displayName ?? "Unknown")")
                        .font(.headline)
                    Text("Email: \(user.email ?? "No Email")")
                        .font(.subheadline)
                }
                
                Text("Selection: \(shouldNavigate ? "Yes" : "No")")
                    .font(.headline)
                
                BadgesView(badges: viewModel.userBadges)
                
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
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
        }
        .onAppear {
            viewModel.fetchUserBadges()
        }
        .onChange(of: quizViewModel.badgeEarned) { newValue in
            if newValue {
                viewModel.fetchUserBadges()
                quizViewModel.badgeEarned = false
            }
        }
    }
}

struct BadgesView: View {
    let badges: [Badge]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Badges")
                .font(.title2)
                .fontWeight(.bold)
            
            if badges.isEmpty {
                Text("You haven't earned any badges yet.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(badges) { badge in
                    BadgeRow(badge: badge)
                }
            }
        }
    }
}

struct BadgeRow: View {
    let badge: Badge
    
    var body: some View {
        HStack {
            Image(systemName: "rosette")
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(badge.name)
                    .font(.headline)
                Text(badge.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
