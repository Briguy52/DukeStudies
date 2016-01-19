//
//  ChatSettingsViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 3/27/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Foundation
import EventKit

class ChatSettingsViewController: UITableViewController, UIActionSheetDelegate, SelectSingleViewControllerDelegate, SelectMultipleViewControllerDelegate, AddressBookViewControllerDelegate, FacebookFriendsViewControllerDelegate, UIAlertViewDelegate {

    let actionItems = [EDIT_GROUP_NAME, EDIT_DESCRIPTION, EDIT_TIME, EDIT_LOCATION, SAVE_TO_CALENDAR, NOTIFY_ACTION, LEAVE_ACTION]
    var members = [PFUser]()
    var group: PFObject!
    var editAttribute:String!
    
    var removedUser: PFUser!
    
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMembers()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func loadMembers() {
        if self.group != nil {
            self.navBar.title = self.group[PF_GROUP_COURSE_NAME] as? String
            let users = self.group[PF_GROUP_USERS] as! [PFUser]!
            self.members.removeAll()
            self.members.extend(users)
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* only support portrait */
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.members.count + 1
        case 1:
            return actionItems.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60.0
        }
        return 0.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { /* member secion */
            
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "newCell")
            if indexPath.row < self.members.count {
                var user = self.members[indexPath.row]
                cell.textLabel?.text = user[PF_USER_FULLNAME] as? String
                normalizeCell(cell)
                cell.accessoryType = UITableViewCellAccessoryType.None
                
                /* load user's picture */
                var userImageView = PFImageView()
                userImageView.file = user[PF_USER_PICTURE] as? PFFile
                userImageView.loadInBackground { (image: UIImage!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    }
                }
                if(userImageView.image == nil) {
                    cell.imageView?.image = UIImage(named: "profile_blank")
                } else {
                    cell.imageView?.image = userImageView.image
                }
                return cell
                
            } else { /* invite friends row */
                normalizeCell(cell)
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.imageView?.image = UIImage(named: "invite")
                cell.textLabel?.text = "Add People"
                return cell
            }
            
        } else { /* settings */
            
            var action = actionItems[indexPath.row]
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "newCell")
            cell.textLabel?.text = action
            cell.detailTextLabel?.text = "Not Set"
            
            switch (action) {
                
            case NOTIFY_ACTION:
                normalizeCell(cell)
                return cell
                
            case SAVE_TO_CALENDAR:
                normalizeCell(cell)
                return cell
                
            case LEAVE_ACTION:
                cell.textLabel?.textColor = UIColor.redColor()
                cell.detailTextLabel?.text = ""
                return cell
                
            case EDIT_GROUP_NAME:
                normalizeCell(cell)
                if self.group != nil {
                    if let name = self.group[PF_GROUP_NAME] as? String {
                        cell.detailTextLabel?.text = name
                    }
                }
                return cell
                
            case EDIT_LOCATION:
                normalizeCell(cell)
                if self.group != nil {
                    if let location = self.group[PF_GROUP_LOCATION] as? String {
                        cell.detailTextLabel?.text = location
                    }
                }
                return cell
                
            case EDIT_DESCRIPTION:
                normalizeCell(cell)
                if self.group != nil {
                    if let description = self.group[PF_GROUP_DESCRIPTION] as? String {
                        cell.detailTextLabel?.text = description
                    }
                }
                return cell
                
            case EDIT_TIME:
                normalizeCell(cell)
                if self.group != nil {
                    if let dateTime = self.group[PF_GROUP_DATETIME] as? NSDate {
                        let dateText = JSQMessagesTimestampFormatter.sharedFormatter().relativeDateForDate(dateTime)
                        cell.detailTextLabel?.text = dateText + " " + JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(dateTime)
                    }
                }
                return cell
                
            default:
                normalizeCell(cell)
                return cell
            }
            
        }
    }
    
    func normalizeCell(cell:UITableViewCell) {
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.detailTextLabel?.text = ""
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 { /* member section */
            if indexPath.row == self.members.count { /* add people part */
                showInviteActionSheet()
                
            } else { /* person profile */
                
            }
        } else { /* settings */
            var action = actionItems[indexPath.row]
            
            switch (action) {
            case LEAVE_ACTION:
                showLeaveDialog()
                break
            case NOTIFY_ACTION:
                break
            case SAVE_TO_CALENDAR:
                saveToCalendar()
                break
            case EDIT_TIME:
                self.editAttribute = action
                self.performSegueWithIdentifier("EditTimeSegue", sender: self)
                break
            default: /* text attribute settings */
                self.editAttribute = action
                self.performSegueWithIdentifier("EditTextSegue", sender: self)
                break
            }
        }
    }
    
    /* Swipe to bring up button delete member from group */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { /* member section */
            if editingStyle == UITableViewCellEditingStyle.Delete {
                removedUser = self.members[indexPath.row]
                deleteAlert()
            }
        }
    }
    
    func deleteAlert() {
        var alert = UIAlertView(title: "Are you sure you want to remove from this group?", message: "", delegate: self as UIAlertViewDelegate, cancelButtonTitle: "Cancel", otherButtonTitles: "Remove")
        
        alert.alertViewStyle = UIAlertViewStyle.Default
        alert.show()
    }
    
    /* UIAlertView Delegate */
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            let groupUsers = group[PF_GROUP_USERS] as! [PFUser]!
            
            if(contains(groupUsers, removedUser)) {
                group.removeObject(removedUser, forKey: PF_GROUP_USERS)
                
                group.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
                    if error == nil {
                        self.loadMembers()
                    } else {
                        HudUtil.displayErrorHUD(self.view, displayText: NETWORK_ERROR, displayTime: 1.5)
                        self.loadMembers()
                    }
                }
            }
        }
    }

    
    func saveToCalendar() {
        if group[PF_GROUP_DATETIME] == nil {
            HudUtil.displayErrorHUD(self.view, displayText: "Meeting time not set", displayTime: 1.5)
            return
        }
        
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
        case .Authorized:
            insertEvent(eventStore)
            break
        case .Denied:
            HudUtil.displayErrorHUD(self.view, displayText: "Access Denied", displayTime: 1.5)
            break
        case .NotDetermined:
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
                {[weak self] (granted: Bool, error: NSError!) -> Void in
                    if granted {
                        self!.insertEvent(eventStore)
                    } else {
                        HudUtil.displayErrorHUD(self!.view, displayText: "Access Denied", displayTime: 1.5)
                    }
                })
            break
        default:
            println("Case Default")
        }
    }
    
    func insertEvent(store: EKEventStore) {
        var event:EKEvent = EKEvent(eventStore: store)
        event.title = "\(self.group[PF_GROUP_NAME] as! String) (\(self.group[PF_GROUP_COURSE_NAME] as! String))"
        event.startDate = self.group[PF_GROUP_DATETIME] as? NSDate
        event.endDate = event.startDate.dateByAddingTimeInterval(60 * 60) //TODO: end date may be changed later
        event.notes = "Added from DukeStudies App"
        event.location = self.group[PF_GROUP_LOCATION] as? String
        event.calendar = store.defaultCalendarForNewEvents
        var error: NSError?
        let result = store.saveEvent(event, span: EKSpanThisEvent, error: &error)
        
        if result == false {
            if let theError = error {
                HudUtil.displayErrorHUD(self.view, displayText: "Failed", displayTime: 1.5)
            }
        } else {
            HudUtil.displaySuccessHUD(self.view, displayText: "Saved", displayTime: 1.5)
        }
    }
    
    func showInviteActionSheet() {
        var actionSheet: UIActionSheet!
        let user = PFUser.currentUser()
        if user[PF_USER_FACEBOOKID] == nil {
            actionSheet = UIActionSheet(title:nil, delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Single recipient", "Multiple recipients", "Address Book")
        } else {
            actionSheet = UIActionSheet(title:nil, delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Single recipient", "Multiple recipients", "Address Book", "Facebook Friends")
        }
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func showLeaveDialog() {
        var leaveAlert = UIAlertController(title: "Leave Group?", message:"You won't get any new messages", preferredStyle: UIAlertControllerStyle.Alert)
        leaveAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{ (action:UIAlertAction!) in
            println("Cancelled leave group")
        }))
        
        leaveAlert.addAction(UIAlertAction(title: "Leave", style: .Default, handler: { (action:UIAlertAction!) in
            self.removeSelfFromGroup()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        presentViewController(leaveAlert, animated: true, completion: nil)
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            switch buttonIndex {
            case 1:
                self.performSegueWithIdentifier("selectSingleSegue", sender: self)
            case 2:
                self.performSegueWithIdentifier("selectMultipleSegue", sender: self)
            case 3:
                self.performSegueWithIdentifier("addressBookSegue", sender: self)
            case 4:
                self.performSegueWithIdentifier("facebookFriendsSegue", sender: self)
            default:
                return
            }
        }
    }
    
    func removeSelfFromGroup() {
        self.group.removeObject(PFUser.currentUser(), forKey: PF_GROUP_USERS)
        self.group.saveInBackgroundWithBlock ({ (success: Bool, error: NSError!) -> Void in
            if error == nil {
                HudUtil.displaySuccessHUD(self.view, displayText: "Quitted group successfully", displayTime: 1.5)
            } else {
                HudUtil.displayErrorHUD(self.view, displayText: NETWORK_ERROR, displayTime: 1.5)
                println("%@", error)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditTextSegue" {
            let createVC = segue.destinationViewController as! GroupTextEditViewController
            createVC.group = self.group
            createVC.editAttribute = self.editAttribute
            
        } else if segue.identifier == "EditTimeSegue" {
            let createVC = segue.destinationViewController as! GroupDateEditViewController
            createVC.group = self.group
            createVC.editAttribute = self.editAttribute
            
        } else if segue.identifier == "selectSingleSegue" {
            let selectSingleVC = segue.destinationViewController.topViewController as! SelectSingleViewController
            selectSingleVC.delegate = self
            
        } else if segue.identifier == "selectMultipleSegue" {
            let selectMultipleVC = segue.destinationViewController.topViewController as! SelectMultipleViewController
            selectMultipleVC.delegate = self
            
        } else if segue.identifier == "addressBookSegue" {
            let addressBookVC = segue.destinationViewController.topViewController as! AddressBookViewController
            addressBookVC.delegate = self
            
        } else if segue.identifier == "facebookFriendsSegue" {
            let facebookFriendsVC = segue.destinationViewController.topViewController as! FacebookFriendsViewController
            facebookFriendsVC.delegate = self
        }
    }
    
    // MARK: - SelectSingleDelegate
    
    func didSelectSingleUser(user: PFUser) {
        var users = [PFUser]()
        users.append(user)
        joinGroup(users)
    }
    
    // MARK: - SelectMultipleDelegate
    
    func didSelectMultipleUsers(users: [PFUser]) {
        joinGroup(users)
    }
    
    // MARK: - AddressBookDelegate
    
    func didSelectAddressBookUser(user: PFUser) {
        var users = [PFUser]()
        users.append(user)
        joinGroup(users)
    }
    
    // MARK: - FacebookFriendsDelegate
    
    func didSelectFacebookUser(user: PFUser) {
        var users = [PFUser]()
        users.append(user)
        joinGroup(users)
    }
    
    func joinGroup(users: [PFUser]) {
        let groupUsers = group[PF_GROUP_USERS] as! [PFUser]!
        var addedUsers = [PFUser]()
        
        for user in users {
            if(!contains(groupUsers, user)) {
                group.addObject(user, forKey: PF_GROUP_USERS)
                addedUsers.append(user)
            }
        }
        group.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error == nil {
                self.loadMembers()
            } else {
                HudUtil.displayErrorHUD(self.view, displayText: NETWORK_ERROR, displayTime: 1.5)
                //undo join group
                for user in addedUsers {
                    self.group.removeObject(user, forKey: PF_GROUP_USERS)
                }
            }
        }
    }
}
