import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

class PollViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var allQuestionsAnswered: Bool = false

    init() {
        loadQuestions()
    }

    func loadQuestions() {
            questions = [
                // Existing question
                Question(
                    text: "What are your financial goals?",
                    options: [
                        Question.Option(text: "Save for retirement"),
                        Question.Option(text: "Pay off debt"),
                        Question.Option(text: "Purchase a home"),
                        Question.Option(text: "Start or grow a business"),
                        Question.Option(text: "Build an emergency fund"),
                        Question.Option(text: "Invest in stocks or real estate"),
                        Question.Option(text: "Other (Please specify)", isOther: true)
                    ]
                ),
                
                
                Question(
                    text: "What is your biggest financial challenge right now?",
                    options: [
                        Question.Option(text: "Managing debt or loans"),
                        Question.Option(text: "Budgeting and saving"),
                        Question.Option(text: "Understanding investment options"),
                        Question.Option(text: "Preparing for retirement"),
                        Question.Option(text: "Balancing business and personal finances"),
                        Question.Option(text: "Navigating financial uncertainty due to job loss or reduced income"),
                        Question.Option(text: "Other (Please specify)", isOther: true)
                    ]
                ),
                
                
                Question(
                    text: "How do you currently manage your finances?",
                    options: [
                        Question.Option(text: "I use a budgeting app or software"),
                        Question.Option(text: "I keep a personal spreadsheet or ledger"),
                        Question.Option(text: "I mostly keep track in my head"),
                        Question.Option(text: "I seek advice from financial professionals"),
                        Question.Option(text: "I haven’t started managing my finances yet"),
                        Question.Option(text: "Other (Please specify)", isOther: true)
                    ]
                ),

               
                Question(
                    text: "What areas of financial literacy are you most interested in learning more about?",
                    options: [
                        Question.Option(text: "Budgeting and saving techniques"),
                        Question.Option(text: "Investment strategies"),
                        Question.Option(text: "Retirement planning"),
                        Question.Option(text: "Tax planning and optimization"),
                        Question.Option(text: "Understanding credit and debt management"),
                        Question.Option(text: "Entrepreneurial finance"),
                        Question.Option(text: "Other (Please specify)", isOther: true)
                    ]
                ),

               
                Question(
                    text: "How do you prefer to receive financial education and advice?",
                    options: [
                        Question.Option(text: "Online courses or webinars"),
                        Question.Option(text: "One-on-one coaching or consulting"),
                        Question.Option(text: "Reading books and articles"),
                        Question.Option(text: "Interactive workshops or seminars"),
                        Question.Option(text: "Podcasts or videos"),
                        Question.Option(text: "Financial apps and tools"),
                        Question.Option(text: "Other (Please specify)", isOther: true)
                    ]
                )
            ]
        }


    func updateSelection(for question: Question, option: Question.Option) {
        if let index = questions.firstIndex(where: { $0.id == question.id }) {
            questions[index].selectedOption = option
            checkAllQuestionsAnswered()
        }
    }

    func checkAllQuestionsAnswered() {
        allQuestionsAnswered = questions.allSatisfy { $0.selectedOption != nil }
    }

    func submitPoll() {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            // Create dictionary of poll answers
            let pollAnswers = questions.map { question in
                return [
                    "question": question.text,
                    "answer": question.selectedOption?.text ?? "",
                    "otherText": question.selectedOption?.otherText ?? ""
                ]
            }
            
            // Save to Firestore
            let db = Firestore.firestore()
            db.collection("users").document(userID).setData([
                "hasCompletedPoll": true,
                "pollAnswers": pollAnswers,
                "completedAt": FieldValue.serverTimestamp()
            ], merge: true) { error in
                if let error = error {
                    print("Error saving poll results: \(error)")
                }
            }
        }
}
