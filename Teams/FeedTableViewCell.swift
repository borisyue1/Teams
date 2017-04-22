//
//  FeedCellViewController.swift
//  Teams
//
//  Created by Amy on 4/4/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol FeedCellDelegate {
    
    func addInterestedUser(forCell: FeedTableViewCell, withId: String, user: User)
    func removeInterestedUser(forCell: FeedTableViewCell, withId: String, user: User)
    func goToComments(forCell: FeedTableViewCell)
    func goToPeopleGoing(forCell: FeedTableViewCell)
    
}

class FeedTableViewCell: UITableViewCell {
    
    var event: Event!
    
    var rectView: UIView!
    
    //var sportLabel: UILabel!
    var timeLabel: UILabel!
    //var locationLabel: UILabel!
    var descriptionLabel: UILabel!
    var pic: UIImageView!
    
    //Raw data values - (many extracted from Event)
    var author: String!
    var sport: String!
    var datePosted: Date!
    var month: String!
    var day: Int!
    var time: String!
    var school: String!
    var location: String!
    var numGoing: Int!
    var eventDescription: String!
    
    //UI values - captures raw data values
    var isPlayingLabel: UILabel!
    
    var authorLabel: UILabel!
    var sportLabel: UILabel!
    var monthLabel: UILabel!
    var dayLabel: UILabel!
    var schoolLabel: UILabel!
    var locationLabel: MarqueeLabel!
    var numGoingButton: UIButton!
    var eventDescriptionLabel: UILabel!
    
    var atLabel: UILabel!
    
    var commentButton: UIButton!
    var joinButton: UIButton!
    var delegate: FeedCellDelegate?
    var buttonIsSelected: Bool! //for joining
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpRectView()
        setUpAuthorLabel()
        setUpImage()
        setUpTimeLabel()
        setUpDateLabel()
        setupSportLabel()
        setUpLocationLabel()
        initAtLabel()
        
        initCommentButton()
        initJoinButton()
        
        setupGoingLabel()
        setUpDescriptionLabel()
        
        initLine()
    }
    
    func setUpRectView() {
        let width = contentView.frame.width - 30
        rectView = UIView(frame: CGRect(x: 15, y: 5, width: width, height: contentView.frame.height - 10))
        rectView.backgroundColor = UIColor.white
        
        rectView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        rectView.layer.borderWidth = 1.0
        
        rectView.layer.shadowColor = UIColor.black.cgColor
        rectView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        rectView.layer.shadowRadius = 2.5
        rectView.layer.shadowOpacity = 0.2
        rectView.layer.shadowPath = UIBezierPath(rect: rectView.bounds).cgPath
        contentView.addSubview(rectView)
    }
    
    func setupSportLabel() {
        sportLabel = MarqueeLabel(frame: CGRect(x: monthLabel.frame.maxX + 10, y: monthLabel.frame.maxY, width: 100, height: 100))
        sportLabel.font = UIFont(name: "Lato-Medium", size: 20.0)
        sportLabel.textColor = UIColor.black
        if (sport == "Ultimate Frisbee") {
            sportLabel.text = "Frisbee"
        } else {
            sportLabel.text = sport
        }
        sportLabel.numberOfLines = 0
        sportLabel.sizeToFit()
        rectView.addSubview(sportLabel)
    }
    
    
    func setUpImage() {
        pic = UIImageView(frame: CGRect(x: authorLabel.frame.maxX + 3, y: authorLabel.frame.minY + 2, width: 16, height: 16))
        rectView.addSubview(pic)
    }
    
    func setUpDateLabel() {
        monthLabel = UILabel(frame: CGRect(x: 15, y: isPlayingLabel.frame.maxY + 15, width: 34, height: 14))
        monthLabel.text = month
        monthLabel.font = UIFont(name: "Lato-Light", size: 14.0)
        monthLabel.textColor = UIColor(red: 240/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
        monthLabel.textAlignment = NSTextAlignment.center
        
        dayLabel = UILabel(frame: CGRect(x: 15, y: monthLabel.frame.maxY, width: 34, height: 24))
        dayLabel.textAlignment = NSTextAlignment.center
        dayLabel.font = UIFont(name: "Lato-Light", size: 24.0)
        dayLabel.textColor = UIColor.black
        dayLabel.text = String(day)
        
        rectView.addSubview(monthLabel)
        rectView.addSubview(dayLabel)
    }
    
    func initAtLabel() {
        atLabel = UILabel(frame: CGRect(x: rectView.frame.width / 2 - 13, y: sportLabel.frame.minY - 3, width: 25, height: 30))
        atLabel.text = "@"
        atLabel.textColor = UIColor.black
        atLabel.textAlignment = NSTextAlignment.center
        atLabel.font = UIFont(name: "Lato-Medium", size: 26.0)
        
        rectView.addSubview(atLabel)
    }
    
    func setUpAuthorLabel() {
        isPlayingLabel = UILabel(frame: CGRect(x: 15, y: 12, width: 0, height: 16.0))
        isPlayingLabel.text = author
        isPlayingLabel.font = UIFont(name: "Lato-Medium", size: 14.0)
        isPlayingLabel.sizeToFit()
        
        rectView.addSubview(isPlayingLabel)
        
        authorLabel = UILabel(frame: CGRect(x: isPlayingLabel.frame.maxX, y: 12, width: 0, height: 16.0))
        authorLabel.text = " is playing "
        authorLabel.textColor = UIColor.black
        authorLabel.font = UIFont(name: "Lato-Light", size: 14.0)
        authorLabel.sizeToFit()
        
        rectView.addSubview(authorLabel)
    }
    
    func setUpTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: rectView.frame.width - 70, y: 12, width: 100, height: 30))
        timeLabel.text = time
        timeLabel.textColor = UIColor.black
        timeLabel.font = UIFont(name: "Lato-Light", size: 14.0)
        timeLabel.sizeToFit()
        rectView.addSubview(timeLabel)
    }
    
    func setUpLocationLabel() {
        locationLabel = MarqueeLabel(frame: CGRect(x: rectView.frame.width / 2 + 15, y: monthLabel.frame.maxX - 10, width: rectView.frame.width / 2 - 25, height: 60), rate: 22.0, fadeLength: 10.0)
        locationLabel.textAlignment = NSTextAlignment.right
        locationLabel.numberOfLines = 0
        locationLabel.text = location
        locationLabel.textColor = UIColor.black
        locationLabel.font = UIFont(name: "Lato-Medium", size: 20.0)
        
        rectView.addSubview(locationLabel)
    }
    
    func setUpDescriptionLabel() {
        descriptionLabel = MarqueeLabel(frame: CGRect(x: numGoingButton.frame.maxX + 25, y: joinButton.frame.minY - 40, width: rectView.frame.width - numGoingButton.frame.maxX - 40, height: 17), rate: 20, fadeLength: 5)
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont(name: "Lato-Light", size: 14.0)
        descriptionLabel.textAlignment = NSTextAlignment.right
        descriptionLabel.text = eventDescription
        rectView.addSubview(descriptionLabel)
    }
    
    func setupGoingLabel() {
        numGoingButton = UIButton(frame: CGRect(x: dayLabel.frame.minX, y: joinButton.frame.minY - 40, width: 70, height: 22))
        numGoingButton.backgroundColor = UIColor(red: 234/255, green: 119/255, blue: 131/255, alpha: 1.0)
        numGoingButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 14.0)
        numGoingButton.layer.cornerRadius = 2
        numGoingButton.layer.masksToBounds = true
        numGoingButton.addTarget(self, action: #selector(numGoingPressed), for: .touchUpInside)

//        numGoingButton.text = String(2) + " going"   //String(numGoing)
        
        rectView.addSubview(numGoingButton)
    }
    
    
    func initLine() {
        
        var aPath = UIBezierPath()
        var bPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x:rectView.frame.minX, y:rectView.frame.maxY - 40))
        aPath.addLine(to: CGPoint(x:rectView.frame.maxX, y:rectView.frame.maxY - 40))
        
        aPath.move(to: CGPoint(x:rectView.frame.minX + rectView.frame.width / 2, y:rectView.frame.maxY - 40))
        aPath.addLine(to: CGPoint(x:rectView.frame.minX + rectView.frame.width / 2, y:rectView.frame.maxY))
        
        bPath.move(to: CGPoint(x:rectView.frame.minX + 15, y: timeLabel.frame.maxY + rectView.frame.minY + 7))
        bPath.addLine(to: CGPoint(x:rectView.frame.maxX - 15, y:timeLabel.frame.maxY + rectView.frame.minY + 7))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        bPath.close()
        
        //If you want to stroke it with a red color
        UIColor.lightGray.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        bPath.stroke()
        bPath.fill()
        
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = aPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 1.0
        
        var shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = bPath.cgPath
        shapeLayer2.strokeColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        shapeLayer2.lineWidth = 0.5
        
        contentView.layer.addSublayer(shapeLayer)
        contentView.layer.addSublayer(shapeLayer2)
    }
    
    func initCommentButton() {
        commentButton = UIButton(frame: CGRect(x: rectView.frame.minX + 1, y: rectView.frame.maxY - 40, width: rectView.frame.width / 2 - 1, height: 40))
        commentButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 14.0)
        commentButton.setTitleColor(UIColor.black, for: .normal)
        commentButton.backgroundColor = UIColor.init(red: 249/255, green: 170/255, blue: 97/255, alpha: 1.0)
        
        commentButton.contentHorizontalAlignment = .center
        commentButton.addTarget(self, action: #selector(commentPressed), for: .touchUpInside)
        contentView.addSubview(commentButton)
    }
    
    func initJoinButton() {
        joinButton = UIButton(frame: CGRect(x: commentButton.frame.maxX, y: rectView.frame.maxY - 40, width: rectView.frame.width / 2 - 1, height: 40))
        joinButton.isSelected = buttonIsSelected
        if !buttonIsSelected {
            joinButton.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        } else {
            joinButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        }
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitle("Unjoin", for: .selected)
        
        joinButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 14.0)
        joinButton.setTitleColor(UIColor.black, for: .normal)
        joinButton.contentHorizontalAlignment = .center
        joinButton.addTarget(self, action: #selector(joinTeam), for: .touchUpInside)
        contentView.addSubview(joinButton)
    }
    
    func joinTeam() {
        if !buttonIsSelected {
            joinButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
            buttonIsSelected = true
            joinButton.isSelected = true
            delegate?.addInterestedUser(forCell: self, withId: FeedViewController.user.id!, user: FeedViewController.user)
        } else {
            joinButton.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
            buttonIsSelected = false
            joinButton.isSelected = false
            delegate?.removeInterestedUser(forCell: self, withId: FeedViewController.user.id!, user: FeedViewController.user)
        }
    }
    
    func numGoingPressed() {
        delegate?.goToPeopleGoing(forCell: self)
    }
    
    func commentPressed() {
        delegate?.goToComments(forCell: self)
    }
    
}
