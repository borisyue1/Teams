//
//  FeedViewController.swift
//  Teams
//
//  Created by Boris Yue on 4/4/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    var tableView: UITableView!
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Sports"
//        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: nil)
//        addButton.tintColor = UIColor.white
//        self.navigationItem.setRightBarButton(addButton, animated: true)
        generateRandomEvents()
        setUpTableView()
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
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = view.frame.height / 5
        tableView.separatorStyle = .none
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150 / 2, right: 0)
        tableView.tableFooterView = UIView() // gets rid of the extra cells beneath
        view.addSubview(tableView)
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
        cell.awakeFromNib()
        let currentEvent = events[indexPath.row]
        switch currentEvent.sport! {
        case "Soccer":
            (cell as! FeedTableViewCell).pic.image = #imageLiteral(resourceName: "soccer")
        case "Football":
            (cell as! FeedTableViewCell).pic.image = #imageLiteral(resourceName: "football")
        case "Tennis":
            (cell as! FeedTableViewCell).pic.image = #imageLiteral(resourceName: "tennis")
        default:
            (cell as! FeedTableViewCell).pic.image = #imageLiteral(resourceName: "frisbee")
            
        }
        (cell as! FeedTableViewCell).pic.layer.shadowColor = UIColor.black.cgColor
        (cell as! FeedTableViewCell).pic.layer.shadowOpacity = 1
        (cell as! FeedTableViewCell).pic.layer.shadowOffset = CGSize(width: 0, height: 3)
        (cell as! FeedTableViewCell).pic.layer.shadowRadius = 1.5
//        (cell as! FeedTableViewCell).contentView.addSubview((cell as! FeedTableViewCell).pic)
        (cell as! FeedTableViewCell).sportLabel.text = currentEvent.sport
        (cell as! FeedTableViewCell).timeLabel.text = currentEvent.date
        (cell as! FeedTableViewCell).descriptionLabel.text = currentEvent.description
        (cell as! FeedTableViewCell).locationLabel.text = "\(currentEvent.location!) - \(currentEvent.peopleGoing.count) going"
    }
}
