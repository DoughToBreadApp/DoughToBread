//
//  MainAppView.swift
//  DoughToBread
//
//  Created by Nona Nersisyan on 10/3/24.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct MainAppView: View {
    var shouldNavigate: Bool
    
    var body: some View {
        TabView {
            CoursesView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Courses")
                }
            
            CalculatorView()
                .tabItem {
                    Image(systemName: "function")
                    Text("Calculator")
                }
            
            UserProfileView(shouldNavigate: shouldNavigate)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

struct CoursesView: View {
    var body: some View {
        Text("Courses View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}

struct CalculatorView: View {
    var body: some View {
        Text("Calculator View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}
