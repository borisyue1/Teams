//
//  LoginViewController.swift
//  Teams
//
//  Created by Mark Siano on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var school: String?
    var nameLabel: UILabel!
    var nameField: UITextField!
    var loginButton: UIButton!
    var buttonPressed = false
    var userRef = FIRDatabase.database().reference().child("Users")

    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser != nil {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "FrontVC")
            self.revealViewController().setFront(controller, animated: true)
        }
        view.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
//        initNameField()
//        initNameLabel()
        initLoginButton()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if buttonPressed {
            loginButton.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
            loginButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginPressed()
        return true
    }
    
    func initNameField() {
        UITextField.appearance().tintColor = UIColor.white //sets cursor to white 
        nameField = UITextField(frame: CGRect(x: 10, y: view.frame.height / 2 - 40, width: view.frame.width - 20, height: 40))
        nameField.delegate = self
        nameField.textColor = UIColor.white
        nameField.font = UIFont(name: "Lato-Medium", size: 20.0)
        nameField.layer.borderColor = UIColor.white.cgColor
        nameField.layer.borderWidth = 2
        nameField.textAlignment = NSTextAlignment.center
        nameField.attributedPlaceholder = NSAttributedString(string: "Your Name",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        nameField.returnKeyType = .go
        nameField.layer.cornerRadius = 5
        nameField.layer.masksToBounds = true
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
        loginButton.setTitle("Login with Facebook", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        loginButton.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        
        loginButton.addTarget(self, action: #selector(loginPressed), for: UIControlEvents.touchUpInside)
        
        view.addSubview(loginButton)
    }
    
    func loginPressed() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: { (result, error) -> Void in
            if error != nil {
                print("an error occurred while signing in the user: \(error?.localizedDescription)")
            } else if (result?.isCancelled)! {
                print("user cancelled login")
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    self.userRef.child("\(user!.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                        if !snapshot.exists() {
                            let userDict: [String: String] = ["email": user!.email!,
                                                        "fullName": user!.displayName!,
                                                        "profPicUrl": user!.photoURL!.absoluteString]
                            self.userRef.child(user!.uid).setValue(userDict, withCompletionBlock: { (error, ref) -> Void in
                                let nav = self.storyboard?.instantiateViewController(withIdentifier: "SelectSchoolNavigation") as! NavigationController
                                self.show(nav, sender: nil)
                            })
                        } else {
                            let value = snapshot.value as? NSDictionary
                            if let _ = value?["school"] {
                                let controller = self.storyboard?.instantiateViewController(withIdentifier: "FrontVC")
                                self.revealViewController().setFront(controller, animated: true)
                            } else {
                                let nav = self.storyboard?.instantiateViewController(withIdentifier: "SelectSchoolNavigation") as! NavigationController
                                self.show(nav, sender: nil)
                            }
                        }
                                            
                    })
                    
                }
            }
        })
        
    }

}
