//
//  MainAppView.swift
//  DoughToBread
//
//  Created by Nona Nersisyan on 10/3/24.
//
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Section: Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var subsections: [Subsection]
}

struct Subsection: Identifiable {
    var id = UUID()
    var title: String
    var content: String
}

struct CoursesView: View {
    @State private var modules: [Module] = []

    var body: some View {
        NavigationView {
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
        .onAppear(perform: loadModules)
    }
    
    func loadModules() {
        let db = Firestore.firestore()
        db.collection("modules").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
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

struct ModuleDetailView: View {
    var moduleId: String
    @State private var moduleData: [String: Any] = [:]
    @State private var sections: [Section] = []
    @State private var showQuiz = false

    var body: some View {
        ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if let name = moduleData["name"] as? String {
                            Text(name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }

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
                .onAppear {
                    loadModuleContent()
                }
                .sheet(isPresented: $showQuiz) {
                    QuizView(viewModel: QuizViewModel())
                }
            }

    func loadModuleContent() {
        let db = Firestore.firestore()
        db.collection("modules").document(moduleId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                self.moduleData = data
                
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

struct MainAppView: View {
    var shouldNavigate: Bool
    @State var showInteractiveWindow : Bool = false
    
    var body: some View {
        NavigationView{
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInteractiveWindow = true
                    }) {
                        Image(systemName: "message.badge")
                    }
                }
            }
            .onAppear {
                // set the tab bar background color
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .systemBackground
                
                UITabBar.appearance().scrollEdgeAppearance = appearance
                UITabBar.appearance().standardAppearance = appearance
            }
        }
        .sheet(isPresented: $showInteractiveWindow) {
            DailyBreadView()
        }
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

#Preview {
    MainAppView(shouldNavigate: true)
}
