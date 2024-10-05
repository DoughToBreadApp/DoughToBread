//
//  ExampleModel.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 9/16/24.
//

// UserProfile.swift
import Foundation

struct UserProfile {
    var id: String
    var name: String
    var email: String
    var balance: Double
    
    init(id: String = UUID().uuidString, name: String = "", email: String = "", balance: Double = 0.0) {
        self.id = id
        self.name = name
        self.email = email
        self.balance = balance
    }
}
