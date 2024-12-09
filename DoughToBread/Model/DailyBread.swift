//
//  DailyBread.swift
//  DoughToBread
//
//  Created by Mileana Minasyan on 11/2/24.
//

import Foundation
//this file defines the structure of the DailyBread object
//will be used for displaying the daily bread scripture
//holds the title, verse, and body provided by stakeholder. These three are stored as text in the JSON file "scriptures"
struct DailyBread: Identifiable, Decodable{
    let id: String
    var title: String
    var verse: String
    var body: String
    
    //constructor
    init(title: String = "", verse: String = "", body: String = "")
    {
        self.id = UUID().uuidString
        self.title = title
        self.verse = verse
        self.body = body
    }
    
    //function for decoding an object from a serialized format (JSON in this case)
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = UUID().uuidString  // Generate a new UUID for id
            self.title = try container.decode(String.self, forKey: .title)
            self.verse = try container.decode(String.self, forKey: .verse)
            self.body = try container.decode(String.self, forKey: .body)
        }
    
    //these enum keys are used to map the keys in the serialized data to the elements of our DailyBread object
    //necessary for the decoding process
    enum CodingKeys: String, CodingKey {
        case title, verse, body
    }
}
