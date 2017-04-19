//
//  MenuViewController.swift
//  Teams
//
//  Created by Shireen Warrier on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

protocol FeedTableDelegate {
    func reloadFeed(sortedItem: String)
}

class MenuViewController: UIViewController {
    var tableView: UITableView!
    let labels: [String] = ["Sport", "Date"]
    var settingsButton: UIButton!
    static var feedTableDelegate: FeedTableDelegate?
    var indexSelected: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSettings()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView(){
        //Initialize TableView Object here
        tableView = UITableView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY, width: view.frame.width/4, height: 100))
        
        //Register the tableViewCell you are using
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuCell")
        
        //Set properties of TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50/2, right: 0)
        
        //Add tableView to view
        view.addSubview(tableView)
    }

    func reloadTableFeed(sortedItem: String) {
        print("reloadTableFeed")
        MenuViewController.feedTableDelegate?.reloadFeed(sortedItem: sortedItem)
    }
    
    func setupSettings() {
        settingsButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 30, width: view.frame.width/4, height: 30))
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(UIColor.black, for: .normal)
        settingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        
        view.addSubview(settingsButton)
    }
    
    func goToSettings() {
        present(SettingsViewController(), animated: true, completion: nil)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        
        cell.nameLabel.text = labels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sortedItem: String = ""

        switch indexPath.row {
        case 0:
            sortedItem = "sport"
        case 1:
            sortedItem = "date"
        default:
            print("hi")
        }
        if indexSelected != nil {
            tableView.cellForRow(at: indexSelected)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        indexSelected = indexPath
        reloadTableFeed(sortedItem: sortedItem)
    }
    
}
