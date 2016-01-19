//
//  GroupsCell.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/26/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit

class GroupsCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet var courseLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
//    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var nextMeetingLabel: UILabel!
    
    @IBOutlet var moreImageView: UILabel!
    @IBOutlet var avatarImageViews: [PFImageView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    func bindData(group: PFObject) {
        var currentUser = PFUser.currentUser()
        self.courseLabel.text = group[PF_GROUP_COURSE_NAME] as? String
        self.nameLabel.text = group[PF_GROUP_NAME] as? String
        var date = group[PF_GROUP_DATETIME] as? NSDate
        var location = group[PF_GROUP_LOCATION] as? String
        var dateSet = (date != nil)
        var locationSet = (location != nil && count(location!) > 0)
        let todayDate = NSDate()
        
        if dateSet {
            let dateText = JSQMessagesTimestampFormatter.sharedFormatter().relativeDateForDate(date)
            if dateText == "Today" {
                self.dateTimeLabel.text = JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(date)
                self.dateTimeLabel.textColor = UIColor.blueColor()
            } else {
                if date?.compare(todayDate) == NSComparisonResult.OrderedAscending { /* meeting date is past */
                    self.nextMeetingLabel.text = "Last Meeting:"
                }
                self.dateTimeLabel.text = dateText.substringToIndex(dateText.rangeOfString(",")!.startIndex) //year is preceded by a colon
                self.dateTimeLabel.textColor = UIColor.blackColor()
            }
        } else {
            self.dateTimeLabel.removeFromSuperview()
        }
        
        if locationSet {
            self.locationLabel.text = location
            
        }
        
        if !dateSet && !locationSet {
            self.nextMeetingLabel.text = ""
            self.dateTimeLabel.text = ""
            self.locationLabel.text = ""
        }
        
        let users = group[PF_GROUP_USERS] as! [PFUser]!
        
        if users.count > self.avatarImageViews.count {
            self.moreImageView.hidden = false
            let moreCount = users.count - self.avatarImageViews.count
            self.countLabel.text = "+\(moreCount)"
            self.moreImageView.layer.cornerRadius = CGFloat(15.0)
            self.moreImageView.clipsToBounds = true
        } else {
            self.moreImageView.hidden = true
        }
        
        for i in 0..<self.avatarImageViews.count {
            if i < users.count {
                self.avatarImageViews[i].layer.cornerRadius = self.avatarImageViews[i].frame.size.width / 2
                self.avatarImageViews[i].layer.masksToBounds = true
                self.avatarImageViews[i].image = UIImage(named: "profile_blank") //placeholder image
                
                let user = users[i]
                let picFile = user[PF_USER_PICTURE] as? PFFile
                picFile?.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.avatarImageViews[i].image = UIImage(data:imageData)
                        }
                    }
                }
            }
        }
    }
    
    func clear() {
        self.courseLabel.text = ""
        self.nameLabel.text = ""
        self.nextMeetingLabel.text = "Next Meeting:"
        self.dateTimeLabel.text = ""
        self.locationLabel.text = ""
        for i in 0..<self.avatarImageViews.count {
            self.avatarImageViews[i].image = nil
        }
        self.moreImageView.hidden = false
        self.countLabel.text = ""
    }

}
