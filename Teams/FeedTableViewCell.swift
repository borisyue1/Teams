//
//  FeedCellViewController.swift
//  Teams
//
//  Created by Amy on 4/4/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

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
    var teamName: String!
    var numGoing: Int!
    var eventDescription: String!
    
    //UI values - captures raw data values
    var isPlayingLabel: UILabel!
    
    var authorLabel: UILabel!
    var sportLabel: UILabel!
    var monthLabel: UILabel!
    var dayLabel: UILabel!
    var schoolLabel: UILabel!
    var teamNameLabel: UILabel!
    var locationLabel: UILabel!
    var numGoingLabel: UILabel!
    var eventDescriptionLabel: UILabel!
    
    var atLabel: UILabel!
    
    var contactButton: UIButton!
    var joinButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //initTestValues()
        setUpImage()
        setUpRectView()
        setUpAuthorLabel()
        setUpTimeLabel()
        //        setUpLocationLabel()
        
        
        //descriptionLabel.isHidden = true
        //locationLabel.isHidden = true
        
        setUpDateLabel()
        setupSportLabel()
//        setupTeamNameLabel()
        setUpLocationLabel()
        initAtLabel()
        
        setupGoingLabel()
        setUpDescriptionLabel()
        
        initContactButton()
        initJoinButton()
        
        initLine()
    }
    
    func initTestValues() {
        sport = "basketball"
        author = "Mark"
        datePosted = Date(timeIntervalSinceNow: 3.0)
        month = "MAY"
        day = 20
        school = "UC Berkeley"
        location = "People's Park"
        teamName = "Swaggers"
        numGoing = 4
        eventDescription = "come thru if u wanna ball tonite"
    }
    
    func setUpRectView() {
        let inset = contentView.frame.width / 15
        let width = contentView.frame.width - (2 * inset)
        rectView = UIView(frame: CGRect(x: inset, y: 20, width: width, height: contentView.frame.height - 40))
        rectView.backgroundColor = UIColor.white
        
        rectView.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        rectView.layer.borderWidth = 1.5
        
        //rectView.layer.shadowColor = UIColor.black.cgColor
        //rectView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        rectView.layer.masksToBounds = false
        rectView.layer.shadowOffset = CGSize(width: 0, height: 3)
        rectView.layer.shadowRadius = 3
        rectView.layer.shadowOpacity = 0.2
        
        contentView.addSubview(rectView)
    }
    
    func setupSportLabel() {
        sportLabel = UILabel(frame: CGRect(x: monthLabel.frame.maxX + 10, y: rectView.frame.height / 2 - 30, width: 0, height: 0))
        sportLabel.font = UIFont(name: "Lato-Medium", size: 16.0)
        sportLabel.textColor = UIColor.black
        sportLabel.text = sport
        sportLabel.sizeToFit()
        rectView.addSubview(sportLabel)
    }
    
    
    func setUpImage() {
        pic = UIImageView(frame: CGRect(x: 0, y: 4, width: contentView.frame.width, height: contentView.frame.height - 8))
        pic.layer.shadowColor = UIColor.black.cgColor
        pic.layer.shadowOpacity = 1
        pic.layer.shadowOffset = CGSize(width: 0, height: 3)
        pic.layer.shadowRadius = 1.5
        //        pic.contentMode = .scaleAspectFill
        //        pic.layer.masksToBounds = true
        contentView.addSubview(pic)
        //insert gray layer
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        layer.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.0).cgColor
        contentView.layer.insertSublayer(layer, at: 10)
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
        atLabel = UILabel(frame: CGRect(x: rectView.frame.width / 2 - 2, y: sportLabel.frame.minY - 3, width: 20, height: 24))
        atLabel.text = "@"
        atLabel.textColor = UIColor.black
        atLabel.textAlignment = NSTextAlignment.center
        atLabel.font = UIFont(name: "Lato-Medium", size: 22.0)
        
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
        
        print("FUCKING SPORT: ", author)
        
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
        
        locationLabel = UILabel(frame: CGRect(x: rectView.frame.width / 2, y: sportLabel.frame.minY, width: rectView.frame.width / 2 - 15, height: 24))
        locationLabel.textAlignment = NSTextAlignment.right
        
        locationLabel.text = location
        locationLabel.textColor = UIColor.black
        locationLabel.font = UIFont(name: "Lato-Medium", size: 18.0)
        
        rectView.addSubview(locationLabel)
    }
    
    func setUpDescriptionLabel() {
        descriptionLabel = UILabel(frame: CGRect(x: numGoingLabel.frame.maxX + 5, y: numGoingLabel.frame.minY, width: rectView.frame.width - numGoingLabel.frame.maxX - 20, height: 15))
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont(name: "Lato-Light", size: 12.0)
        descriptionLabel.textAlignment = NSTextAlignment.right
        descriptionLabel.text = eventDescription
        rectView.addSubview(descriptionLabel)
    }
    
    func setupGoingLabel() {
        numGoingLabel = UILabel(frame: CGRect(x: dayLabel.frame.minX, y: dayLabel.frame.maxY + 5, width: 0, height: 15))
        numGoingLabel.font = UIFont(name: "Lato-Light", size: 12.0)
//        numGoingLabel.text = String(2) + " going"   //String(numGoing)
        
        rectView.addSubview(numGoingLabel)
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
    
    func initContactButton() {
        contactButton = UIButton(frame: CGRect(x: rectView.frame.minX, y: rectView.frame.maxY - 40, width: rectView.frame.width / 2, height: 40))
        contactButton.setTitle("Comment", for: .normal)
        contactButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 14.0)
        contactButton.setTitleColor(UIColor.black, for: .normal)
        contactButton.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        
        contactButton.contentHorizontalAlignment = .center
        
        contentView.addSubview(contactButton)
    }
    
    func initJoinButton() {
        joinButton = UIButton(frame: CGRect(x: contactButton.frame.maxX, y: rectView.frame.maxY - 40, width: rectView.frame.width / 2, height: 40))
        joinButton.setTitle("Join", for: .normal)
        joinButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 14.0)
        joinButton.setTitleColor(UIColor.black, for: .normal)
        
        joinButton.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        
        joinButton.contentHorizontalAlignment = .center
        
        contentView.addSubview(joinButton)
    }
}
