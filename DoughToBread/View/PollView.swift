// Import SwiftUI framework for UI components
import SwiftUI

// Main view for financial assessment poll
struct PollView: View {
    // ObservedObject to manage poll data and state
    @ObservedObject var viewModel = PollViewModel()
    // State variable to track if poll has been submitted
    @State private var pollSubmitted = false

    var body: some View {
        // Navigation wrapper for hierarchical navigation
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Iterate through poll questions
                    ForEach(viewModel.questions) { question in
                        VStack(alignment: .leading, spacing: 10) {
                            // Question text display
                            Text(question.text)
                                .font(.headline)
                            // Display options for each question
                            ForEach(question.options) { option in
                                OptionRow(
                                    question: question,
                                    option: option,
                                    // Check if this option is currently selected
                                    isSelected: option.id == question.selectedOption?.id,
                                    // Callback to handle option selection
                                    action: { selectedOption in
                                        viewModel.updateSelection(for: question, option: selectedOption)
                                    }
                                )
                            }
                        }
                        .padding()
                    }

                    // Show submit button only when all questions are answered
                    if viewModel.allQuestionsAnswered {
                        NavigationLink(
                            // Navigate to main app view after submission
                            destination: MainAppView(shouldNavigate: true)
                                .navigationBarBackButtonHidden(true) // Prevent going back to poll
                                .navigationBarHidden(true), // Hide navigation bar in next view
                            isActive: $pollSubmitted
                        ) {
                            // Submit button with styling
                            Button(action: {
                                viewModel.submitPoll()
                                pollSubmitted = true // Trigger navigation
                            }) {
                                Text("Submit")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Financial Assessment Poll")
            .navigationBarHidden(pollSubmitted) // Hide nav bar after submission
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Prevent view stacking issues
    }
}

// Custom view for individual poll options
struct OptionRow: View {
    let question: Question // Reference to parent question
    let option: Question.Option // Current option data
    let isSelected: Bool // Selection state
    let action: (Question.Option) -> Void // Selection callback

    // State for "Other" option text input
    @State private var otherText: String = ""

    var body: some View {
        HStack {
            // Custom radio button using SF Symbols
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .onTapGesture {
                    action(option)
                }
            // Option text
            Text(option.text)
                .onTapGesture {
                    action(option)
                }
            // Show text field for "Other" option when selected
            if option.isOther && isSelected {
                TextField("Please specify", text: $otherText, onCommit: {
                    var updatedOption = option
                    updatedOption.otherText = otherText
                    action(updatedOption)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding(.leading, 20)
    }
}

// Preview provider for SwiftUI canvas
struct Poll_Previews: PreviewProvider {
    static var previews: some View {
        PollView()
    }
}
