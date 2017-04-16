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
    var eventsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Event")
    var comments: [String]!
    var tableView: UITableView!
    var currKey: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
       /* fetchComments {
            self.setUpTableView()
        }*/
        
    }
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - 50))
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        view.addSubview(tableView)
    }
    
    func fetchComments(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let schoolRef = eventsRef.child(UserDefaults.standard.value(forKey: "school") as! String)
        schoolRef.child("comments").observe(.childAdded, with: { (snapshot) in
            self.comments = snapshot.value as! [String]!
            withBlock() //ensures that next block is called
        })
    }
    


}
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return comments.count
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! CommentTableViewCell
        cell.awakeFromNib()
       /* let currentComment = comments[indexPath.row]
        cell.name.text = UserDefaults.standard.string(forKey: "name")
        cell.comment.text = currentComment */
    }
    
    
}
