//
//  DailyBreadView.swift
//  DoughToBread
//
//  Created by Mileana Minasyan on 11/2/24.
//

import Foundation
import SwiftUI

struct DailyBreadView: View {
    //viewModel variable for loading scripture of the day that gets set to dailyBread
    @StateObject private var viewModel = DailyBreadViewModel()
    @State private var dailyBread = DailyBread()
    //allows for closing daily bread
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        ScrollView {
            VStack {
                //prints the elements of dailyBread object vertically
                let dailyBread = viewModel.getTodaysVerse()
                    Text("Daily Bread")
                        .font(.system(size: 54, weight: .bold))
                        .foregroundStyle(.green)
                        .padding()
                    Text(dailyBread.title)
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 5)
                    Text(dailyBread.verse)
                        .font(.custom("American Typewriter", size: 18))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 10)
                    Text(dailyBread.body)
                        .font(.subheadline)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 5)

                Spacer()
            }
            .padding()
            
            Spacer()
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

#Preview {
    DailyBreadView()
}

