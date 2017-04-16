//
//  NewEventViewController.swift
//  Teams
//
//  Created by Shireen Warrier on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class NewEventViewController: UIViewController {
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
    var peopleGoing: [String]!
    var addressCompleter = MKLocalSearchCompleter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupLayout()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        
        createTeamLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height / 8.5, width: view.frame.width, height: view.frame.height/13))
        createTeamLabel.textAlignment = .center
        createTeamLabel.text = "Create a Team"
        createTeamLabel.font = UIFont(name: "ArialMT", size: 30)
        createTeamLabel.adjustsFontSizeToFitWidth = true
        createTeamLabel.textColor = UIColor.white
        
        sportPicker = UIPickerView(frame: CGRect(x: 50, y: createTeamLabel.frame.maxY + 10, width: view.frame.width - 100, height: 120))
        sportPicker.delegate = self
        sportPicker.dataSource = self
        
        sportsList = ["Soccer", "Basketball", "Football", "Ultimate Frisbee", "Tennis", "Volleyball", "Golf", "Spikeball"]
        
        datePicker = UIDatePicker(frame: CGRect(x: 50, y: sportPicker.frame.maxY + 20, width: view.frame.width - 100, height: 125))
        datePicker.addTarget(self, action: #selector(getDate), for: .valueChanged)
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        locationTextField = UITextField(frame: CGRect(x: 0, y: datePicker.frame.maxY + 20, width: view.frame.width, height: 75))
        locationTextField.placeholder = "Enter Location"
        locationTextField.textAlignment = .center
        locationTextField.textColor = UIColor.white
        
        descriptionField = UITextView(frame: CGRect(x: 0, y: locationTextField.frame.maxY + 20, width: view.frame.width, height: view.frame.height/10))
        descriptionField.text = "Description of Event"
        descriptionField.textAlignment = .center
        descriptionField.textContainer.maximumNumberOfLines = 2
        descriptionField.textColor = UIColor.white
        descriptionField.font = UIFont(name: (descriptionField.font?.fontName)!, size: 20)
        descriptionField.isUserInteractionEnabled = true
        descriptionField.delegate = self
        descriptionField.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        
        postButton = UIButton(frame: CGRect(x: view.frame.width/5, y: descriptionField.frame.maxY + 10, width: view.frame.width * (3/5), height: view.frame.height/11))
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.titleLabel?.font = UIFont(name: (postButton.titleLabel?.font.fontName)!, size: 20)
        postButton.layer.borderWidth = 3.0
        postButton.layer.borderColor = UIColor.white.cgColor
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
        sport = sportsList[sportPicker.selectedRow(inComponent: 0)]
        let location = locationTextField.text!
        self.locationTextField.text = ""
        let description = descriptionField.text!
        self.descriptionField.text = ""
        let schoolRef = eventsRef.child(UserDefaults.standard.value(forKey: "school") as! String)
        peopleGoing = []
        peopleGoing.append(UserDefaults.standard.string(forKey: "name")!)
        let newEvent = ["author": UserDefaults.standard.string(forKey: "name")!, "sport": sport, "description": description, "peopleGoing": peopleGoing, "date": date, "location": location] as [String : Any]
        let key = schoolRef.childByAutoId().key
        let childUpdates = ["/\(key)/": newEvent]
        schoolRef.updateChildValues(childUpdates)
        
//        performSegue(withIdentifier: "newToFeed", sender: self)
//        self.navigationController?.pushViewController(FeedViewController(), animated: true)
//        if presentingViewController is OptionViewController {
//        }
//        let presentingViewController = self.presentingViewController
        OptionViewController.shouldGoToFeed = true
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewEventViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: sportsList[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }
}

