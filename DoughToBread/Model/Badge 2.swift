//
//  Badge.swift
//  DoughToBread
//
//  Created by Neil Maharishi on 10/29/24.
//


//
//  Badge.swift
//  DoughToBread
//
//  Created by Neil Maharishi on 10/21/24.
//


// This file contains the struct implementation for the application's badges.
// Currently, badges come in four levels (beginner, intermediate, advanced, expert).
// Calculator and knowledge badge implementations have been completed.
// The community badge is incomplete as we did not yet implement the comment/interaction sections.

import Foundation
import FirebaseFirestore

struct Badge: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var level: BadgeLevel
    var type: BadgeType
    var dateEarned: Date
    
    enum BadgeLevel: String, Codable {
        case beginner, intermediate, advanced, expert
    }
    
    enum BadgeType: String, Codable {
        case knowledge, skill, achievement, community, calculators
    }
}
