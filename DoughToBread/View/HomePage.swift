import SwiftUI
import Firebase
import FirebaseAuth


import SwiftUI
import FirebaseAuth

struct Homepage: View {
    @State private var errorMessage: String?
    @State private var showQuestionnaire = true
    @State private var shouldNavigate = false
    
    var body: some View {
        VStack {
            Text("Welcome to Dough To Bread")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            if showQuestionnaire {
                QuestionnaireView(shouldNavigate: $shouldNavigate)
                    .onChange(of: shouldNavigate) { newValue in
                        showQuestionnaire = !newValue
                    }
            } else if shouldNavigate {
                MainAppView(shouldNavigate: shouldNavigate)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
