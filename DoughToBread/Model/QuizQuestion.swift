//
//  QuizQuestion.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 10/19/24.
//

import Foundation
import SwiftUI

struct QuizQuestion: Identifiable {
    let id = UUID()
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
    var selectedAnswerIndex: Int?
}
