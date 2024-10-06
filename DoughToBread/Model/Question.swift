//
//  Question.swift
//  DoughToBread
//
//  Created by Alex Rowshan on 10/5/24.
//
import Foundation

struct Question: Identifiable {
    let id = UUID()
    let text: String
    var options: [Option]
    var selectedOption: Option?

    struct Option: Identifiable {
        let id = UUID()
        let text: String
        var isOther: Bool = false
        var otherText: String?
    }
}
