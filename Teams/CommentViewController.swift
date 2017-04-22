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
        initPostFields()

        self.automaticallyAdjustsScrollViewInsets = false
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.title = "Comments"
        view.backgroundColor = UIColor.white
        commentRef = eventRef.child(FeedViewController.user.school).child(currKey!).child("comments")
        fetchComments {
            self.setUpTableView()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
    
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height - 200))
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none

        view.addSubview(tableView)
    }
    
    func fetchComments(withBlock: @escaping () -> ()) {
        commentRef.observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "0" {//no comments
                return
            }
            let comment = Comment(id: snapshot.key, commentDict: snapshot.value as! [String : Any]?)
            self.commentsArray.append(comment)
            withBlock() //ensures that next block is called
        })
    }
    
    func initPostFields() {
        textField = UITextField(frame: CGRect(x: 15, y: view.frame.maxY - 45, width: view.frame.width - 60, height: 40))
        textField.attributedPlaceholder = NSAttributedString(string: "Write a comment...",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        postButton = UIButton(frame: CGRect(x: textField.frame.maxX - 23, y: view.frame.maxY - 45, width: 60, height: 40))
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
        let newComment = ["author": FeedViewController.user.name!, "text": textField.text, "imageUrl": FeedViewController.user.imageUrl] as [String : Any]
        let childUpdates = ["/\(key)/": newComment]
        commentRef.updateChildValues(childUpdates)
        textField.text = ""
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
        
        cell.name.text = currentComment.author
        cell.name.textColor = UIColor.black
        cell.comment.text = currentComment.text
        cell.comment.textColor = UIColor.black
        User.getImage(atPath: currentComment.imageUrl, withBlock: { image in
            DispatchQueue.main.async {
                cell.pic.image? = image
            }
        })
        cell.layer.cornerRadius = 15.0
        cell.frame.size.width = 500
        if (indexPath.row % 2 == 1) {
            cell.backgroundColor = UIColor(red: 168/255, green: 213/255, blue: 224/255, alpha: 1.0)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
