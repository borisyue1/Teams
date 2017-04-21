//
//  MenuViewController.swift
//  Teams
//
//  Created by Shireen Warrier on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

//protocol FeedTableDelegate {
//    func reloadFeed(sortedItem: String)
//}

class MenuViewController: UIViewController {
    let labelIcon: [UIImage] = [#imageLiteral(resourceName: "sport"), #imageLiteral(resourceName: "date")]
    var appLabel: UILabel!
    var settingsButton: UIButton!
    var profilePic: UIImageView!
    var nameLabel: UILabel!
    var schoolLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        appLabel = UILabel(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY, width: view.frame.width * (2/5), height: 50))
        appLabel.text = "Sportify"
        appLabel.textAlignment = .center
        appLabel.textColor = UIColor.white
        appLabel.layer.cornerRadius = 3.0
        appLabel.backgroundColor = UIColor(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        
        profilePic = UIImageView(frame: CGRect(x: view.frame.width * (1/10), y: appLabel.frame.maxY + 20, width: view.frame.width * (1/5), height: view.frame.width * (1/5)))
        profilePic.image = #imageLiteral(resourceName: "profile")
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: profilePic.frame.maxY, width: view.frame.width * (2/5), height: 30))
        nameLabel.textColor = UIColor(red: 76/255, green: 136/255, blue: 255/255, alpha: 1.0)
        nameLabel.textAlignment = .center
        nameLabel.text = UserDefaults.standard.value(forKey: "name") as! String
        
        schoolLabel = UILabel(frame: CGRect(x: 0, y: nameLabel.frame.maxY, width: view.frame.width * (2/5), height: 30))
        schoolLabel.textColor = UIColor.lightGray
        schoolLabel.textAlignment = .center
        schoolLabel.text = UserDefaults.standard.value(forKey: "school") as! String
        
        settingsButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 50, width: view.frame.width * (2/5), height: 50))
        settingsButton.setTitle("Update Profile", for: .normal)
        settingsButton.titleLabel?.textAlignment = .center
        settingsButton.layer.cornerRadius = 3.0
        settingsButton.setTitleColor(UIColor.white, for: .normal)
        settingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        settingsButton.backgroundColor = UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        
        view.addSubview(appLabel)
        view.addSubview(profilePic)
        view.addSubview(nameLabel)
        view.addSubview(schoolLabel)
        view.addSubview(settingsButton)
    }
    
    func goToSettings() {
        present(SettingsViewController(), animated: true, completion: nil)
    }
}

