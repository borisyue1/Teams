
//  LoginViewController.swift
//  Teams
//
//  Created by Mark Siano on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.


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

//import UIKit
//import DropDown
//
//class LoginViewController : UIViewController, UITextFieldDelegate {
//    
//    var dropdown: DropDown!
//    var selectLabel: UILabel!
//    var nextButton: UIButton!
//    var button: UIButton!
//    var box: UIView!
//    var nameField: UITextField!
//    var whiteLine: UIButton!
//    
//    var signInButton: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupBox()
//        
//        initButton()
//        //initLabel()
//        initDropDown()
//        //initNextButton()
//        initNameField()
//        
//        initTriangle()
//        
//        initWhiteLine()
//        
//        initSignInButton()
//        
////        self.view.backgroundColor = UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0)
//        self.view.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
//    }
//    
//    func initSignInButton() {
//        signInButton = UIButton(frame: CGRect(x: box.frame.minX + 15, y: box.frame.maxY + 25, width: 100, height: 25))
////        signInButton.backgroundColor = UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0)
//        signInButton.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
//        signInButton.setTitle("SIGN IN", for: .normal)
//        signInButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
//        
//        signInButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
//        
//        view.addSubview(signInButton)
//    }
//    
//    func initTriangle() {
//        let triangle = TriangleView(frame: CGRect(x: box.frame.minX + 40, y: box.frame.maxY, width: 25, height: 15))
////        triangle.backgroundColor = UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0)
//        triangle.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
//        view.addSubview(triangle)
//    }
//    
//    func initWhiteLine() {
//        whiteLine = UIButton(frame: CGRect(x: box.frame.minX, y: box.frame.minY - 6, width: box.frame.width, height: 3))
////        whiteLine.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
//        whiteLine.backgroundColor = UIColor.white
//        view.addSubview(whiteLine)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        loginPressed()
//        return true
//    }
//    
//    func loginPressed() {
//        //nextPressed
//        if let _ = UserDefaults.standard.value(forKey: "school") {
//            if nameField.text != "" {
//                UserDefaults.standard.set(nameField.text, forKey: "name")
//                //            performSegue(withIdentifier: "toOptionView", sender: self)
//                self.navigationController?.pushViewController(OptionViewController(), animated: true)
//            } else {
//                self.displayError(withMessage: "Please input your name first.")
//                return
//            }
//            //            performSegue(withIdentifier: "toLoginView", sender: self)
//            //self.navigationController?.pushViewController(LoginViewController(), animated: true)
//            
//        } else {
//            self.displayError(withMessage: "Please select a school first.")
//        }
//    }
//    
//    func initNameField() {
//        UITextField.appearance().tintColor = UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0) //sets cursor to white
//        nameField = UITextField(frame: CGRect(x: 20, y: button.frame.maxY + 10, width: box.frame.width - 40, height: 50))
//        nameField.delegate = self
//        nameField.layer.cornerRadius = 3
//        nameField.textColor = UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0)
//        nameField.font = UIFont(name: "Lato-Medium", size: 20.0)
//        nameField.layer.borderColor = UIColor.white.cgColor
//        nameField.layer.borderWidth = 2
//        nameField.backgroundColor = UIColor.white
//        nameField.textAlignment = NSTextAlignment.center
//        nameField.attributedPlaceholder = NSAttributedString(string: "Your Name",
//                                                             attributes: [NSForegroundColorAttributeName: UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0)])
//        nameField.returnKeyType = .go
//        box.addSubview(nameField)
//    }
//    
//    func setupBox() {
//        box = UIView(frame: CGRect(x: 50, y: view.frame.height / 2 - 75, width: view.frame.width - 100, height: 150))
////        box.backgroundColor = UIColor.init(red: 66/255, green: 49/255, blue: 66/255, alpha: 1.0)
//        box.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
//        box.layer.cornerRadius = 3
//        box.layer.masksToBounds = true
//        view.addSubview(box)
//    }
//    
//    func initLabel() {
//        selectLabel = UILabel(frame: CGRect(x: 0, y: self.button.frame.minY - 32, width: view.frame.width, height: 22))
//        selectLabel.font = UIFont(name: "Lato-Light", size: 16.0)
//        selectLabel.text = "I go to"
//        selectLabel.textAlignment = NSTextAlignment.center
//        selectLabel.textColor = UIColor.white
//        
//        view.addSubview(selectLabel)
//    }
//    
//    func initButton() {
//        button = UIButton(frame: CGRect(x: 20, y: 20, width: box.frame.width - 40, height: 50))
//        button.setTitle("Select School", for: .normal)
//        button.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
//        button.backgroundColor = UIColor.white
//        
//        button.layer.cornerRadius = 3
//        
//        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 20.0)
//        
//        button.setTitleColor(UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0), for: .normal)
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
//        button.layer.borderWidth = 3.0
//        button.layer.borderColor = UIColor.white.cgColor
//        
//        box.addSubview(button)
//    }
//    
//    func buttonPressed() {
//        self.dropdown.show()
//    }
//    
//    func initDropDown() {
//        dropdown = DropDown()
//                
//        dropdown.anchorView = button
//        dropdown.dataSource = ["UC Berkeley", "UCLA", "UC Irvine", "UC Santa Barbara", "UC Riverside", "UC Merced", "UC Davis", "USC", "Stanford"]
//        dropdown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
//        dropdown.direction = .bottom
//        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
//            //self.dropdown.show()
//            self.button.setTitle(item, for: .normal)
//            UserDefaults.standard.set(item, forKey: "school")
//            print("Selected item: \(item) at index: \(index)")
//        }
//        dropdown.width = 230
//        
//    }
//    
//    func nextPressed() {
//        
//    }
//}
//
//class TriangleView : UIView {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override func draw(_ rect: CGRect) {
//        
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        
//        context.beginPath()
//        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
//        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
//        context.closePath()
//        
////        context.setFillColor(red: 66/255, green: 49/255, blue: 66/255, alpha: 1.0)
//        context.setFillColor(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
//        context.fillPath()
//    }
//}
