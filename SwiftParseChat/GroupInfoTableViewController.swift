//
//  GroupInfoTableViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 4/5/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit

class GroupInfoTableViewController: UITableViewController {
    
    var course: [String: String]!
    var selectedGroup: PFObject!
    var delegate: GroupSelectTableViewControllerDelegate!
    
    @IBOutlet var courseLabel: UILabel!
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionCell: UITableViewCell!
    @IBOutlet var dateTimeCell: UITableViewCell!
    @IBOutlet var locationCell: UITableViewCell!
    
    @IBOutlet var joinGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        self.courseLabel.text = self.selectedGroup[PF_GROUP_COURSE_NAME] as? String
        self.groupNameLabel.text = self.selectedGroup[PF_GROUP_NAME] as? String
        
        if let description = self.selectedGroup[PF_GROUP_DESCRIPTION] as? String {
            self.descriptionLabel.text = description
        } else {
            self.descriptionLabel.text = ""
        }
        
        if let dateTime = self.selectedGroup[PF_GROUP_DATETIME] as? NSDate {
            let dateText = JSQMessagesTimestampFormatter.sharedFormatter().relativeDateForDate(dateTime)
            if dateText == "Today" {
                dateTimeLabel.text = JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(dateTime)
            } else {
                dateTimeLabel.text = dateText
            }
        } else {
            self.dateTimeLabel.text = ""
        }
        
        if let location = self.selectedGroup[PF_GROUP_LOCATION] as? String {
            self.locationLabel.text = location
        } else {
            self.locationLabel.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User actions
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func joinButtonPressed(sender: AnyObject) {
            self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            if self.delegate != nil {
            self.delegate.joinGroup(self.selectedGroup)
            }
            })
    }

    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}

