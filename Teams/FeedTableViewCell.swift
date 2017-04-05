//
//  FeedCellViewController.swift
//  Teams
//
//  Created by Amy on 4/4/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    var sportLabel: UILabel!
    var timeLabel: UILabel!
    var locationLabel: UILabel!
    var descriptionLabel: UILabel!
    var pic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpImage()
        setUpSportLabel()
        setUpTimeLabel()
        setUpLocationLabel()
        setUpDescriptionLabel()
    }
    
    func setUpImage() {
        pic = UIImageView(frame: CGRect(x: 0, y: 4, width: contentView.frame.width, height: contentView.frame.height - 8))
        pic.image = #imageLiteral(resourceName: "soccer")
        pic.layer.shadowColor = UIColor.black.cgColor
        pic.layer.shadowOpacity = 1
        pic.layer.shadowOffset = CGSize(width: 0, height: 3)
        pic.layer.shadowRadius = 1.5
        contentView.addSubview(pic)
        //insert gray layer
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        layer.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.5).cgColor
        contentView.layer.insertSublayer(layer, at: 10)
    }
    
    func setUpSportLabel() {
        sportLabel = UILabel(frame: CGRect(x: contentView.frame.width / 11.5, y: contentView.frame.height / 11, width: 100, height: 30))
        sportLabel.text = "Soccer"
        sportLabel.textColor = UIColor.white
        sportLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(sportLabel)
    }
    
    func setUpTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: contentView.frame.width - 90, y: contentView.frame.height / 11, width: 100, height: 30))
        timeLabel.text = "4:20 pm"
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(timeLabel)
    }
    
    func setUpLocationLabel() {
        locationLabel = UILabel(frame: CGRect(x: contentView.frame.width / 11.5, y: contentView.frame.height / 3, width: 200, height: 30))
        locationLabel.text = "Edwards Stadium - 4 going"
        locationLabel.textColor = UIColor.white
        locationLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(locationLabel)
    }
    
    func setUpDescriptionLabel() {
        descriptionLabel = UILabel(frame: CGRect(x: contentView.frame.width / 11.5, y: contentView.frame.height / 1.75, width: contentView.frame.width, height: 30))
        descriptionLabel.text = "everyone is welcome!!!"
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(descriptionLabel)
    }
    
}
