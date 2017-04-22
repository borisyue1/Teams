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
    var location: String?
    var date: String?
    var comments: [String] = []
<<<<<<< HEAD
    let schoolRef = FIRDatabase.database().reference().child("Event").child(FeedViewController.user.school)
    
=======
    let eventRef = FIRDatabase.database().reference().child("Event")
>>>>>>> 9f2277b15903815888ca076b4e441e28d7057e7b
    var NSDate: Date? //change name later
    
    //used to create fake events
    init(author: String, sport: String, description: String, peopleGoing: [String], date: String, location: String) {
        self.author = author
        self.sport = sport
        self.description = description
        self.peopleGoing = peopleGoing
        self.date = date
        self.location = location
    }
    
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        if postDict != nil {
            if let description = postDict!["description"] as? String {
                self.description = description
            }
            if let author = postDict!["author"] as? String {
                self.author = author
            }
            if let authorPhoneNumber = postDict!["authorPhoneNumber"] as? Int {
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
            if let location = postDict!["location"] as? String {
                self.location = location
            }
            if let comments = postDict!["comments"] as? [String] {
                self.comments = comments
            }
        }
    }
    
    func addInterestedUser(id: String, user: User) {
        let schoolRef = eventRef.child(user.school!)
        self.peopleGoing.append(id)
        let childUpdates = ["\(self.id!)/peopleGoing": self.peopleGoing]
        schoolRef.updateChildValues(childUpdates) //update interested array
        
        user.eventsJoined.append(self.id!)
        let userUpdate = ["\(user.id!)/eventsJoined": user.eventsJoined]
        FIRDatabase.database().reference().child("Users").updateChildValues(userUpdate)
        
    }
    
    func removeInterestedUser(id: String, user: User) {
        let schoolRef = eventRef.child(user.school!)
        self.peopleGoing.remove(at: self.peopleGoing.index(of: id)!)
        let childUpdates = ["\(self.id!)/peopleGoing": self.peopleGoing]
        schoolRef.updateChildValues(childUpdates) //update interested array
        
        user.eventsJoined.remove(at: user.eventsJoined.index(of: self.id!)!)
        let userUpdate = ["\(user.id!)/eventsJoined": user.eventsJoined]
        FIRDatabase.database().reference().child("Users").updateChildValues(userUpdate)
    }
}
