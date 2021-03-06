//
//  SelectSchoolViewController.swift
//  Teams
//
//  Created by Mark Siano on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//
import UIKit
import DropDown
import Firebase

class SelectSchoolViewController: UIViewController {
    
    var dropdown: DropDown!
    var selectLabel: UILabel!
    var nextButton: UIButton!
    var button: UIButton!
    var buttonTapped = false
    var userRef = FIRDatabase.database().reference().child("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton()
        initLabel()
        initDropDown()
        initNextButton()
        
        self.view.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if buttonTapped {
            nextButton.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
            nextButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func initLabel() {
        selectLabel = UILabel(frame: CGRect(x: 0, y: self.button.frame.minY - 32, width: view.frame.width, height: 22))
        selectLabel.font = UIFont(name: "Lato-Light", size: 18.0)
        selectLabel.text = "I go to"
        selectLabel.textAlignment = NSTextAlignment.center
        selectLabel.textColor = UIColor.white
        
        view.addSubview(selectLabel)
    }
    
    func initButton() {
        button = UIButton(frame: CGRect(x: self.view.frame.width / 2 - (230 / 2), y: view.frame.height / 2 - 25, width: 230, height: 50))
        button.setTitle("Select School", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        view.addSubview(button)
    }
    
    func initNextButton() {
        nextButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 80, width: view.frame.width, height: 80))
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        nextButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        
        nextButton.addTarget(self, action: #selector(nextPressed), for: UIControlEvents.touchUpInside)
        view.addSubview(nextButton)
    }
    
    func buttonPressed() {
        self.dropdown.show()
    }
    
    func initDropDown() {
        dropdown = DropDown()
        dropdown.anchorView = button
        dropdown.dataSource = ["UC Berkeley", "UCLA", "UC Irvine", "UC Santa Barbara", "UC Riverside", "UC Merced", "UC Davis", "USC", "Stanford"]
        dropdown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        dropdown.direction = .bottom
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.button.setTitle(item, for: .normal)
        }
        dropdown.width = 230
        
    }
    
    func nextPressed() {
        if button.titleLabel!.text != "" {
            let setSchool = ["\((FIRAuth.auth()?.currentUser?.uid)!)/school": button.titleLabel!.text]
            userRef.updateChildValues(setSchool)
            self.performSegue(withIdentifier: "toOptionView", sender: self)
            nextButton.backgroundColor = UIColor.white
            nextButton.setTitleColor(UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0), for: .normal)
            buttonTapped = true
        } else {
            self.displayError(withMessage: "Please select a school first.")
        }
    }
    
    
}
