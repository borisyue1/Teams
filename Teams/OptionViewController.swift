//
//  OptionViewController.swift
//  Teams
//
//  Created by Mark Siano on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {
    
    var createTeam: UIButton!
    var joinTeam: UIButton!
    var school: String?
    var name: String?
    static var shouldGoToFeed = false
    var loader: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        initButtons()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createTeam.backgroundColor = UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        createTeam.setTitleColor(UIColor.white, for: .normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if OptionViewController.shouldGoToFeed {
            self.dismiss(animated: true, completion: nil)
            OptionViewController.shouldGoToFeed = false
            LoginViewController.shouldSegue = true
        }
    }
    
    func createLoader() {
        loader = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2 + 100, width: 100, height: 100))
        let transform = CGAffineTransform(scaleX: 2, y: 2)
        loader.transform = transform
        loader.startAnimating()
        loader.tintColor = UIColor.white
        view.addSubview(loader)
    }
    
    func initButtons() {
        createTeam = UIButton(frame: CGRect(x: view.frame.width / 2 - (230 / 2), y: view.frame.height / 2 - 70, width: 230, height: 50))
        joinTeam = UIButton(frame: CGRect(x: view.frame.width / 2 - (230 / 2), y: view.frame.height / 2 - 10, width: 230, height: 50))
        
        createTeam.setTitle("Create a Game", for: .normal)
        createTeam.addTarget(self, action: #selector(createTeamPressed), for: UIControlEvents.touchUpInside)
        
        createTeam.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        
        createTeam.setTitleColor(UIColor.white, for: .normal)
        createTeam.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        createTeam.layer.borderWidth = 3.0
        createTeam.layer.cornerRadius = 5
        createTeam.layer.masksToBounds = true
        createTeam.layer.borderColor = UIColor.white.cgColor
        
        
        
        joinTeam.setTitle("Join a Game", for: .normal)
        joinTeam.addTarget(self, action: #selector(joinTeamPressed), for: UIControlEvents.touchUpInside)
        
        joinTeam.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        
        joinTeam.setTitleColor(UIColor.white, for: .normal)
        joinTeam.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        joinTeam.layer.borderWidth = 3.0
        joinTeam.layer.cornerRadius = 5
        joinTeam.layer.masksToBounds = true
        joinTeam.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(createTeam)
        view.addSubview(joinTeam)
    }
    
    func createTeamPressed() {
        createTeam.backgroundColor = UIColor.white
        createTeam.setTitleColor(UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0), for: .normal)
        createLoader()
        User.fetchUser(withBlock: { user in
            self.loader.removeFromSuperview()
            let newEvent = NewEventViewController()
            newEvent.user = user
            self.present(newEvent, animated: true, completion: nil)
        })
    }
    
    func joinTeamPressed() {
        joinTeam.backgroundColor = UIColor.white
        joinTeam.setTitleColor(UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0), for: .normal)
        
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let controller = sb.instantiateViewController(withIdentifier: "FrontVC")
//        self.show(controller, sender: nil)
        LoginViewController.shouldSegue = true
        self.dismiss(animated: true, completion: nil)
    }

}
