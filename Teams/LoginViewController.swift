
import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    var titleLabel: UILabel!
    var selectLabel: UILabel!
    var button: UIButton!
    var box: UIView!
    var whiteLine: UIButton!
    var signInButton: UIButton!
    var userRef = FIRDatabase.database().reference().child("Users")
    var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser != nil {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "FrontVC")
            self.revealViewController().setFront(controller, animated: true)
        }
        setupBox()
        initTitleLabel()
        initButton()
        
        initTriangle()
        
        initWhiteLine()
        
        initSignInButton()
        
        self.view.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0), for: .normal)
    }
    
    func initTitleLabel() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height / 5.5, width: 0, height: 0))
        titleLabel.text = "Sportify"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Lato-Bold", size: 45)
        titleLabel.sizeToFit()
        titleLabel.frame.origin.x = view.frame.width / 2 - titleLabel.frame.width / 2
        view.addSubview(titleLabel)
    }
    
    func createLoader() {
        loader = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2 + 100, width: 100, height: 100))
        let transform = CGAffineTransform(scaleX: 2, y: 2)
        loader.transform = transform
        loader.startAnimating()
        loader.tintColor = UIColor.white
        view.addSubview(loader)
    }
    
    func initSignInButton() {
        signInButton = UIButton(frame: CGRect(x: box.frame.minX + 15, y: box.frame.maxY + 25, width: 100, height: 25))
        signInButton.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        signInButton.setTitle("SIGN IN", for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        
        
        view.addSubview(signInButton)
    }
    
    func initTriangle() {
        let triangle = TriangleView(frame: CGRect(x: box.frame.minX + 40, y: box.frame.maxY, width: 25, height: 15))
        triangle.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        view.addSubview(triangle)
    }
    
    func initWhiteLine() {
        whiteLine = UIButton(frame: CGRect(x: box.frame.minX, y: box.frame.minY - 6, width: box.frame.width, height: 3))
        whiteLine.backgroundColor = UIColor.white
        view.addSubview(whiteLine)
    }
    
    func setupBox() {
        box = UIView(frame: CGRect(x: 50, y: view.frame.height / 2 - 75, width: view.frame.width - 100, height: 90))
        box.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        box.layer.cornerRadius = 3
        box.layer.masksToBounds = true
        view.addSubview(box)
    }
    
    func initButton() {
        button = UIButton(frame: CGRect(x: 20, y: 20, width: box.frame.width - 40, height: 50))
        button.setTitle("With Facebook", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.white
        
        button.layer.cornerRadius = 3
        
        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 20.0)
        
        button.setTitleColor(UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0), for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center

        
        box.addSubview(button)
    }
    
    func buttonPressed() {
        createLoader()
        let loginManager = FBSDKLoginManager()
        button.backgroundColor = UIColor.init(red: 41/255, green: 41/255, blue: 49/255, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: .normal)
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: { (result, error) -> Void in
            if error != nil {
                print("an error occurred while signing in the user: \(error?.localizedDescription)")
            } else if (result?.isCancelled)! {
                self.loader.removeFromSuperview()
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
                                self.loader.removeFromSuperview()
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
                            self.loader.removeFromSuperview()
                        }
                                            
                    })
                    
                }
            }
        })
    }
    
}

class TriangleView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        context.closePath()
        
        context.setFillColor(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        context.fillPath()
    }
}
