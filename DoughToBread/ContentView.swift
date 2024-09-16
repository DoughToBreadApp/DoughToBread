//
//  ContentView.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 9/13/24.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct ContentView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)

    var body: some View {
        VStack {
            if userLoggedIn {
                Homepage()
            } else {
                Login()
            }
        }.onAppear{
            //Firebase state change listeneer
            Auth.auth().addStateDidChangeListener{ auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
