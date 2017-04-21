//
//  User.swift
//  Teams
//
//  Created by Boris Yue on 4/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Haneke

class User {
    var name: String?
    var email: String?
    var username: String?
    var id: String?
    var eventsJoined: [String] = []
    var school: String!
    var imageUrl: String!
    
    init(id: String, userDict: [String:Any]?) {
        self.id = id
        if userDict != nil {
            if let name = userDict!["fullName"] as? String {
                self.name = name
            }
            if let email = userDict!["email"] as? String {
                self.email = email
            }
            if let username = userDict!["username"] as? String {
                self.username = username
            }
            if let eventsJoined = userDict!["eventsJoined"] as? [String] {
                self.eventsJoined = eventsJoined
            }
            if let school = userDict!["school"] as? String {
                self.school = school
            }
            if let image = userDict!["profPicUrl"] as? String {
                self.imageUrl = image
            }
        }
    }
    
    static func fetchUser(withBlock: @escaping (User) -> (Void)) {
        //TODO: Implement a method to fetch posts with Firebase!
        User.generateUserModel(withId: (FIRAuth.auth()?.currentUser?.uid)!, withBlock: { (user) in //generating user in user class
            withBlock(user)
        })
    }
    
    static func generateUserModel(withId: String, withBlock: @escaping (User) -> Void) {
        let childRef = FIRDatabase.database().reference().child("Users").child(withId)
        childRef.observe(.value, with: { snapshot in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            withBlock(user)
        })
    }
    
    // Retrieves cached image using Haneke cocoapod
    static func getImage(atPath: String, withBlock: @escaping (UIImage) -> Void) {
        let cache = Shared.imageCache
        if let imageUrl = NSURL(string: atPath) {
            cache.fetch(URL: imageUrl as URL).onSuccess({ (image) in
                withBlock(image)
            })
        }
    }
}
