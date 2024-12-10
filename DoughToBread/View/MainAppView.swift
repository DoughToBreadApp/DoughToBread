//
//  MainAppView.swift
//  DoughToBread
//
//  Created by Nona Nersisyan on 10/3/24.
//

//  Description:
//  This file defines the main application view for the "DoughToBread" app.
//  It serves as the entry point to the app's core functionality, organizing the user experience 
//  into three primary tabs: Courses, Calculator, and Profile. Each tab provides access to a distinct
//  feature of the app.
//
//  Key Features:
//  - Courses Tab: Displays a list of available modules pulled from Firebase Firestore, 
//    with navigation to detailed module content and quizzes.
//  - Calculator Tab: Hosts financial calculation tools (implementation in `CalculatorView`).
//  - Profile Tab: Displays user profile information and navigation options.
//  - Interactive Window: Accessible via the toolbar for supplementary features.
//  - Dynamic Data Loading: Fetches modules and content in real-time from Firestore.
//  - Clean and Intuitive UI: Designed with SwiftUI for modern and responsive user interactions.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

// Define data structures for course content organization
// Section represents a main topic in a course module
struct Section: Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var subsections: [Subsection]
}

// Subsection represents subtopics within a main section
struct Subsection: Identifiable {
    var id = UUID()
    var title: String
    var content: String
}

// Main view for displaying available courses
struct CoursesView: View {
    // State variable to store course modules
    @State private var modules: [Module] = []

    var body: some View {
        // Create navigation view for course listing
        NavigationView {
            // Display modules in a list with navigation links
            List(modules) { module in
                NavigationLink(destination: ModuleDetailView(moduleId: module.id)) {
                    VStack(alignment: .leading) {
                        Text(module.name)
                            .font(.headline)
                        Text(module.description)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Courses")
        }
        // Load modules when view appears
        .onAppear(perform: loadModules)
    }
    
    // Function to fetch modules from Firestore database
    func loadModules() {
        let db = Firestore.firestore()
        db.collection("modules").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                // Map Firestore documents to Module objects
                self.modules = snapshot?.documents.map { document in
                    let data = document.data()
                    return Module(
                        id: document.documentID,
                        name: data["name"] as? String ?? "No name",
                        description: data["description"] as? String ?? "No description"
                    )
                } ?? []
            }
        }
    }
}

// Detailed view for individual course modules
struct ModuleDetailView: View {
    var moduleId: String
    // State variables to store module data and control quiz visibility
    @State private var moduleData: [String: Any] = [:]
    @State private var sections: [Section] = []
    @State private var showQuiz = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Display module name if available
                if let name = moduleData["name"] as? String {
                    Text(name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                // Iterate through sections and subsections
                ForEach(sections) { section in
                    Text(section.title)
                        .font(.headline)
                        .padding(.vertical, 5)
                    
                    Text(section.content)
                        .font(.body)

                    ForEach(section.subsections) { subsection in
                        Text(subsection.title)
                            .font(.subheadline)
                            .padding(.vertical, 3)
                        
                        Text(subsection.content)
                            .font(.body)
                    }
                }

                // Quiz button
                Button(action: {
                    showQuiz = true
                }) {
                    Text("Take Module Quiz")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        // Load content when view appears and handle quiz presentation
        .onAppear {
            loadModuleContent()
        }
        .sheet(isPresented: $showQuiz) {
            QuizView(viewModel: QuizViewModel())
        }
    }

    // Function to load detailed module content from Firestore
    func loadModuleContent() {
        let db = Firestore.firestore()
        db.collection("modules").document(moduleId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                self.moduleData = data
                
                // Parse and create section objects from Firestore data
                if let sectionData = data["sections"] as? [[String: Any]] {
                    self.sections = sectionData.map { sectionDict in
                        let title = sectionDict["title"] as? String ?? "Untitled Section"
                        let content = sectionDict["content"] as? String ?? "No content available."
                        
                        let subsections = (sectionDict["subsections"] as? [[String: Any]])?.map { subsectionDict in
                            Subsection(
                                title: subsectionDict["title"] as? String ?? "No title",
                                content: subsectionDict["content"] as? String ?? "No content available."
                            )
                        } ?? []
                        
                        return Section(title: title, content: content, subsections: subsections)
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

// Main app container view with tab navigation
struct MainAppView: View {
    var shouldNavigate: Bool
    @State var showInteractiveWindow : Bool = false
    
    var body: some View {
        NavigationView{
            // Tab view with Courses, Calculator, and Profile sections
            TabView {
                CoursesView()
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Courses")
                    }
                
                BudgetCalculatorView()
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
            // Add interactive window button to navigation bar
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInteractiveWindow = true
                    }) {
                        Image(systemName: "message.badge")
                    }
                }
            }
            // Configure tab bar appearance
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .systemBackground
                
                UITabBar.appearance().scrollEdgeAppearance = appearance
                UITabBar.appearance().standardAppearance = appearance
            }
        }
        // Present interactive window as a sheet
        .sheet(isPresented: $showInteractiveWindow) {
            DailyBreadView()
        }
    }
}

// Basic profile view placeholder
struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}

// Preview provider for SwiftUI canvas
#Preview {
    MainAppView(shouldNavigate: true)
}
