//
//  CommentViewController.swift
//  Teams
//
//  Created by Amy on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//
import UIKit
import Firebase

class CommentViewController: UIViewController {
    
    var eventRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Event")
    var commentRef: FIRDatabaseReference!
    var tableView: UITableView!
    var currKey: String?
    var commentsArray: [Comment] = []
    var textField: UITextField!
    var postButton: UIButton!
    var exitButton: UIButton!
    var keyboardSize: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentsArray.append(Comment(author: "Sarah Miller", text: "Yo i'm so excited for this!!"))
        self.commentsArray.append(Comment(author: "Joe Biden", text: "Is there still room for more players?"))
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.tintColor = UIColor.black
<<<<<<< HEAD
        self.navigationItem.title = "Comments"
        view.backgroundColor = UIColor.white
        
//        fetchComments {
//            self.setUpTableView()
//        }
        self.setUpTableView()
=======
        view.backgroundColor = UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        self.setupExitButton()
        commentRef = eventRef.child(FeedViewController.user.school).child(currKey!).child("comments")
        fetchComments {
            self.setUpTableView()
        }
>>>>>>> 9f2277b15903815888ca076b4e441e28d7057e7b
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        initPostFields()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardSize = keyboardSize
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func setupExitButton() {
        exitButton = UIButton(frame: CGRect(x: 5, y: 20, width: 25, height: 25))
        exitButton.addTarget(self, action: #selector(exitPressed), for: .touchUpInside)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        view.addSubview(exitButton)
    }
    
    func exitPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpTableView() {
<<<<<<< HEAD
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100))
=======
        tableView = UITableView(frame: CGRect(x: 0, y: exitButton.frame.maxY, width: view.frame.width, height: view.frame.height - exitButton.frame.maxY - exitButton.frame.height - postButton.frame.height))
>>>>>>> 9f2277b15903815888ca076b4e441e28d7057e7b
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none

        view.addSubview(tableView)
    }
    
    func fetchComments(withBlock: @escaping () -> ()) {
<<<<<<< HEAD
        
        self.commentsArray.append(Comment(author: "Sarah Miller", text: "Yo i'm so excited for this!!"))
        self.commentsArray.append(Comment(author: "Joe Biden", text: "Is there still room for more players?"))
        print(commentsArray)
        //TODO: Implement a method to fetch posts with Firebase!
        let schoolRef = eventsRef.child(FeedViewController.user.school)
        
        schoolRef.child(currKey!).child("comments").observe(.childAdded, with: { (snapshot) in
            
            var dict = snapshot.value as! [String: Any]
            
            for item in dict {
                self.commentsArray.append(Comment(author: item.key, text: item.value as! String))
=======
        //TODO: Implement a method to fetch posts with Firebase!        
        commentRef.observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "0" {//no comments
                return
>>>>>>> 9f2277b15903815888ca076b4e441e28d7057e7b
            }
            let comment = Comment(id: snapshot.key, commentDict: snapshot.value as! [String : Any]?)
            self.commentsArray.append(comment)
            withBlock() //ensures that next block is called
        })
    }
    
    func initPostFields() {
        textField = UITextField(frame: CGRect(x: 15, y: view.frame.maxY - 50, width: view.frame.width - 60, height: 40))
        textField.attributedPlaceholder = NSAttributedString(string: "Write a comment...",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        postButton = UIButton(frame: CGRect(x: textField.frame.maxX - 23, y: view.frame.maxY - 50, width: 60, height: 40))
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor(red: 87/255, green: 197/255, blue: 224/255, alpha: 1.0), for: .normal)

        
        postButton.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        
        view.addSubview(textField)
        view.addSubview(postButton)
    }
    
    func postComment() {
        if textField.text == "" {
            self.displayError(withMessage: "Please enter a comment.")
            return
        }
        let key = commentRef.childByAutoId().key
        self.dismissKeyboard()
        let newComment = ["author": FeedViewController.user.id!, "text": textField.text, "imageUrl": FeedViewController.user.imageUrl] as [String : Any]
        let childUpdates = ["/\(key)/": newComment]
<<<<<<< HEAD
        schoolRef.updateChildValues(childUpdates)
        textField.text = "Write a comment..."
        textField.textColor = UIColor.black
=======
        commentRef.updateChildValues(childUpdates)
        textField.text = ""
        textField.textColor = UIColor.lightGray
>>>>>>> 9f2277b15903815888ca076b4e441e28d7057e7b
    }
}
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentTableViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        
        let currentComment = commentsArray[indexPath.row]
        
        cell.name.text = "Sarah Miller"
        cell.name.textColor = UIColor.black
        cell.comment.text = "Is there still space for me??"
        cell.comment.textColor = UIColor.black
        cell.pic.image? = UIImage(named: "anon.png")!
        if (indexPath.row % 2 == 1) {
            cell.backgroundColor = UIColor(red: 168/255, green: 213/255, blue: 224/255, alpha: 1.0)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
