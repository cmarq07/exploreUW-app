//
//  Event.swift
//  ExploreUW
//
//  Created by Ryan Oh on 6/1/22.
//

import Foundation

class Event {
    var title: String!
    var date: String!
    var description: String!
    
    public init(title:String, date:String, description:String) {
        self.title = title
        self.date = date
        self.description = description
    }
}
