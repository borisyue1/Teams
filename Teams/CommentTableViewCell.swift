//
//  CommentTableViewCell.swift
//  Teams
//
//  Created by Amy on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    var comment: UILabel!
    var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func setupLayout() {
        contentView.backgroundColor = UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        
        name = UILabel(frame: CGRect(x: 30, y: 0, width: contentView.frame.width, height: contentView.frame.height/2))
        name.textColor = UIColor.white
        name.adjustsFontSizeToFitWidth = true
        name.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        
        comment = UILabel(frame: CGRect(x: 30, y: name.frame.maxY, width: contentView.frame.width, height: contentView.frame.height/2))
        comment.textColor = UIColor.white
        comment.adjustsFontSizeToFitWidth = true
        comment.font = UIFont(name: "HelveticaNeue-Thin", size: 15)

        
        contentView.addSubview(name)
        contentView.addSubview(comment)
    }
}
