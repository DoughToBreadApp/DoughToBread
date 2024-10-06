import SwiftUI

struct PollView: View {
    @ObservedObject var viewModel = PollViewModel()
    @State private var pollSubmitted = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.questions) { question in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(question.text)
                                .font(.headline)
                            ForEach(question.options) { option in
                                OptionRow(
                                    question: question,
                                    option: option,
                                    isSelected: option.id == question.selectedOption?.id,
                                    action: { selectedOption in
                                        viewModel.updateSelection(for: question, option: selectedOption)
                                    }
                                )
                            }
                        }
                        .padding()
                    }

                    if viewModel.allQuestionsAnswered {
                        NavigationLink(
                            destination: MainAppView(shouldNavigate: true)
                                .navigationBarBackButtonHidden(true) // Hide the back button
                                .navigationBarHidden(true), // Hide the navigation bar for this view
                            isActive: $pollSubmitted
                        ) {
                            Button(action: {
                                viewModel.submitPoll()
                                pollSubmitted = true // Set this to true when the poll is submitted
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
            .navigationBarHidden(pollSubmitted) // Hide navigation bar on submit
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures no stacking of views
    }
}

struct OptionRow: View {
    let question: Question
    let option: Question.Option
    let isSelected: Bool
    let action: (Question.Option) -> Void

    @State private var otherText: String = ""

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .onTapGesture {
                    action(option)
                }
            Text(option.text)
                .onTapGesture {
                    action(option)
                }
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

struct Poll_Previews: PreviewProvider {
    static var previews: some View {
        PollView()
    }
}
