//
//  DailyBreadView.swift
//  DoughToBread
//
//  Created by Mileana Minasyan on 11/2/24.
//

// Import required frameworks
import Foundation
import SwiftUI

// Main view for displaying daily devotional content
struct DailyBreadView: View {
    // StateObject to manage daily bread content and logic
    @StateObject private var viewModel = DailyBreadViewModel()
    // State variable to store current daily bread content
    @State private var dailyBread = DailyBread()
    // Environment variable to handle view dismissal
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        // Scrollable container for content
        ScrollView {
            VStack {
                // Get today's verse from view model
                let dailyBread = viewModel.getTodaysVerse()
                
                // Title "Daily Bread"
                Text("Daily Bread")
                    .font(.system(size: 54, weight: .bold))
                    .foregroundStyle(.green)
                    .padding()
                    
                // Verse title
                Text(dailyBread.title)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 5)
                
                // Bible verse text with custom font
                Text(dailyBread.verse)
                    .font(.custom("American Typewriter", size: 18))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                
                // Devotional body text
                Text(dailyBread.body)
                    .font(.subheadline)
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 5)

                Spacer()
            }
            .padding()
            
            Spacer()
            
            // Close button to dismiss the view
            Button("Close") {
                dismiss()  // Closes the sheet
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

// Preview provider for SwiftUI canvas
#Preview {
    DailyBreadView()
}
