//
//  PeopleGoingViewController.swift
//  Teams
//
//  Created by Shireen Warrier on 4/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

class PeopleGoingViewController: UIViewController {
    
    var eventsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Event")
    var tableView: UITableView!
    var currKey: String?
    var exitButton: UIButton!
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupExitButton()
        view.backgroundColor = UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
//        user = FeedViewController.user
//        User.fetchUser(withBlock: { user in
//            FeedViewController.user = user
//            
//            User.getImage(atPath: user.imageUrl, withBlock: { image in
////                cell.profilePic.image = image
//            })
        
            self.fetchPeopleGoing {
                self.setUpTableView()
            }
//        })
        
    }
    
    func setupExitButton() {
        exitButton = UIButton(frame: CGRect(x: 10, y: 25, width: 25, height: 25))
        exitButton.addTarget(self, action: #selector(exitPressed), for: .touchUpInside)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        view.addSubview(exitButton)
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: exitButton.frame.maxY, width: view.frame.width, height: view.frame.height - exitButton.frame.height))
        tableView.register(PeopleGoingTableViewCell.self, forCellReuseIdentifier: "peopleCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        
        view.addSubview(tableView)
    }
    
    func exitPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchPeopleGoing(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let schoolRef = eventsRef.child(FeedViewController.user.school)        
        schoolRef.child(currKey!).child("peopleGoing").observe(.childAdded, with: { (snapshot) in
//            var value = snapshot.value as! [String: Any]
            let id = snapshot.value as! String
            User.generateUserModel(withId: id, withBlock: { user in
                self.users.append(user)
                withBlock() //ensures that next block is called
            })
            
        })
    }

}

extension PeopleGoingViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell") as! PeopleGoingTableViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        
        let currentPerson = users[indexPath.row]
        cell.name.text = currentPerson.name
        User.getImage(atPath: currentPerson.imageUrl, withBlock: { image in
            cell.profilePic.image = image
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

