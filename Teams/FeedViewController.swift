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
    var sortedEvents: [Event] = []
    var auth = FIRAuth.auth()
    var eventsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Event")
    var schoolRef: FIRDatabaseReference!
    var plusSign: UIImageView!
    var currKey: String?
    var postIds: [String] = []
    var passedEvent: Event?
    var menuButton: UIBarButtonItem!
    static var shouldUpdateFeed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        MenuViewController.feedTableDelegate = self
        self.title = "All Sports"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated: true) //hide back button
        let originalImage = UIImage(named: "add.png")
        let addButton = UIBarButtonItem(image: originalImage, style: .plain, target: self, action: #selector(createEvent))
        addButton.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(addButton, animated: true)
        fetchPosts {
            self.setUpTableView()
        }        
        setupSideBarButton()
        setUpSideBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FeedViewController.shouldUpdateFeed {
            FeedViewController.shouldUpdateFeed = false
            fetchPosts {
                self.tableView.reloadData()
            }
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
    
    func setUpSideBar() {
        if self.revealViewController() != nil {
            print("revreal not nil")
            revealViewController().rearViewRevealWidth = view.frame.width/4
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().tapGestureRecognizer()
            revealViewController().panGestureRecognizer()
        }
    }
    
    func rowHeight() -> CGFloat {
        return 200
    }
    
    func setupSideBarButton() {
        menuButton = UIBarButtonItem(title: "Sort", style: .plain, target: self.revealViewController(), action: "revealToggle:")
        navigationItem.leftBarButtonItem = menuButton
    }
    
    func createEvent() {
        self.present(NewEventViewController(), animated: true, completion: nil)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!

        sortedEvents.removeAll()
        events.removeAll()
        
        schoolRef = eventsRef.child(UserDefaults.standard.value(forKey: "school") as! String)
        schoolRef.observe(.childAdded, with: { (snapshot) in
            print("queryorderedbychile")
            print(snapshot.key)
            var post = Event(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.short
            post.NSDate = dateFormatter.date(from: post.date!)
            
            self.sortedEvents.append(post)
            self.events.append(post)
            self.postIds.append(snapshot.key)
            print(snapshot.key)
            withBlock() //ensures that next block is called
        })
    }
    
    func sortValues() {
        sortedEvents = sortedEvents.sorted{
            $0.sport! < $1.sport!
        }
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
        return sortedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! FeedTableViewCell
        cell.delegate = self
        let currentEvent = sortedEvents[indexPath.row]
        cell.sport = currentEvent.sport
        cell.author = currentEvent.author
        
        cell.school = UserDefaults.standard.value(forKey: "school") as! String
        
        var dateString: String! = currentEvent.date!
        let split1 = dateString.components(separatedBy: ", ")
        cell.time = split1[2] //get time
        let split2 = split1[0].components(separatedBy: " ")
        cell.month = split2[0] //get month
        cell.day = Int(split2[1]) //get day

        cell.eventDescription = currentEvent.description
        cell.location = currentEvent.location
        let array = UserDefaults.standard.array(forKey: "events") as! [String]
        if !array.contains(currentEvent.id!) {
            cell.buttonIsSelected = false
        } else {
            cell.buttonIsSelected = true

        }
        cell.awakeFromNib()

        cell.tag = indexPath.row
        
        switch currentEvent.sport! {
        case "Soccer":
            cell.pic.image = #imageLiteral(resourceName: "soccer_new")
        case "Football":
            cell.pic.image = #imageLiteral(resourceName: "football_alternate")
        case "Tennis":
            cell.pic.image = #imageLiteral(resourceName: "tennis_new")
        default:
            cell.pic.image = #imageLiteral(resourceName: "basketball")
            
        }
        schoolRef.child("\(currentEvent.id!)").observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let idArray = value?["peopleGoing"] as? [String] ?? []
            DispatchQueue.main.async {
                cell.numGoingLabel.text = "\(idArray.count) going"
                cell.numGoingLabel.sizeToFit()
            }
        })
    }
    
}

extension FeedViewController: FeedCellDelegate {
    
    func addInterestedUser(forCell: FeedTableViewCell, withName: String) {
        sortedEvents[forCell.tag].addInterestedUser(name: withName)
    }
    
    func removeInterestedUser(forCell: FeedTableViewCell, withName: String) {
        sortedEvents[forCell.tag].removeInterestedUser(name: withName)
    }
    
    func goToComments(forCell: FeedTableViewCell) {
        currKey = postIds[forCell.tag]        
        let commentView = CommentViewController()
        commentView.currKey = currKey
        self.present(commentView, animated: true, completion: nil)
    }
}
extension FeedViewController: FeedTableDelegate {
    func reloadFeed(sortedItem: String) {
        if sortedItem == "sport" {
            sortedEvents = sortedEvents.sorted {
                $0.sport! < $1.sport!

            }
            
        } else {
            sortedEvents = sortedEvents.sorted {
                $0.NSDate! < $1.NSDate!
            }
            
        }
        self.tableView.reloadData()

    }
}
