//
//  SettingsViewController.swift
//  Teams
//
//  Created by Boris Yue on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import DropDown
import Firebase

class SettingsViewController: UIViewController {
    
    var settingsTitle: UILabel!
    var doneButton: UIButton!
    var nameLabel: UILabel!
    var nameField: UITextField!
    var schoolLabel: UILabel!
    var schoolButton: UIButton!
    var dropdown: DropDown!
    var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        self.hideKeyboardWhenTappedAround()
        UITextField.appearance().tintColor = UIColor.white //sets cursor to white
        initTitle()
        initSchoolLabel()
        initSchoolButton()
        initDropDown()
        initDoneButton()
    }
    
    func createLoader() {
        loader = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2 + 40, width: 100, height: 100))
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loader.transform = transform
        loader.startAnimating()
        loader.tintColor = UIColor.white
        view.addSubview(loader)
    }
    
    func initTitle() {
        settingsTitle = UILabel(frame: CGRect(x: 0, y: view.frame.width / 4.5, width: 100, height: 40))
        settingsTitle.text = "Settings"
        settingsTitle.font = UIFont(name: "Lato-Bold", size: 40)
        settingsTitle.sizeToFit()
        settingsTitle.frame.origin.x = view.frame.width / 2 - settingsTitle.frame.width / 2
        settingsTitle.textColor = UIColor.white
        view.addSubview(settingsTitle)
    }
    
    func initDoneButton() {
        doneButton = UIButton(frame: CGRect(x: 10, y: 25, width: 25, height: 25))
        doneButton.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        view.addSubview(doneButton)
    }
    
    func initSchoolLabel() {
        schoolLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height / 2 - 60, width: view.frame.width, height: 22))
        schoolLabel.font = UIFont(name: "Lato-Light", size: 16.0)
        schoolLabel.text = "I go to"
        schoolLabel.textAlignment = NSTextAlignment.center
        schoolLabel.textColor = UIColor.white
        view.addSubview(schoolLabel)
    }
    
    func initSchoolButton() {
        schoolButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - (230 / 2), y: schoolLabel.frame.maxY + 10, width: 230, height: 50))
        schoolButton.setTitle(FeedViewController.user.school, for: .normal)
        schoolButton.addTarget(self, action: #selector(schoolPressed), for: UIControlEvents.touchUpInside)
        schoolButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        schoolButton.setTitleColor(UIColor.white, for: .normal)
        schoolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        schoolButton.layer.borderWidth = 2
        schoolButton.layer.borderColor = UIColor.white.cgColor
        schoolButton.layer.cornerRadius = 5
        schoolButton.layer.masksToBounds = true
        view.addSubview(schoolButton)
    }
    
    func initDropDown() {
        dropdown = DropDown()
        dropdown.anchorView = schoolButton
        dropdown.dataSource = ["UC Berkeley", "UCLA", "UC Irvine", "UC Santa Barbara", "UC Riverside", "UC Merced", "UC Davis", "USC", "Stanford"]
        dropdown.bottomOffset = CGPoint(x: 0, y: schoolButton.bounds.height)
        dropdown.direction = .bottom
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.schoolButton.setTitle(item, for: .normal)
        }
        dropdown.width = 230
    }
    
    func schoolPressed() {
        dropdown.show()
    }
    
    func donePressed() {
        createLoader()
        let schoolUpdate = ["school": schoolButton.titleLabel?.text!]
        let userRef = FIRDatabase.database().reference().child("Users").child(FeedViewController.user.id!)
        userRef.updateChildValues(schoolUpdate, withCompletionBlock: { error, ref in
            if FeedViewController.user.school != self.schoolButton.titleLabel?.text! {
                FeedViewController.shouldUpdateFeed = true
                MenuViewController.schoolName = self.schoolButton.titleLabel?.text!
            }
            self.loader.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
            
        })
    }

}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        self.view.endEditing(true)
        return false
    }
}
