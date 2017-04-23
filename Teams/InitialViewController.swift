//
//  InitialViewController.swift
//  Teams
//
//  Created by Boris Yue on 4/22/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let firebaseAuth = FIRAuth.auth()
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "initialToFeed", sender: self)
        } else {
            self.performSegue(withIdentifier: "toLoginNav", sender: self)
        
        }
    }

}
