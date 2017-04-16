//
//  CommentViewController.swift
//  Teams
//
//  Created by Amy on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//
import UIKit
import Firebase
struct Comment {
    var author: String!
    var text: String!
}

class CommentViewController: UIViewController {
    var eventsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Event")
    var comments: [String]! = []
    var tableView: UITableView!
    var currKey: String?
    
    var commentsArray: [Comment]! = []
    
    var textField: UITextField!
    var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("commentsVC viewdidload")
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.view.backgroundColor = UIColor.white
        fetchComments {
            self.setUpTableView()
        }
        
        let exitButton = UIButton(frame: CGRect(x: 5, y: 20, width: 25, height: 25))
        exitButton.addTarget(self, action: #selector(exitPressed), for: .touchUpInside)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        view.addSubview(exitButton)
        
        initPostFields()
    }
    
    func exitPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    func setUpTableView() {
        print("setting up table view")
        tableView = UITableView(frame: CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 20 - 40))
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
    }
    
    func fetchComments(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let schoolRef = eventsRef.child(UserDefaults.standard.value(forKey: "school") as! String)
        print("AYyyyyyyy")
        schoolRef.child(currKey!).child("comments").observe(.childAdded, with: { (snapshot) in
            
            var dict = snapshot.value as! [String: Any]
            
            for item in dict {
                print(item)
                self.commentsArray.append(Comment(author: item.key, text: item.value as! String))
            }
            
            print(self.commentsArray)
            
            //self.comments.append(snapshot.value as! String)
            withBlock() //ensures that next block is called
        })
    }
    
    func initPostFields() {
        textField = UITextField(frame: CGRect(x: 5, y: view.frame.maxY - 40, width: view.frame.width - 60, height: 40))
        textField.placeholder = "Post a comment..."
        
        postButton = UIButton(frame: CGRect(x: textField.frame.maxX, y: view.frame.maxY - 40, width: 60, height: 40))
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor.black, for: .normal)
        
        postButton.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        
        view.addSubview(textField)
        view.addSubview(postButton)
    }
    
    func postComment() {
        let schoolRef = eventsRef.child(UserDefaults.standard.value(forKey: "school") as! String).child(currKey!).child("comments")
        print("AYyyyyyyy")
        let key = schoolRef.childByAutoId().key
        
        let newComment = [UserDefaults.standard.string(forKey: "name")!: textField.text] as [String : Any]
        
        let childUpdates = ["/\(key)/": newComment]
        schoolRef.updateChildValues(childUpdates)
    }
}
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentTableViewCell
        
        cell.awakeFromNib()
        
        let currentComment = commentsArray[indexPath.row]
        
        print("current comment: ", currentComment)
        
        //cell.name.text = UserDefaults.standard.string(forKey: "name")
        cell.name.text = currentComment.author
        cell.comment.text = currentComment.text
        cell.name.textColor = UIColor.black
        cell.comment.textColor = UIColor.black
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! CommentTableViewCell
        let currentComment = commentsArray[indexPath.row]
        
        
        //cell.name.text = UserDefaults.standard.string(forKey: "name")
        cell.name.text = currentComment.author
        cell.comment.text = currentComment.text
        cell.name.textColor = UIColor.blue
        cell.comment.textColor = UIColor.black
        cell.name.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        cell.comment.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
