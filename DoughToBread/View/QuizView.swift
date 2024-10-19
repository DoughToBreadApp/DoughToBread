//
//  QuizView.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 10/19/24.
//

import Foundation
import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var showingResult = false
    @State private var quizSubmitted = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.questions.indices, id: \.self) { index in
                        questionView(for: viewModel.questions[index], index: index)
                    }
                    
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
                    
                    if viewModel.quizCompleted {
                        NavigationLink(
                            destination: MainAppView(shouldNavigate: true)
                                .navigationBarBackButtonHidden(true)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func questionView(for question: QuizQuestion, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question.text)
                .font(.headline)
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

struct QuizOptionRow: View {
    let option: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .onTapGesture(perform: action)
            Text(option)
                .onTapGesture(perform: action)
        }
        .padding(.leading, 20)
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
