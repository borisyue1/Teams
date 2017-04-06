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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        
        initButtons()

        // Do any additional setup after loading the view.
    }
    
    func initButtons() {
        createTeam = UIButton(frame: CGRect(x: view.frame.width / 2 - (230 / 2), y: view.frame.height / 2 - 55, width: 230, height: 50))
        joinTeam = UIButton(frame: CGRect(x: view.frame.width / 2 - (230 / 2), y: view.frame.height / 2 + 5, width: 230, height: 50))
        
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
        self.navigationController?.pushViewController(NewEventViewController(), animated: true)
    }
    
    func joinTeamPressed() {
        self.navigationController?.pushViewController(FeedViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
