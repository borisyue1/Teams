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
    let labelIcon: [UIImage] = [#imageLiteral(resourceName: "sport"), #imageLiteral(resourceName: "date")]
    var appLabel: UILabel!
    var settingsButton: UIButton!
    static var feedTableDelegate: FeedTableDelegate?
    var indexSelected: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView(){
        //Initialize TableView Object here
        tableView = UITableView(frame: CGRect(x: 0, y: appLabel.frame.maxY + 30, width: view.frame.width * (2/5), height: 100))
        
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
        MenuViewController.feedTableDelegate?.reloadFeed(sortedItem: sortedItem)
    }
    
    func setupUI() {
        appLabel = UILabel(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY, width: view.frame.width * (2/5), height: 50))
        appLabel.text = "Sportify"
        appLabel.textAlignment = .center
        appLabel.textColor = UIColor.white
        appLabel.backgroundColor = UIColor(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        
        settingsButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 50, width: view.frame.width * (2/5), height: 50))
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.titleLabel?.textAlignment = .center
        settingsButton.setTitleColor(UIColor.white, for: .normal)
        settingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        settingsButton.backgroundColor = UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        
        view.addSubview(appLabel)
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
        cell.selectionStyle = .none
        
        cell.nameLabel.text = labels[indexPath.row]
        cell.labelIcon.image = labelIcon[indexPath.row]
        
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
            tableView.cellForRow(at: indexSelected)?.contentView.backgroundColor = UIColor.white
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        indexSelected = indexPath
        reloadTableFeed(sortedItem: sortedItem)
    }
    
}
