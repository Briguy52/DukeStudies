//
//  GroupViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/20/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import MBProgressHUD
// Parse loaded from SwiftParseChat-Bridging-Header.h

class GroupsViewController: UITableViewController, UIAlertViewDelegate, GroupSelectTableViewControllerDelegate {
    
    var groups: [PFObject]! = []
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 120.0;

        if PFUser.currentUser() != nil {
            self.loadGroups()
        }
        else {
            Utilities.loginUser(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGroups() {
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var query = PFQuery(className: PF_GROUP_CLASS_NAME)
        query.whereKey(PF_GROUP_USERS, equalTo: PFUser.currentUser())
        query.orderByDescending(PF_GROUP_UPDATED_AT) //may consider number of users (popularity) as well
        query.includeKey(PF_GROUP_USERS)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!)  in
            hud.hide(true)
            if error == nil {
                self.groups.removeAll()
                self.groups.extend(objects as! [PFObject]!)
                self.tableView.reloadData()
            } else {
                HudUtil.displayErrorHUD(self.view, displayText: NETWORK_ERROR, displayTime: 1.5)
                println(error)
            }
        }
    }
    
    /* // Old function
    func actionNew() {
        var alert = UIAlertView(title: "Please enter a name for your group", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            var textField = alertView.textFieldAtIndex(0);
            if let text = textField!.text {
                if count(text) > 0 {
                    var object = PFObject(className: PF_GROUP_CLASS_NAME)
                    object[PF_GROUP_NAME] = text
                    object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                        if success {
                            self.loadGroups()
                        } else {
                            ProgressHUD.showError("Network error")
                            println(error)
                        }
                    })
                }
            }
        }
    }
    */
    
    // MARK: - TableView Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as! GroupsCell
        cell.clear()
        cell.bindData(self.groups[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var group = self.groups[indexPath.row]
        let groupId = group.objectId as String
        
        Messages.createMessageItem(PFUser(), groupId: groupId, description: group[PF_GROUP_NAME] as! String)
        
        self.performSegueWithIdentifier("groupChatSegue", sender: groupId)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupChatSegue" {
            let chatVC = segue.destinationViewController as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        } else if segue.identifier == "groupsToSubjectSegue" {
            let subjectVC = segue.destinationViewController.topViewController as! SubjectTableViewController
            subjectVC.delegate = self
        }
    }
    
    // MARK: - GroupSelectTableViewController Delegate
    
    func joinGroup(group: PFObject) {
        let users = group[PF_GROUP_USERS] as! [PFUser]!
        
        if(!contains(users, PFUser.currentUser())) {
            group.addObject(PFUser.currentUser(), forKey: PF_GROUP_USERS)
            group.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
                if error == nil {
                    self.loadGroups()
                } else {
                    HudUtil.displayErrorHUD(self.view, displayText: NETWORK_ERROR, displayTime: 1.5)
                }
            }
        }
    }
}
