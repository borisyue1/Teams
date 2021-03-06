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
    
    var loader: UIActivityIndicatorView!
    var empty: UILabel!
    var tableView: UITableView!
    var events: [Event] = []
    var sortedEvents: [Event] = []
    var myEvents: [String] = []
    var auth = FIRAuth.auth()
    var eventsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Event")
    var schoolRef: FIRDatabaseReference!
    var plusSign: UIImageView!
    let labels: [String] = ["Sport", "Date", "My Games"]
    var currKey: String?
    var postIds: [String] = []
    var passedEvent: Event?
    var menuButton: UIBarButtonItem!
    var commentsSize: Int!
    var segControl: UISegmentedControl!
    static var shouldUpdateFeed = false
    var eventCache: [String: Int] = [:]//caches numGoing
    var commentCache: [String: Int] = [:]//caches comments count
    static var user: User!
    var canCreateNew = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLoader()
        self.view.backgroundColor = UIColor(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated: true) //hide back button
        let originalImage = UIImage(named: "add.png")
        let addButton = UIBarButtonItem(image: originalImage, style: .plain, target: self, action: #selector(createEvent))
        addButton.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(addButton, animated: true)
        User.fetchUser(withBlock: { user in
            FeedViewController.user = user
            self.canCreateNew = true
            self.fetchPosts {
                self.myEvents = FeedViewController.user.eventsJoined
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
                self.postIds = []
                FeedViewController.user = user
                self.fetchPosts {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func createLoader() {
        loader = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2 - 50, width: 100, height: 100))
        let transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loader.transform = transform
        loader.startAnimating()
        loader.tintColor = UIColor.white
        view.addSubview(loader)
    }
    
    func setUpTableView() {
        if let empty = empty {
            empty.removeFromSuperview() //remove empty label if posts exist
        }
        loader.removeFromSuperview()
        if let _ = navigationController {
            tableView = UITableView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height))
            tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 200
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height / 10, right: 0)
            tableView.tableFooterView = UIView() // gets rid of the extra cells beneath
            tableView.allowsSelection = false
            tableView.backgroundColor = UIColor(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
            self.automaticallyAdjustsScrollViewInsets = false
            view.addSubview(tableView)
        }
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
            sortedEvents = events
            sortedEvents = sortedEvents.sorted {
                $0.sport! < $1.sport!
            }
            self.tableView.reloadData()
        case 1:
            sortedEvents = events
            sortedEvents = sortedEvents.sorted {
                $0.NSDate! < $1.NSDate!
            }
            self.tableView.reloadData()
        case 2:
            self.myEvents = FeedViewController.user.eventsJoined
            sortedEvents = sortedEvents.filter {
                myEvents.contains($0.id!)
            }
            self.tableView.reloadData()
        default:
            print("hi")
        }
    }
    
    func setupSideBarButton() {
        if self.revealViewController() != nil {
            
        }
        menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        menuButton.tintColor = UIColor.gray
        navigationItem.leftBarButtonItem = menuButton
    }
    
    func createEvent() {
        if canCreateNew {
             self.present(NewEventViewController(), animated: true, completion: nil)
        }
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        sortedEvents.removeAll()
        events.removeAll()
        schoolRef = eventsRef.child(FeedViewController.user.school)
        schoolRef.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                self.setUpEmptyLabel()
                return
            }
        })
        schoolRef.observe(.childAdded, with: { (snapshot) in
            let post = Event(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
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
    
    func setUpEmptyLabel() {
        loader.removeFromSuperview()
        empty = UILabel(frame: CGRect(x: 50, y: view.frame.height / 2 - 40, width: view.frame.width - 100, height: 100))
        empty.text = "No games to show. Create one!"
        empty.textColor = UIColor.white
        empty.font = UIFont(name: "Lato-Medium", size: 30)
//        empty.frame.origin.x = view.frame.width / 2 - view.frame.width / 2
        empty.lineBreakMode = .byWordWrapping
        empty.numberOfLines = 0
        empty.textAlignment = .center
        view.addSubview(empty)
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedTableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview() //remove previous subviews in cell
        }
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
            cell.buttonIsSelected = false
        } else {
            cell.buttonIsSelected = true
        }
        cell.awakeFromNib()

        cell.tag = indexPath.row
        
        cell.contentView.backgroundColor = UIColor(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        switch currentEvent.sport! {
        case "Soccer":
            cell.pic.image = #imageLiteral(resourceName: "soccer-icon")
        case "Football":
            cell.pic.image = #imageLiteral(resourceName: "football-icon")
        case "Tennis":
            cell.pic.image = #imageLiteral(resourceName: "tennis-icon")
        case "Volleyball":
            cell.pic.image = #imageLiteral(resourceName: "volleyball-icon")
        case "Ultimate Frisbee":
            cell.pic.image = #imageLiteral(resourceName: "frisbee-icon")
        case "Spikeball":
            cell.pic.image = #imageLiteral(resourceName: "spikeball-icon")
        default:
            cell.pic.image = #imageLiteral(resourceName: "basketball-icon")            
        }

            schoolRef.child("\(currentEvent.id!)").observe(.value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let idArray = value?["peopleGoing"] as? [String] ?? []
                let commentArray = value?["comments"] as? [String: Any] ?? [:]
                let numComments = commentArray.count
                DispatchQueue.main.async {
                    cell.numGoingButton.setTitle("\(idArray.count) going", for: .normal)
                    if (numComments == 0) {
                        cell.commentButton.setTitle("Write Comment", for: .normal)
                    } else if (numComments == 1) {
                        cell.commentButton.setTitle("\(numComments) comment", for: .normal)
                    } else {
                        cell.commentButton.setTitle("\(numComments) comments", for: .normal)
                    }
                    self.eventCache[currentEvent.id!] = idArray.count
                    self.commentCache[currentEvent.id!] = commentArray.count
                }
            })
//        }
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
        currKey = sortedEvents[forCell.tag].id
        let commentView = CommentViewController()
        commentView.currKey = currKey
        navigationController?.pushViewController(commentView, animated: true)
    }
    
    func goToPeopleGoing(forCell: FeedTableViewCell) {
        currKey = sortedEvents[forCell.tag].id
        let goingView = PeopleGoingViewController()
        goingView.currKey = currKey
        navigationController?.pushViewController(goingView, animated: true)
    }
}

