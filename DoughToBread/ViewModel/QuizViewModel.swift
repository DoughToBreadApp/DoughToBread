//
//  QuizViewModel.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 10/19/24.
//

import Foundation
import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion]
    @Published var quizCompleted = false
    @Published var correctAnswersCount = 0
    
    init() {
        self.questions = [
            QuizQuestion(text: "What are the three main categories of expenses in budgeting?",
                         options: ["Fixed, Variable, and Discretionary", "Essential, Non-essential, and Luxury", "Income, Expenses, and Savings", "Short-term, Mid-term, and Long-term"],
                         correctAnswerIndex: 0),
            QuizQuestion(text: "Which of the following is an example of a fixed expense?",
                         options: ["Groceries", "Entertainment", "Rent or mortgage", "Fuel costs"],
                         correctAnswerIndex: 2),
            QuizQuestion(text: "What is the recommended first step in creating a personal budget?",
                         options: ["Set priorities", "List your expenses", "Identify your income", "Plan for savings"],
                         correctAnswerIndex: 2),
            QuizQuestion(text: "What is the primary purpose of an emergency fund?",
                         options: ["To save for retirement", "To cover unexpected expenses", "To invest in stocks", "To pay for vacations"],
                         correctAnswerIndex: 1),
            QuizQuestion(text: "Which of the following is a recommended saving technique?",
                         options: ["Spending more to boost the economy", "Borrowing money to increase savings", "Automatic transfers to savings accounts", "Avoiding all discretionary expenses"],
                         correctAnswerIndex: 2)
        ]
    }
    
    func updateSelection(for questionIndex: Int, option optionIndex: Int) {
        questions[questionIndex].selectedAnswerIndex = optionIndex
    }
    
    func checkAnswers() {
        correctAnswersCount = questions.filter { $0.selectedAnswerIndex == $0.correctAnswerIndex }.count
        quizCompleted = correctAnswersCount == questions.count
    }
    
    var allQuestionsAnswered: Bool {
        questions.allSatisfy { $0.selectedAnswerIndex != nil }
    }
}
