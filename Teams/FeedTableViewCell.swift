//
//  FeedCellViewController.swift
//  Teams
//
//  Created by Amy on 4/4/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label = UILabel(frame: CGRect(x: 0, y: 50, width: 100, height: 100))
        label.text = "hi"
        contentView.addSubview(label)
    }
    
}
