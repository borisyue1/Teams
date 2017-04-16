//
//  FeedViewController.swift
//  Teams
//
//  Created by Boris Yue on 4/4/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    var tableView: UITableView!
    var events: [Event] = []
    var auth = FIRAuth.auth()
    var eventsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Event")
    var plusSign: UIImageView!
    var currKey: String?
    var postIds: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.title = "All Sports"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated: true) //hide back button
        let originalImage = UIImage(named: "add.png")
//        let scaledIcon = UIImage(cgImage: originalImage!.cgImage!, scale: 5, orientation: originalImage!.imageOrientation)
        let addButton = UIBarButtonItem(image: originalImage, style: .plain, target: self, action: #selector(createEvent))
        addButton.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(addButton, animated: true)
        fetchPosts {
            self.setUpTableView()
        }
    }


    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height))
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height / 10, right: 0)
        tableView.tableFooterView = UIView() // gets rid of the extra cells beneath
        view.addSubview(tableView)
    }
    
    func rowHeight() -> CGFloat {
        return 200
    }
    
    func createEvent() {
//        performSegue(withIdentifier: "toNew", sender: self)
//        self.navigationController?.pushViewController(NewEventViewController(), animated: true)
        self.present(NewEventViewController(), animated: true, completion: nil)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let schoolRef = eventsRef.child(UserDefaults.standard.value(forKey: "school") as! String)
        schoolRef.queryOrdered(byChild: "date").observe(.childAdded, with: { (snapshot) in
            let post = Event(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            self.events.append(post)
            self.postIds.append(snapshot.key)
            print(snapshot.key)
            withBlock() //ensures that next block is called
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            let view = segue.destination as! CommentViewController
            view.currKey = currKey
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! FeedTableViewCell
        let currentEvent = events[indexPath.row]
        cell.sport = currentEvent.sport
        cell.author = currentEvent.author
        
        cell.school = UserDefaults.standard.value(forKey: "school") as! String
        
        var dateString: String!
        dateString = currentEvent.date!
        
        cell.month = dateString.substring(to: dateString.index(dateString.startIndex, offsetBy: 3)).uppercased()
        
        cell.day = Int(dateString.substring(to: dateString.index(dateString.startIndex, offsetBy: 6)).substring(from: dateString.index(dateString.startIndex, offsetBy: 4)))
        cell.time = dateString.substring(from: dateString.index(dateString.startIndex, offsetBy: 13))
        cell.eventDescription = currentEvent.description
        cell.location = currentEvent.location
        cell.awakeFromNib()
        
        print("SPORT: ", cell.sport)
        
        switch currentEvent.sport! {
        case "Soccer":
            cell.pic.image = #imageLiteral(resourceName: "soccer")
        case "Football":
            cell.pic.image = #imageLiteral(resourceName: "football")
        case "Tennis":
            cell.pic.image = #imageLiteral(resourceName: "tennis")
        default:
            cell.pic.image = #imageLiteral(resourceName: "frisbee")
            
        }
        cell.numGoingLabel.text = "\(currentEvent.peopleGoing.count) going"
        cell.numGoingLabel.sizeToFit()
        //        cell.contentView.addSubview(cell.pic)
        //cell.timeLabel.text = currentEvent.date
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currKey = postIds[events.count - 1 - indexPath.row]
        
        let commentView = CommentViewController()
        commentView.currKey = currKey
        self.present(commentView, animated: true, completion: nil)
        
    }
}
