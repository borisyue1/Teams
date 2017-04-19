//
//  SettingsViewController.swift
//  Teams
//
//  Created by Boris Yue on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import DropDown

class SettingsViewController: UIViewController {
    
    var settingsTitle: UILabel!
    var doneButton: UIButton!
    var nameLabel: UILabel!
    var nameField: UITextField!
    var schoolLabel: UILabel!
    var schoolButton: UIButton!
    var dropdown: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        self.hideKeyboardWhenTappedAround()
        UITextField.appearance().tintColor = UIColor.white //sets cursor to white
        initTitle()
        initDoneButton()
        initNameLabel()
        initNameField()
        initSchoolLabel()
        initSchoolButton()
        initDropDown()
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
        doneButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 80, width: view.frame.width, height: 80))
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = UIColor(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        doneButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        doneButton.addTarget(self, action: #selector(donePressed), for: UIControlEvents.touchUpInside)
        view.addSubview(doneButton)
    }
    
    func initNameLabel() {
        nameLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height / 3, width: view.frame.width, height: 20))
        nameLabel.text = "My name is"
        nameLabel.font = UIFont(name: "Lato-Light", size: 16.0)
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = NSTextAlignment.center
        view.addSubview(nameLabel)
    }
    
    func initNameField() {
        UITextField.appearance().tintColor = UIColor.white //sets cursor to white
        nameField = UITextField(frame: CGRect(x: self.view.frame.width / 2 - (230 / 2), y: nameLabel.frame.maxY + 10, width: 230, height: 40))
        nameField.delegate = self
        nameField.textColor = UIColor.white
        nameField.font = UIFont(name: "Lato-Medium", size: 20.0)
        nameField.layer.borderColor = UIColor.white.cgColor
        nameField.layer.borderWidth = 2
        nameField.textAlignment = NSTextAlignment.center
        nameField.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.value(forKey: "name") as! String,
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        nameField.returnKeyType = .done
        view.addSubview(nameField)
    }
    
    func initSchoolLabel() {
        schoolLabel = UILabel(frame: CGRect(x: 0, y: nameField.frame.maxY + 30, width: view.frame.width, height: 22))
        schoolLabel.font = UIFont(name: "Lato-Light", size: 16.0)
        schoolLabel.text = "I go to"
        schoolLabel.textAlignment = NSTextAlignment.center
        schoolLabel.textColor = UIColor.white
        view.addSubview(schoolLabel)
    }
    
    func initSchoolButton() {
        schoolButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - (230 / 2), y: schoolLabel.frame.maxY + 10, width: 230, height: 50))
        schoolButton.setTitle(UserDefaults.standard.value(forKey: "school") as? String, for: .normal)
        schoolButton.addTarget(self, action: #selector(schoolPressed), for: UIControlEvents.touchUpInside)
        schoolButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        schoolButton.setTitleColor(UIColor.white, for: .normal)
        schoolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        schoolButton.layer.borderWidth = 2
        schoolButton.layer.borderColor = UIColor.white.cgColor
        view.addSubview(schoolButton)
    }
    
    func initDropDown() {
        dropdown = DropDown()
        dropdown.anchorView = schoolButton
        dropdown.dataSource = ["UC Berkeley", "UCLA", "UC Irvine", "UC Santa Barbara", "UC Riverside", "UC Merced", "UC Davis", "USC", "Stanford"]
        dropdown.bottomOffset = CGPoint(x: 0, y: schoolButton.bounds.height)
        dropdown.direction = .bottom
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            //self.dropdown.show()
            self.schoolButton.setTitle(item, for: .normal)
        }
        dropdown.width = 230
    }
    
    func schoolPressed() {
        dropdown.show()
    }
    
    func donePressed() {
        if nameField.text != "" {
            UserDefaults.standard.set(nameField.text, forKey: "name")
        }
        FeedViewController.shouldUpdateFeed = true
        UserDefaults.standard.set(schoolButton.titleLabel?.text, forKey: "school")
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        self.view.endEditing(true)
        return false
    }
}
