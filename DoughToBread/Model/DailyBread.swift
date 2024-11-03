//
//  DailyBread.swift
//  DoughToBread
//
//  Created by Mileana Minasyan on 11/2/24.
//

import Foundation

struct DailyBread: Identifiable, Decodable{
    let id: String
    var title: String
    var verse: String
    var body: String
    //var comment: String?
    
    init(title: String = "", verse: String = "", body: String = "" /*comment: String? = ""*/)
    {
        self.id = UUID().uuidString
        self.title = title
        self.verse = verse
        self.body = body
        //self.comment = comment
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = UUID().uuidString  // Generate a new UUID for id
            self.title = try container.decode(String.self, forKey: .title)
            self.verse = try container.decode(String.self, forKey: .verse)
            self.body = try container.decode(String.self, forKey: .body)
        }
    
    enum CodingKeys: String, CodingKey {
        case title, verse, body
    }
}
