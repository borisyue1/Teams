//
//  ViewController.swift
//  Teams
//
//  Created by Boris Yue on 3/18/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let feed = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        feed.setTitle("To Feed", for: .normal)
        feed.setTitleColor(UIColor.black, for: .normal)
        feed.addTarget(self, action: #selector(toFeed), for: .touchUpInside)
        view.addSubview(feed)
    }
    
    func toFeed() {
        self.navigationController?.pushViewController(FeedViewController(), animated: true)
    }
    
}
