//
//  PeopleGoingTableViewCell.swift
//  Teams
//
//  Created by Shireen Warrier on 4/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class PeopleGoingTableViewCell: UITableViewCell {
    var name: UILabel!
    var profilePic: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    
    func setupUI() {
        profilePic = UIImageView(frame: CGRect(x: 20, y: 10, width: contentView.frame.width * (1/5), height: contentView.frame.width * (1/5)))
        profilePic.layer.cornerRadius = profilePic.frame.width  / 2
        profilePic.layer.masksToBounds = true
        
        name = UILabel(frame: CGRect(x: 30, y: 20, width: contentView.frame.width - profilePic.frame.width - 10, height: contentView.frame.height))
        name.textAlignment = .center
        name.font = UIFont(name: "HelveticaNeue-Thin", size: 15)

        contentView.addSubview(profilePic)
        contentView.addSubview(name)
    }

}
