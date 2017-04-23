//
//  NewEventViewController.swift
//  Teams
//
//  Created by Shireen Warrier on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import MapKit
import DropDown
import Firebase

class NewEventViewController: UIViewController {
    
    var navBar: UINavigationBar!
    var createTeamLabel: UILabel!
    var sportPicker: UIPickerView!
    var sportsList: [String]!
    var datePicker: UIDatePicker!
    var locationTextField: UITextField!
    var postButton: UIButton!
    var descriptionField: UITextView!
    var date: String!
    var sport: String!
    var auth = FIRAuth.auth()
    var eventsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Event")
    var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Users")
    var peopleGoing: [String]!
    var comments: [String]!
    var addressCompleter = MKLocalSearchCompleter()
    var dropdown = DropDown() //for location search
    var locations: [String] = [] //for location search
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        UITextField.appearance().tintColor = UIColor.white //sets cursor to white
        UITextView.appearance().tintColor = UIColor.white
        if let user = FeedViewController.user {
            self.user = FeedViewController.user
        }
        self.setUpNavBar()
        self.setupLayout()
        self.initDropDown()
        self.addressCompleter.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - postButton.frame.height - 10)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - postButton.frame.height - 10)
            }
        }
    }
    
    func setUpNavBar() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.09))
        navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navBar.tintColor = UIColor.white
        navBar.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        navBar.barTintColor = UIColor.clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(image: resizeImage(image: #imageLiteral(resourceName: "exit"), targetSize: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(goBack))
        navBar.items = [navItem]
        view.addSubview(navBar)
        
    }
    
    func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func initDropDown() {
        dropdown.anchorView = locationTextField
        dropdown.dataSource = locations
        dropdown.bottomOffset = CGPoint(x: 0, y: locationTextField.bounds.height)
        dropdown.direction = .bottom
        dropdown.width = locationTextField.frame.width
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        addressCompleter.queryFragment = textField.text!
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            //self.dropdown.show()
            self.locationTextField.text = item
        }
        dropdown.show()
        locations.removeAll() //reset results
        return true
    }
    
    
    func setupLayout() {
        view.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        
        createTeamLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height / 9, width: view.frame.width, height: view.frame.height/13))
        createTeamLabel.textAlignment = .center
        createTeamLabel.text = "Create a Game"
        createTeamLabel.font = UIFont(name: "Lato-Bold", size: 30)
        createTeamLabel.adjustsFontSizeToFitWidth = true
        createTeamLabel.textColor = UIColor.white
        
        sportPicker = UIPickerView(frame: CGRect(x: 25, y: createTeamLabel.frame.maxY + 10, width: view.frame.width - 50, height: 120))
        sportPicker.delegate = self
        sportPicker.dataSource = self
        
        sportsList = ["Soccer", "Basketball", "Football", "Ultimate Frisbee", "Tennis", "Volleyball", "Baseball", "Spikeball"]
        
        datePicker = UIDatePicker(frame: CGRect(x: 25, y: sportPicker.frame.maxY + 10, width: view.frame.width - 50, height: 125))
        datePicker.addTarget(self, action: #selector(getDate), for: .valueChanged)
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        locationTextField = UITextField(frame: CGRect(x: 25, y: datePicker.frame.maxY + 25, width: view.frame.width - 50, height: 40))
        locationTextField.textAlignment = .center
        locationTextField.textColor = UIColor.white
        locationTextField.font = UIFont.systemFont(ofSize: 20)
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Enter Location",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        locationTextField.delegate = self
        
        locationTextField.tag = 0
        
        descriptionField = UITextView(frame: CGRect(x: 25, y: locationTextField.frame.maxY + 15, width: view.frame.width - 50, height: view.frame.height/10))
        descriptionField.text = "Description of Event"
        descriptionField.textAlignment = .center
        descriptionField.textContainer.maximumNumberOfLines = 2
        descriptionField.textColor = UIColor.white
        descriptionField.font = UIFont.systemFont(ofSize: 20)
        descriptionField.isUserInteractionEnabled = true
        descriptionField.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        descriptionField.tag = 1
        descriptionField.returnKeyType = .go
        descriptionField.delegate = self
        
        postButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 80, width: view.frame.width, height: 80))
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.backgroundColor = UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0)
        postButton.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        postButton.addTarget(self, action: #selector(addNewEvent), for: .touchUpInside)
        
        view.addSubview(createTeamLabel)
        view.addSubview(sportPicker)
        view.addSubview(datePicker)
        view.addSubview(locationTextField)
        view.addSubview(postButton)
        view.addSubview(descriptionField)
    }
    
    func getDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        date = dateFormatter.string(from: sender.date)
    }
    
    func addNewEvent() {
        if (date == nil) {
            getDate(sender: self.datePicker)
        }
        
        let location = locationTextField.text!
        let description = descriptionField.text!
    
        if description == "Description of Event" || description == "" || location == "" {
            self.displayError(withMessage: "Please fill out all fields.")
        } else {
            postButton.backgroundColor = UIColor.white
            postButton.setTitleColor(UIColor.init(red: 75/255, green: 184/255, blue: 147/255, alpha: 1.0), for: .normal)
            sport = sportsList[sportPicker.selectedRow(inComponent: 0)]
            self.locationTextField.text = ""
            self.descriptionField.text = ""
            let schoolRef = eventsRef.child(user.school)
            peopleGoing = [user.id!]
        
            let newEvent = ["author": user.name, "sport": sport, "description": description, "peopleGoing": peopleGoing, "date": date, "location": location] as [String : Any]
            let key = schoolRef.childByAutoId().key
            let childUpdates = ["/\(key)/": newEvent]
            schoolRef.updateChildValues(childUpdates)
            
            if let _ = FeedViewController.user {
                FeedViewController.user.eventsJoined.append(key)
            }
            user.eventsJoined.append(key)
            let userUpdate: [String: [String]] = ["eventsJoined": user.eventsJoined]
            userRef.child(user.id!).updateChildValues(userUpdate)
            OptionViewController.shouldGoToFeed = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //changes size of image
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

extension NewEventViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder() //advances to next text field when return is pressed
        } else if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextView {
            // no more text fields after
            nextField.becomeFirstResponder()
        }
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") { // go back when line is skipped AKA enter is pressed
            textView.resignFirstResponder()
            addNewEvent()
        }
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sportsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sportsList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sport = sportsList[row]
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionField.text = ""
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionField.text.isEmpty { //if finished editing and text is empty, return to placeholder
            descriptionField.text = "Event Description"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: sportsList[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }
}

extension NewEventViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completer.results.map { result in
            locations.append(result.title)
            dropdown.dataSource = locations
        }
        // use addresses, e.g. update model and call `tableView.reloadData()
    }
}

