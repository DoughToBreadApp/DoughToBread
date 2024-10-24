//
//  QuizViewModel.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 10/19/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion]
    @Published var quizCompleted = false
    @Published var correctAnswersCount = 0
    @Published var badgeEarned = false
    
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


    func awardBadgeIfEligible() {
        if quizCompleted {
            let badgeName = "Quiz Expert"
            checkForExistingBadge(name: badgeName) { [weak self] badgeExists in
                if badgeExists {
                    print("User already has the \(badgeName) badge")
                    return
                }
                
                let newBadge = Badge(
                    id: UUID().uuidString,
                    name: badgeName,
                    description: "Completed a quiz with 100% accuracy",
                    level: .beginner,
                    type: .knowledge,
                    dateEarned: Date()
                )
                
                if let userId = Auth.auth().currentUser?.uid {
                    let db = Firestore.firestore()
                    let badgeData: [String: Any] = [
                        "name": newBadge.name,
                        "description": newBadge.description,
                        "level": newBadge.level.rawValue,
                        "type": newBadge.type.rawValue,
                        "dateEarned": Timestamp(date: newBadge.dateEarned)
                    ]
                    db.collection("user_badges").document(userId).setData([
                        "badges": [newBadge.id: badgeData]
                    ], merge: true) { error in
                        if let error = error {
                            print("Error saving badge: \(error)")
                        } else {
                            print("Badge saved successfully")
                            DispatchQueue.main.async {
                                self?.badgeEarned = true
                            }
                        }
                    }
                } else {
                    print("No user logged in, can't save badge")
                }
            }
        }
    }
    
    func checkAnswers() {
        correctAnswersCount = questions.filter { $0.selectedAnswerIndex == $0.correctAnswerIndex }.count
        quizCompleted = correctAnswersCount == questions.count
        if quizCompleted {
            awardBadgeIfEligible()
        }
    }

    func checkForExistingBadge(name: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
    
        let db = Firestore.firestore()
        db.collection("user_badges").document(userId).getDocument { (document, error) in
            if let document = document, document.exists,
            let badgesData = document.data()?["badges"] as? [String: [String: Any]] {
                let badgeExists = badgesData.values.contains { $0["name"] as? String == name }
                completion(badgeExists)
            } else {
                completion(false)
            }
        }
    }
    
    var allQuestionsAnswered: Bool {
        questions.allSatisfy { $0.selectedAnswerIndex != nil }
    }


}
