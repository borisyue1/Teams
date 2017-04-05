//
//  DetailViewController.swift
//  Teams
//
//  Created by Amy on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    var event : Event!
    //not sure how to access current user name
    var currUserName : UILabel!
    var author: UILabel!
    var authorPhoneNumber: UILabel!
    var date: UILabel!
    var sport: UILabel!
    var description: UITextView!
    var peopleGoing: [String] = []
    var location: UILabel!
    var numGoing: UILabel!
    var joinButton: UIButton!
    var lightGrayRect: UIView!
    var whiteBox: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sets the gray background and light gray rectangle for all the info
        setBackground()
        
        //sets "Person is playing ___"
        setTitle()
        
        //sets date, location, description, phone number, join button
        setMain()
        
        //sets fake comments
        setComments()
        
    }
    
    func setBackground() {
        self.view.backgroundColor = UIColor.gray
        lightGrayRect = UIView(frame: CGRect(x: 0, y: 5, width: view.frame.width, height: view.frame.height/3))
        lightGrayRect.backgroundColor = UIColor.lightGray
        view.addSubview(lightGrayRect)
    }
    
    func setTitle() {
        author = UILabel(frame: CGRect(x: 5, y: 10, width: view.frame.width, height: 10))
        author.text = event.author + " is playing " + event.sport
        author.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
        view.addSubview(author)
    }
    
    func setMain() {
        whiteBox = UIView(frame: CGRect(x: 10, y: 20, width: view.frame.width - 20, height: view.frame.height/3 - 30))
        date = UILabel(frame: CGRect(x: 20, y: 30, width: 30, height: 30))
        date.text = event.date
        date.font = UIFont(name: "HelveticaNeue-Thin", size: 19)
        numGoing = UILabel(frame: CGRect(x: 20, y: 60, width: 30, height: 10))
        numGoing.text = event.peopleGoing.count + " going"
        numGoing.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
        location = UILabel(frame: CGRect(x: 60, y: 30, width: 100, height: 30))
        location.text = "@ " + event.location
        location.font = UIFont(name: "HelveticaNeue-Thin", size: 55)
        description = UITextField(frame: CGRect(x: 80, y: 60, width: view.frame.width - 50, height: view.frame.height/4))
        description.text = event.description
        description.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
        
        
        view.addSubview(whiteBox)
        view.addSubview(date)
        view.addSubview(numGoing)
        view.addSubview(location)
        view.addSubview(description)
    }
    
    
    
}
