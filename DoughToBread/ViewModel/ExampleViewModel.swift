//
//  ExampleViewModel.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 9/16/24.
//

// UserProfileViewModel.swift
import Foundation
import Combine
import Firebase
import FirebaseAuth

class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    
    init(userProfile: UserProfile = UserProfile()) {
        self.userProfile = userProfile
    }
    
    func updateName(_ name: String) {
        userProfile.name = name
    }
    
    func updateEmail(_ email: String) {
        userProfile.email = email
    }
    
    func addFunds(_ amount: Double) {
        userProfile.balance += amount
    }
    
    func withdrawFunds(_ amount: Double) {
        if amount <= userProfile.balance {
            userProfile.balance -= amount
        }
    }
    
    @Published var userBadges: [Badge] = []

func fetchUserBadges() {
    guard let userId = Auth.auth().currentUser?.uid else { 
        print("No user logged in")
        return 
    }
    print("Fetching badges for user: \(userId)")
    let db = Firestore.firestore()
    db.collection("user_badges").document(userId).getDocument { [weak self] (document, error) in
        if let error = error {
            print("Error fetching user badges: \(error)")
            return
        }
        
        DispatchQueue.main.async {
            if let document = document, document.exists {
                print("Document data: \(document.data() ?? [:])")
                if let badgesData = document.data()?["badges"] as? [String: [String: Any]] {
                    self?.userBadges = badgesData.compactMap { (key, value) in
                        guard let name = value["name"] as? String,
                            let description = value["description"] as? String,
                            let levelString = value["level"] as? String,
                            let typeString = value["type"] as? String,
                            let dateEarned = (value["dateEarned"] as? Timestamp)?.dateValue(),
                            let level = Badge.BadgeLevel(rawValue: levelString),
                            let type = Badge.BadgeType(rawValue: typeString) else {
                            print("Failed to parse badge data: \(value)")
                            return nil
                        }
                        return Badge(id: key, name: name, description: description, level: level, type: type, dateEarned: dateEarned)
                    }
                    print("Fetched badges: \(self?.userBadges ?? [])")
                } else {
                    print("No badges found in document")
                    self?.userBadges = []
                }
            } else {
                print("Document does not exist")
                self?.userBadges = []
            }
        }
    }
}
}
