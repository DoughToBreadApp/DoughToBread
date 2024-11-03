//
//  DailyBreadView.swift
//  DoughToBread
//
//  Created by Mileana Minasyan on 11/2/24.
//

import Foundation
import SwiftUI

struct DailyBreadView: View {
    @StateObject private var viewModel = DailyBreadViewModel()
    @State private var dailyBread = DailyBread()
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        ScrollView {
            VStack {
                let dailyBread = viewModel.getTodaysVerse()
                    Text("Daily Bread")
                    .font(.system(size: 54, weight: .bold))
                        //.fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.green)
                        .padding()
                        
                    Text(dailyBread.title)
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                        .italic()
                        .padding(.vertical, 5)
                    Text(dailyBread.verse)
                        .font(.subheadline)
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

