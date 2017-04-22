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
        name.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        
        comment = UILabel(frame: CGRect(x: 100, y: name.frame.maxY + 5, width: contentView.frame.width, height: contentView.frame.height/2))
        comment.textColor = UIColor.white
        comment.adjustsFontSizeToFitWidth = true
        comment.font = UIFont(name: "HelveticaNeue-Thin", size: 15)

        pic = UIImageView(frame: CGRect(x: 20, y: 15, width: 50, height: 50))
        pic.image = #imageLiteral(resourceName: "anon")
        contentView.addSubview(name)
        contentView.addSubview(comment)
        contentView.addSubview(pic)

    }
}
