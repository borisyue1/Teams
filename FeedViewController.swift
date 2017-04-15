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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Sports"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        let originalImage = UIImage(named: "plus.png")
        let scaledIcon = UIImage(cgImage: originalImage!.cgImage!, scale: 5, orientation: originalImage!.imageOrientation)
        let addButton = UIBarButtonItem(image: scaledIcon, style: .plain, target: self, action: #selector(createEvent))
        addButton.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(addButton, animated: true)
//        generateRandomEvents()
        fetchPosts {
            self.setUpTableView()
        }
    }
    
    //creating fake ones for now
    func generateRandomEvents() {
        let event1 = Event(author: "Boris Yue", sport: "Soccer", description: "everyone is welcome!!!", peopleGoing: ["Mark", "Amy"], date: "4:20 pm", location: "Edwards Stadium")
        events.append(event1)
        let event2 = Event(author: "Boris Yue", sport: "Football", description: "looking for casual game", peopleGoing: ["Mark", "Amy", "Shireen", "Harambe", "a"], date: "5:30 pm", location: "Memorial Glade")
        events.append(event2)
        let event3 = Event(author: "Boris Yue", sport: "Tennis", description: "need some hitting practice", peopleGoing: ["Mark", "Amy"], date: "6:00 pm", location: "Fullman Courts")
        events.append(event3)
        let event4 = Event(author: "Boris Yue", sport: "Frisbee", description: "we all suck", peopleGoing: ["Mark", "Amy", "a", "b", "c", "d", "e", "f"], date: "6:43 pm", location: "Memorial Glade")
        events.append(event4)
        let event5 = Event(author: "Boris Yue", sport: "Soccer", description: "everyone is welcome!!!", peopleGoing: ["Mark", "Amy"], date: "8:20 pm", location: "Edwards Stadium")
        events.append(event5)
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height))
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height / 10, right: 0)
        tableView.tableFooterView = UIView() // gets rid of the extra cells beneath
        view.addSubview(tableView)
    }
    
    func rowHeight() -> CGFloat {
        if view.frame.width / 1.8 < 200 {
            return 200
        } else {
            return view.frame.width / 1.8
        }
    }
    
    func createEvent() {
        performSegue(withIdentifier: "toNew", sender: self)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let schoolRef = eventsRef.child(defaults.value(forKey: "school") as! String)
        schoolRef.queryOrdered(byChild: "date").observe(.childAdded, with: { (snapshot) in
            let post = Event(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            self.events.append(post)
            withBlock() //ensures that next block is called
        })
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
        cell.awakeFromNib()
        let currentEvent = events[indexPath.row]
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
        cell.pic.layer.shadowColor = UIColor.black.cgColor
        cell.pic.layer.shadowOpacity = 1
        cell.pic.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.pic.layer.shadowRadius = 1.5
        //        cell.contentView.addSubview(cell.pic)
        cell.sportLabel.text = " is playing " + currentEvent.sport!
        //cell.timeLabel.text = currentEvent.date
        cell.descriptionLabel.text = currentEvent.description
        cell.location = "\(currentEvent.location!) - \(currentEvent.peopleGoing.count) going"
    }
}
