//
//  HomePage.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 9/16/24.
//

import SwiftUI
import FirebaseAuth

struct Homepage: View {
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
