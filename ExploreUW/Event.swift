//
//  Event.swift
//  ExploreUW
//
//  Created by Ryan Oh on 6/1/22.
//

import Foundation

class Event: Codable {
    var title: String!
    var date: String!
    var description: String!
    
    enum CodingKeys: String, CodingKey {
        case title, date, description
    }
    
    public init(title:String, date:String, description:String) {
        self.title = title
        self.date = date
        self.description = description
    }
}
