//
//  NavigationController.swift
//  Teams
//
//  Created by Eliot Han on 4/8/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import Foundation
import UIKit

//The main Navigation Controller

class NavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //next two lines to hide nav bar shadow and line
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()    }
    
    
    
}
