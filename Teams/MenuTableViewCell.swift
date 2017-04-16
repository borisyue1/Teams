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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel = UILabel(frame: CGRect(x: contentView.frame.minX + 10, y: 0, width: contentView.frame.width, height: contentView.frame.height))
        nameLabel.textColor = UIColor.black
        nameLabel.adjustsFontSizeToFitWidth = true
        
        contentView.addSubview(nameLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
