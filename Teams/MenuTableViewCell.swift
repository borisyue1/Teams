//
//  MenuTableViewCell.swift
//  Teams
//
//  Created by Shireen Warrier on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    var nameLabel: UILabel!
    var labelIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelIcon = UIImageView(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
        
        nameLabel = UILabel(frame: CGRect(x: labelIcon.frame.maxX + 10, y: 0, width: contentView.frame.width - (labelIcon.frame.maxX + labelIcon.frame.width + 10), height: contentView.frame.height))
        nameLabel.textColor = UIColor.black
        nameLabel.adjustsFontSizeToFitWidth = true
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(labelIcon)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
