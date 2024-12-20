//
//  CalculatorViewModel.swift
//  DoughToBread
//
//  Created by Neil Maharishi on 11/17/24.
//


import Foundation
import Firebase
import FirebaseAuth


// The CalculatorViewModel tracks a user's calculator usage and awards badges accordingly.

class CalculatorViewModel: ObservableObject {
    @Published var badgeEarned = false
    @Published var calculatorUseCount = 0 // tracks total calculator usage of user
    
    // increments user's calculator usage; reflects changes in Firestore in the 'calculator_usage' collection
    func incrementCalculatorUse() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        // get the current count
        db.collection("calculator_usage").document(userId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists,
               let count = document.data()?["useCount"] as? Int {
                self?.calculatorUseCount = count + 1
            } else {
                self?.calculatorUseCount = 1
            }
            
            // update the count in Firestore
            db.collection("calculator_usage").document(userId).setData([
                "useCount": self?.calculatorUseCount ?? 1
            ], merge: true)
            
            // award badge based on count
            self?.awardCalculatorBadge()
        }
    }
    
    // getBadgeLevel() determines the user's badge level based on their calculator usage
    private func getBadgeLevel() -> Badge.BadgeLevel {
        switch calculatorUseCount {
            case 1: return .beginner
            case 2: return .intermediate
            case 3: return .advanced
            default: return .expert
        }
    }
    
    // getBadgeName() determines the user's badge level based on their calculator usage
    private func getBadgeName() -> String {
        switch calculatorUseCount {
            case 1: return "Calculator Novice"
            case 2: return "Calculator Intermediate"
            case 3: return "Calculator Advanced"
            default: return "Calculator Expert"
        }
    }
    
    // handles badge awarding
    // 1. checks if the user has badge
    // 2. if not, create a new badge for user
    // 3. persist the new badge to firestore
    // 4. sets badgeEarned to true, which should result in badge appearing on profile page
    func awardCalculatorBadge() {
        let badgeName = getBadgeName()
        checkForExistingBadge(name: badgeName) { [weak self] badgeExists in
            if badgeExists {
                print("User already has the \(badgeName) badge")
                return
            }
            
            let newBadge = Badge(
                id: UUID().uuidString,
                name: badgeName,
                description: "Used the calculator \(self?.calculatorUseCount ?? 0) times",
                level: self?.getBadgeLevel() ?? .beginner,
                type: .calculators,
                dateEarned: Date()
            )
            
            if let userId = Auth.auth().currentUser?.uid {
                let db = Firestore.firestore()
                let badgeData: [String: Any] = [
                    "name": newBadge.name,
                    "description": newBadge.description,
                    "level": newBadge.level.rawValue,
                    "type": newBadge.type.rawValue,
                    "dateEarned": Timestamp(date: newBadge.dateEarned)
                ]
                db.collection("user_badges").document(userId).setData([
                    "badges": [newBadge.id: badgeData]
                ], merge: true) { error in
                    if let error = error {
                        print("Error saving badge: \(error)")
                    } else {
                        print("Badge saved successfully")
                        DispatchQueue.main.async {
                            self?.badgeEarned = true
                        }
                    }
                }
            }
        }
    }
    
    func checkForExistingBadge(name: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("user_badges").document(userId).getDocument { (document, error) in
            if let document = document, document.exists,
               let badgesData = document.data()?["badges"] as? [String: [String: Any]] {
                let badgeExists = badgesData.values.contains { $0["name"] as? String == name }
                completion(badgeExists)
            } else {
                completion(false)
            }
        }
    }
}
