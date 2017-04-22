//
//  CommentTableViewCell.swift
//  Teams
//
//  Created by Amy on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import MarqueeLabel

class CommentTableViewCell: UITableViewCell {
    var comment: UILabel!
    var name: UILabel!
    var pic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func setupLayout() {
        contentView.backgroundColor = UIColor.clear
        
        name = UILabel(frame: CGRect(x: 100, y: 15, width: contentView.frame.width, height: contentView.frame.height/2))
        name.textColor = UIColor.white
        name.adjustsFontSizeToFitWidth = true
        name.font = UIFont(name: "Lato-Bold", size: 17)
        
        comment = MarqueeLabel(frame: CGRect(x: 100, y: name.frame.maxY + 5, width: contentView.frame.width, height: contentView.frame.height/2), rate: 20, fadeLength: 10)
        comment.textColor = UIColor.white
        comment.adjustsFontSizeToFitWidth = true
        comment.font = UIFont(name: "Lato-Light", size: 15)

        pic = UIImageView(frame: CGRect(x: 20, y: 15, width: 50, height: 50))
        pic.layer.cornerRadius = pic.frame.width / 2
        pic.layer.masksToBounds = true
        contentView.addSubview(name)
        contentView.addSubview(comment)
        contentView.addSubview(pic)

    }
}
