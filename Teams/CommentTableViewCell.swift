//
//  CommentTableViewCell.swift
//  Teams
//
//  Created by Amy on 4/15/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol CommentTableViewCellDelegate {
    
    func flagComment()
    
}

class CommentTableViewCell: UITableViewCell {
    
    var comment: UILabel!
    var name: UILabel!
    var pic: UIImageView!
    var flag: UIButton!
    var delegate: CommentTableViewCellDelegate?
    
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
        
        comment = MarqueeLabel(frame: CGRect(x: 100, y: name.frame.maxY + 5, width: contentView.frame.width, height: contentView.frame.height/2), rate: 35, fadeLength: 10)
        comment.textColor = UIColor.white
        comment.adjustsFontSizeToFitWidth = true
        comment.font = UIFont(name: "Lato-Light", size: 15)

        pic = UIImageView(frame: CGRect(x: 20, y: 15, width: 50, height: 50))
        pic.layer.cornerRadius = pic.frame.width / 2
        pic.layer.masksToBounds = true
        
        flag = UIButton(frame: CGRect(x: UIScreen.main.bounds.maxX - 20, y: 5, width: 15, height: 15))
        flag.setImage(#imageLiteral(resourceName: "flag"), for: .normal)
        flag.addTarget(self, action: #selector(flagComment), for: .touchUpInside)
        contentView.addSubview(flag)
        contentView.addSubview(name)
        contentView.addSubview(comment)
        contentView.addSubview(pic)

    }
    
    func flagComment() {
        delegate?.flagComment()
    }
}
