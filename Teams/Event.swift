//
//  Event.swift
//  Teams
//
//  Created by Amy on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Event {
    
    var author: String?
    var authorPhoneNumber: Int?
    var sport: String?
    var description: String?
    var id: String?
    var peopleGoing: [String] = []
    var date: String?
    var location: String?

    
    //used to create fake events
    init(author: String, sport: String, description: String, peopleGoing: [String], date: String, location: String) {
        self.author = author
        self.sport = sport
        self.description = description
        self.peopleGoing = peopleGoing
        self.date = date
        self.location = location
    }
}
