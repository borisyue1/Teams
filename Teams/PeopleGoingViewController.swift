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
    var users: [User] = []
    var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "People Going"
        createLoader()
        view.backgroundColor = UIColor.white

        self.fetchPeopleGoing {
            self.loader.removeFromSuperview()
            self.setUpTableView()
        }
        
    }
    
    func createLoader() {
        loader = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2 - 50, width: 100, height: 100))
        let transform = CGAffineTransform(scaleX: 2, y: 2)
        loader.layer.zPosition = 100
        loader.transform = transform
        loader.startAnimating()
        loader.tintColor = UIColor.black
        view.addSubview(loader)
    }
  
    
    func setUpTableView() {
        if let _ = navigationController {
            tableView = UITableView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height - (navigationController?.navigationBar.frame.maxY)!))
            tableView.register(PeopleGoingTableViewCell.self, forCellReuseIdentifier: "peopleCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            
            tableView.backgroundColor = UIColor.white
            
            view.addSubview(tableView)
        }
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
        return 80
    }
}

