//
//  LoginViewController.swift
//  Teams
//
//  Created by Mark Siano on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var school: String?
    var nameLabel: UILabel!
    var nameField: UITextField!
    var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        initNameField()
        initNameLabel()
        initLoginButton()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func initNameField() {
        UITextField.appearance().tintColor = UIColor.white //sets cursor to white 
        nameField = UITextField(frame: CGRect(x: 10, y: view.frame.height / 2 - 40, width: view.frame.width - 20, height: 40))
        nameField.textColor = UIColor.white
        nameField.font = UIFont(name: "Lato-Medium", size: 20.0)
        nameField.layer.borderColor = UIColor.white.cgColor
        nameField.layer.borderWidth = 2
        nameField.textAlignment = NSTextAlignment.center
        nameField.attributedPlaceholder = NSAttributedString(string: "Your Name",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        view.addSubview(nameField)
    }
    
    func initNameLabel() {
        nameLabel = UILabel(frame: CGRect(x: 0, y: nameField.frame.minY - 30, width: view.frame.width, height: 20))
        
        nameLabel.text = "My name is"
        nameLabel.font = UIFont(name: "Lato-Light", size: 16.0)
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = NSTextAlignment.center
        view.addSubview(nameLabel)
    }
    
    func initLoginButton() {
        loginButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 80, width: view.frame.width, height: 80))
        loginButton.setTitle("Get started!", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 22.0)
        loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        loginButton.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        
        loginButton.addTarget(self, action: #selector(loginPressed), for: UIControlEvents.touchUpInside)
        
        view.addSubview(loginButton)
    }
    
    func loginPressed() {
        if nameField.text != "" {
            UserDefaults.standard.set(nameField.text, forKey: "name")
            performSegue(withIdentifier: "toOptionView", sender: self)
        } else {
            self.displayError(withMessage: "Please input your name.")
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOptionView" {
            let optionVC = segue.destination as! OptionViewController
            optionVC.school = self.school
            optionVC.name = self.nameField.text
        }
    }

}
