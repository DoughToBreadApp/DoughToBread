//
//  Questionnaire.swift
//  DoughToBread
//
//  Created by Nona Nersisyan on 10/3/24.
//

import SwiftUI

struct QuestionnaireView: View {
    @Binding var shouldNavigate: Bool
    
    var body: some View {
        VStack {
            Text("Would you like to continue?")
                .font(.headline)
                .padding()
            
            HStack {
                Button("Yes") {
                    shouldNavigate = true
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("No") {
                    shouldNavigate = false
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}
