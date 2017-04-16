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
            self.navigationController?.pushViewController(FeedViewController(), animated: true)
            OptionViewController.shouldGoToFeed = false
        }
    }
    
    func initButtons() {
        createTeam = UIButton(frame: CGRect(x: view.frame.width / 2 - (230 / 2), y: view.frame.height / 2 - 70, width: 230, height: 50))
        joinTeam = UIButton(frame: CGRect(x: view.frame.width / 2 - (230 / 2), y: view.frame.height / 2 - 10, width: 230, height: 50))
        
        createTeam.setTitle("Create a Team", for: .normal)
        createTeam.addTarget(self, action: #selector(createTeamPressed), for: UIControlEvents.touchUpInside)
        
        createTeam.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        
        createTeam.setTitleColor(UIColor.white, for: .normal)
        createTeam.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        createTeam.layer.borderWidth = 3.0
        createTeam.layer.borderColor = UIColor.white.cgColor
        
        
        
        joinTeam.setTitle("Join a Team", for: .normal)
        joinTeam.addTarget(self, action: #selector(joinTeamPressed), for: UIControlEvents.touchUpInside)
        
        joinTeam.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        
        joinTeam.setTitleColor(UIColor.white, for: .normal)
        joinTeam.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        joinTeam.layer.borderWidth = 3.0
        joinTeam.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(createTeam)
        view.addSubview(joinTeam)
    }
    
    func createTeamPressed() {
//        performSegue(withIdentifier: "toNew", sender: self)
        createTeam.backgroundColor = UIColor.white
        createTeam.setTitleColor(UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0), for: .normal)
        self.present(NewEventViewController(), animated: true, completion: nil)
    }
    
    func joinTeamPressed() {
//        performSegue(withIdentifier: "toFeedView", sender: self)
        joinTeam.backgroundColor = UIColor.white
        joinTeam.setTitleColor(UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0), for: .normal)
//        self.navigationController?.pushViewController(FeedViewController(), animated: true)

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let rVC = storyboard.instantiateViewController(withIdentifier: "FrontVC")
//        print(revealViewController())
//        revealViewController().setFront(rVC, animated: true)
    
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: "FrontVC")
        
        revealViewController().setFront(controller, animated: true)
    }

}
