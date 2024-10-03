import SwiftUI
import FirebaseAuth
import Foundation
import Firebase

struct Homepage: View {
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Text("Welcome to Dough To Bread")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            if let user = Auth.auth().currentUser {
                Text("Hello " + (user.displayName ?? "Username not found"))
                    .font(.headline)
            } else {
                Text("Hello Guest")
                    .font(.headline)
            }
            
            Button {
                Task {
                    do {
                        try await Authentication().logout()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Text("Log Out")
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
            
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

struct Homepage_Previews: PreviewProvider {
    static var previews: some View {
        Homepage()
    }
}
