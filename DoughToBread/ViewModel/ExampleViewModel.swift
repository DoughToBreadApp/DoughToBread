//
//  ExampleViewModel.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 9/16/24.
//

// UserProfileViewModel.swift
import Foundation
import Combine

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
}
