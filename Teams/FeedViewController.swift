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
    let labels: [String] = ["Sport", "Date"]
    var currKey: String?
    var postIds: [String] = []
    var passedEvent: Event?
    var menuButton: UIBarButtonItem!
    var commentsSize: Int!
    var segControl: UISegmentedControl!
    static var shouldUpdateFeed = false
    var eventCache: [String: Int] = [:]//caches numGoing
    static var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated: true) //hide back button
        let originalImage = UIImage(named: "add.png")
        let addButton = UIBarButtonItem(image: originalImage, style: .plain, target: self, action: #selector(createEvent))
        addButton.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(addButton, animated: true)
        User.fetchUser(withBlock: { user in
            FeedViewController.user = user
            self.fetchPosts {
                self.setUpTableView()
            }
        })
        setupSideBarButton()
        setUpSideBar()
        setupSegControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FeedViewController.shouldUpdateFeed {
            FeedViewController.shouldUpdateFeed = false
            User.fetchUser(withBlock: { user in
                FeedViewController.user = user
                self.fetchPosts {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func setUpTableView() {
//        self.loader.removeFromSuperview()
        tableView = UITableView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height))
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height / 10, right: 0)
        tableView.tableFooterView = UIView() // gets rid of the extra cells beneath
        tableView.allowsSelection = false
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
    }
    
    func setUpSideBar() {
        if self.revealViewController() != nil {
            print("reveal not nil")
            revealViewController().rearViewRevealWidth = view.frame.width * (2/5)
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().tapGestureRecognizer()
            revealViewController().panGestureRecognizer()
        }
    }
    
  
    
    func setupSegControl() {
        segControl = UISegmentedControl(items: labels)
        segControl.selectedSegmentIndex = 0
        segControl.tintColor = UIColor(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        segControl.backgroundColor = UIColor.white
        segControl.layer.cornerRadius = 5.0
        segControl.sizeToFit()
        self.navigationItem.titleView = segControl
        segControl.addTarget(self, action: #selector(changeSort), for: .valueChanged)
    }
    
    func changeSort(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sortedEvents = sortedEvents.sorted {
                $0.sport! < $1.sport!
            }
            self.tableView.reloadData()
        case 1:
            sortedEvents = sortedEvents.sorted {
                $0.NSDate! < $1.NSDate!
            }
            self.tableView.reloadData()
        default:
            print("hi")
        }
    }
    
    func setupSideBarButton() {
//        menuButton = UIBarButtonItem(title: "Sort", style: .plain, target: self.revealViewController(), action: "revealToggle:")
        menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        menuButton.tintColor = UIColor.gray
        navigationItem.leftBarButtonItem = menuButton
    }
    
    func createEvent() {
        self.present(NewEventViewController(), animated: true, completion: nil)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        sortedEvents.removeAll()
        events.removeAll()
        schoolRef = eventsRef.child(FeedViewController.user.school)
        schoolRef.observe(.childAdded, with: { (snapshot) in
//            print("queryorderedbychild")
            var post = Event(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.short
            post.NSDate = dateFormatter.date(from: post.date!)
            
            self.sortedEvents.append(post)
            self.events.append(post)
            self.postIds.append(snapshot.key)
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
        
        cell.school = FeedViewController.user.school
        
        let dateString: String! = currentEvent.date!
        let split1 = dateString.components(separatedBy: ", ")
        cell.time = split1[2] //get time
        let split2 = split1[0].components(separatedBy: " ")
        cell.month = split2[0] //get month
        cell.day = Int(split2[1]) //get day

        cell.eventDescription = currentEvent.description      
        cell.location = currentEvent.location
        let array = currentEvent.peopleGoing
        if !array.contains(FeedViewController.user.id!) {
            print("hi")
            cell.buttonIsSelected = false
        } else {
            print("hello")
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
        case "Volleyball":
            cell.pic.image = #imageLiteral(resourceName: "volleyball")
        case "Ultimate Frisbee":
            cell.pic.image = #imageLiteral(resourceName: "frisbee")
        case "Spikeball":
            cell.pic.image = #imageLiteral(resourceName: "spikeball")
        default:
            cell.pic.image = #imageLiteral(resourceName: "basketball")
            
        }

        if let numGoing = eventCache[currentEvent.id!] {
            cell.numGoingLabel.text = "\(numGoing) going"
            cell.numGoingLabel.sizeToFit()
        } else {
            schoolRef.child("\(currentEvent.id!)").observe(.value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let idArray = value?["peopleGoing"] as? [String] ?? []
                DispatchQueue.main.async {
                    cell.numGoingLabel.text = "\(idArray.count) going"
                    cell.numGoingLabel.sizeToFit()
                    self.eventCache[currentEvent.id!] = idArray.count
                }
            })
        }
    }
    
}

extension FeedViewController: FeedCellDelegate {
    
    func addInterestedUser(forCell: FeedTableViewCell, withId: String, user: User) {
        sortedEvents[forCell.tag].addInterestedUser(id: withId, user: user)
    }
    
    func removeInterestedUser(forCell: FeedTableViewCell, withId: String, user: User) {
        sortedEvents[forCell.tag].removeInterestedUser(id: withId, user: user)
    }
    
    func goToComments(forCell: FeedTableViewCell) {
        currKey = postIds[forCell.tag]        
        let commentView = CommentViewController()
        commentView.currKey = currKey
        self.present(commentView, animated: true, completion: nil)
    }
}

