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
    var peopleArray: [String]! = []
    var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupExitButton()
        
        User.fetchUser(withBlock: { user in
            FeedViewController.user = user
            
            User.getImage(atPath: user.imageUrl, withBlock: { image in
                cell.profilePic.image = image
            })
            
            self.fetchPeopleGoing {
                self.setUpTableView()
            }
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupExitButton() {
        exitButton = UIButton(frame: CGRect(x: 5, y: 20, width: 25, height: 25))
        exitButton.addTarget(self, action: #selector(exitPressed), for: .touchUpInside)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        view.addSubview(exitButton)
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: exitButton.frame.maxY, width: view.frame.width, height: view.frame.height - exitButton.frame.maxY - exitButton.frame.height))
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
            
            var dict = snapshot.value as! [String: Any]
            
            for item in dict {
                self.peopleArray.append(item.value as! String)
            }
            
            withBlock() //ensures that next block is called
        })
    }

}

extension PeopleGoingViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell") as! PeopleGoingTableViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        
        let currentPerson = peopleArray[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

