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
