//
//  NewEventViewController.swift
//  Teams
//
//  Created by Shireen Warrier on 4/5/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor.white
        
        createTeamLabel = UILabel(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)! + 10, width: view.frame.width, height: 75))
        createTeamLabel.textAlignment = .center
        createTeamLabel.text = "Create a Team"
        createTeamLabel.font = UIFont(name: "ArialMT", size: 23)
        createTeamLabel.adjustsFontSizeToFitWidth = true
        createTeamLabel.textColor = UIColor.black
        
        sportPicker = UIPickerView(frame: CGRect(x: 0, y: createTeamLabel.frame.maxY + 10, width: view.frame.width, height: 120))
        sportPicker.delegate = self
        sportPicker.dataSource = self
        
        sportsList = ["Soccer", "Basketball", "Football", "Ultimate Frisbee", "Tennis", "Volleyball", "Golf", "Spikeball"]
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: sportPicker.frame.maxY + 20, width: view.frame.width, height: 125))
        datePicker.addTarget(self, action: #selector(getDate), for: .valueChanged)
        
        locationTextField = UITextField(frame: CGRect(x: 0, y: datePicker.frame.maxY + 20, width: view.frame.width, height: 75))
        locationTextField.placeholder = "Enter Location"
        locationTextField.textAlignment = .center
        
        descriptionField = UITextView(frame: CGRect(x: 0, y: locationTextField.frame.maxY + 20, width: view.frame.width, height: 100))
        descriptionField.text = "Description of Event"
        descriptionField.textAlignment = .center
        descriptionField.textContainer.maximumNumberOfLines = 2
        descriptionField.textColor = UIColor.black
        descriptionField.isUserInteractionEnabled = true
        descriptionField.delegate = self
        
        postButton = UIButton(frame: CGRect(x: 0, y: descriptionField.frame.maxY + 20, width: view.frame.width, height: 60))
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor.black, for: .normal)
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
        let location = locationTextField.text!
        self.locationTextField.text = ""
        let description = descriptionField.text!
        self.descriptionField.text = ""
        let schoolRef = eventsRef.child(defaults.value(forKey: "school") as! String)
        let newEvent = ["author": UserDefaults.standard.string(forKey: "name"), "authorPhoneNumber": "5100000000", "sport": sport, "description": description, "peopleGoing": ["_"], "date": date, "location": location] as [String : Any]
        let key = schoolRef.childByAutoId().key
        let childUpdates = ["/\(key)/": newEvent]
        schoolRef.updateChildValues(childUpdates)
        
        performSegue(withIdentifier: "newToFeed", sender: self)
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
}

