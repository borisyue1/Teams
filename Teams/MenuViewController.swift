//
//  MenuViewController.swift
//  Teams
//
//  Created by Shireen Warrier on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase
import MarqueeLabel

class MenuViewController: UIViewController {
    let labelIcon: [UIImage] = [#imageLiteral(resourceName: "sport"), #imageLiteral(resourceName: "date")]
    var appLabel: UILabel!
    var settingsButton: UIButton!
    var profilePic: UIImageView!
    var nameLabel: UILabel!
    var schoolLabel: UILabel!
    var user: User!
    var userImage: UIImage!
    var logoutButton: UIButton!
    static var schoolName: String!
    var shouldChangeName = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = FeedViewController.user {
            self.setupUI()
            self.user = user
            User.getImage(atPath: user.imageUrl, withBlock: { image in
                self.profilePic.image = image
            })
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let user = FeedViewController.user {
            self.user = user
            User.getImage(atPath: user.imageUrl, withBlock: { image in
                self.profilePic.image = image
            })
            nameLabel.text = user.name
            schoolLabel.text = user.school
        }
        if let school = MenuViewController.schoolName {
            schoolLabel.text = school
        }
    }
    
    func setupUI() {
        appLabel = UILabel(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY, width: view.frame.width * (2/5), height: 50))
        appLabel.text = "Sportify"
        appLabel.font = UIFont(name: "Lato-Medium", size: 22)
        appLabel.textAlignment = .center
        appLabel.textColor = UIColor.white
        appLabel.layer.cornerRadius = 3.0
        appLabel.backgroundColor = UIColor(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        
        profilePic = UIImageView(frame: CGRect(x: view.frame.width * (1/10), y: appLabel.frame.maxY + 20, width: view.frame.width * (1/5), height: view.frame.width * (1/5)))
        profilePic.layer.cornerRadius = profilePic.frame.width  / 2
        profilePic.layer.masksToBounds = true
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: profilePic.frame.maxY + 10, width: view.frame.width * (2/5), height: 30))
        nameLabel.textColor = UIColor(red: 76/255, green: 136/255, blue: 255/255, alpha: 1.0)
        nameLabel.font = UIFont(name: "Lato-Light", size: 20)
        nameLabel.textAlignment = .center
        
        schoolLabel = MarqueeLabel(frame: CGRect(x: 0, y: nameLabel.frame.maxY, width: view.frame.width * (2/5), height: 30), rate: 20, fadeLength: 10)
        schoolLabel.font = UIFont(name: "Lato-Light", size: 20)
        schoolLabel.textColor = UIColor.lightGray
        schoolLabel.textAlignment = .center
        
        settingsButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 100, width: view.frame.width * (2/5), height: 50))
        settingsButton.setTitle("Update Profile", for: .normal)
        settingsButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 17)
        settingsButton.titleLabel?.textAlignment = .center
        settingsButton.setTitleColor(UIColor.white, for: .normal)
        settingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        settingsButton.backgroundColor = UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        
        logoutButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 50, width: view.frame.width * (2/5), height: 50))
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 17)
        logoutButton.titleLabel?.textAlignment = .center
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        logoutButton.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        
        if let user = FeedViewController.user {
            nameLabel.text = user.name
            schoolLabel.text = user.school
        } else {
            profilePic.image = #imageLiteral(resourceName: "profile")
            nameLabel.text = "N/A"
            schoolLabel.text = "Hasn't loaded yet, please try reopening."
        }
        
        view.addSubview(appLabel)
        view.addSubview(profilePic)
        view.addSubview(nameLabel)
        view.addSubview(schoolLabel)
        view.addSubview(settingsButton)
        view.addSubview(logoutButton)
    }
    
    func goToSettings() {
        present(SettingsViewController(), animated: true, completion: nil)
    }
    
    func logOut() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

