//
//  Comment.swift
//  Teams
//
//  Created by Boris Yue on 4/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Haneke

class Comment {
    
    var author: String?
    var text: String?
    var id: String?
    var imageUrl: String!
    
    init(id: String, commentDict: [String:Any]?) {
        self.id = id
        if commentDict != nil {
            if let author = commentDict!["author"] as? String {
                self.author = author
            }
            if let text = commentDict!["text"] as? String {
                self.text = text
            }
            if let image = commentDict!["imageUrl"] as? String {
                self.imageUrl = image
            }
        }
    }
}
