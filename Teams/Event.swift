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
    var authorPhoneNumber: Integer?
    var sport: String?
    var description: String?
    var id: String?
    var peopleGoing: [String] = []
    var date: String?
    
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        if postDict != nil {
            if let description = postDict!["description"] as? String {
                self.description = description
            }
            if let author = postDict!["author"] as? String {
                self.author = author
            }
            if let authorPhoneNumber = postDict!["authorPhoneNumber"] as? Integer {
                self.authorPhoneNumber = authorPhoneNumber
            }
           
            if let sport = postDict!["sport"] as? String {
                self.sport = sport
            }
            if let date = postDict!["date"] as? String {
                self.date = date
            }
            if let peopleGoing = postDict!["peopleGoing"] as? [String] {
                self.peopleGoing = peopleGoing
            }
        }
    }
}
