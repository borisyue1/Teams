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
        name = UILabel(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        comment = UILabel(frame: CGRect(x: 10, y: 30, width: 50, height: 50))
        contentView.addSubview(name)
        contentView.addSubview(comment)
        
        
    }
    
}
