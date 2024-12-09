//
//  QuizView.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 10/19/24.
//

// Import required frameworks
import Foundation
import SwiftUI

// Main quiz view structure
struct QuizView: View {
    // Observed object for managing quiz state and logic
    @ObservedObject var viewModel: QuizViewModel
    // State variables to control result display and quiz submission
    @State private var showingResult = false
    @State private var quizSubmitted = false
    
    var body: some View {
        // Navigation wrapper for quiz flow
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Display all quiz questions
                    ForEach(viewModel.questions.indices, id: \.self) { index in
                        questionView(for: viewModel.questions[index], index: index)
                    }
                    
                    // Show check answers button when all questions are answered
                    if viewModel.allQuestionsAnswered {
                        Button(action: {
                            viewModel.checkAnswers()
                            showingResult = true
                        }) {
                            Text("Check Answers")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    
                    // Show submit button when quiz is completed successfully
                    if viewModel.quizCompleted {
                        NavigationLink(
                            destination: MainAppView(shouldNavigate: true)
                                .navigationBarBackButtonHidden(true) // Prevent going back
                                .navigationBarHidden(true),
                            isActive: $quizSubmitted
                        ) {
                            Button(action: {
                                quizSubmitted = true
                            }) {
                                Text("Submit Quiz")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Understanding Financial Basics Quiz")
            // Alert to show quiz results
            .alert(isPresented: $showingResult) {
                Alert(
                    title: Text("Quiz Results"),
                    message: Text(viewModel.quizCompleted
                                  ? "Congratulations! You got all 5 questions correct."
                                  : "You got \(viewModel.correctAnswersCount)/5 correct. Please try again."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Prevent navigation stack issues
    }
    
    // Helper function to create view for individual questions
    private func questionView(for question: QuizQuestion, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Question text
            Text(question.text)
                .font(.headline)
            // Question options
            ForEach(question.options.indices, id: \.self) { optionIndex in
                QuizOptionRow(
                    option: question.options[optionIndex],
                    isSelected: question.selectedAnswerIndex == optionIndex,
                    action: {
                        viewModel.updateSelection(for: index, option: optionIndex)
                    }
                )
            }
        }
        .padding()
    }
}

// Custom view for quiz option rows
struct QuizOptionRow: View {
    let option: String // Option text
    let isSelected: Bool // Selection state
    let action: () -> Void // Selection callback
    
    var body: some View {
        HStack {
            // Custom radio button using SF Symbols
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .onTapGesture(perform: action)
            // Option text
            Text(option)
                .onTapGesture(perform: action)
        }
        .padding(.leading, 20)
    }
}

// Preview provider for SwiftUI canvas
struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(viewModel: QuizViewModel())
    }
}
