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
    @StateObject private var calculatorViewModel = CalculatorViewModel()
    @State private var errorMessage: String?
    var shouldNavigate: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // header
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    if let user = Auth.auth().currentUser {
                        VStack(spacing: 8) {
                            Text(user.displayName ?? "Unknown")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(user.email ?? "No Email")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                )
                
                // badges section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Achievements")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    BadgesView(badges: viewModel.userBadges)
                        .padding(.horizontal)
                }
                .padding(.vertical)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                )
                
                // logout Button
                Button {
                    Task {
                        do {
                            try await Authentication().logout()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Log Out")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            viewModel.fetchUserBadges()
        }
        .onChange(of: quizViewModel.badgeEarned) { newValue in
            if newValue {
                viewModel.fetchUserBadges()
                quizViewModel.badgeEarned = false
            }
        }
        .onChange(of: calculatorViewModel.badgeEarned) { newValue in
            if newValue {
                viewModel.fetchUserBadges()
                calculatorViewModel.badgeEarned = false
            }
        }
    }
}
struct BadgesView: View {
    let badges: [Badge]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if badges.isEmpty {
                HStack {
                    Image(systemName: "star.slash")
                        .foregroundColor(.gray)
                    Text("You haven't earned any badges yet.")
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 160), spacing: 16)
                ], spacing: 16) {
                    ForEach(badges) { badge in
                        BadgeRow(badge: badge)
                    }
                }
            }
        }
    }
}

struct BadgeRow: View {
    let badge: Badge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: getBadgeIcon(for: badge.type))
                    .font(.title2)
                    .foregroundColor(getBadgeColor(for: badge.level))
                Spacer()
                Text(badge.level.rawValue.capitalized)
                    .font(.caption)
                    .padding(4)
                    .background(getBadgeColor(for: badge.level).opacity(0.2))
                    .cornerRadius(4)
            }
            
            Text(badge.name)
                .font(.headline)
            
            Text(badge.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Text(formatDate(badge.dateEarned))
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 3)
    }
    
    private func getBadgeIcon(for type: Badge.BadgeType) -> String {
        switch type {
        case .knowledge: return "book.fill"
        case .skill: return "hammer.fill"
        case .achievement: return "star.fill"
        case .community: return "person.2.fill"
        case .calculators: return "calculator"
        }
    }
    
    private func getBadgeColor(for level: Badge.BadgeLevel) -> Color {
        switch level {
        case .beginner: return .green
        case .intermediate: return .blue
        case .advanced: return .purple
        case .expert: return .orange
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Earned on " + formatter.string(from: date)
    }
}
