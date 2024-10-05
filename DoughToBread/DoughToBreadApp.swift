//
//  DoughToBreadApp.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 9/13/24.
//
import SwiftUI
import Firebase
import GoogleSignIn

@main
struct DoughToBreadApp: App {
    init() {
        // Firebase initialization
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
                //Handle Google Oauth URL
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
