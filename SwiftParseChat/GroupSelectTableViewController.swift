//
//  GroupSelectTableViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/17/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol GroupSelectTableViewControllerDelegate {
    func joinGroup(group: PFObject)
}

class GroupSelectTableViewController: UITableViewController {
    
    var course: [String: String]!
    var groups = [PFObject]()
    var selectedGroup: PFObject!
    var delegate: GroupSelectTableViewControllerDelegate!

    @IBOutlet var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadGroupData()
    }
    
    func loadGroupData() {
        if let subjectCode = course["subject_code"] {
            if let courseNumber = course["course_number"] {
                /* update navigation bar title */
                let titleString = subjectCode + " " + courseNumber
                self.navigationItem.title = titleString
                
                /* find groups for that course in Parse */
                var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                let courseId = Utilities.getSemesterCode() + subjectCode + courseNumber
                var query = PFQuery(className: PF_GROUP_CLASS_NAME)
                query.whereKey(PF_GROUP_COURSEID, equalTo: courseId)
                query.includeKey(PF_GROUP_USERS)
                
                query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                    hud.hide(true)
                    if error == nil {
                        self.groups.removeAll(keepCapacity: false)
                        for group in objects as! [PFObject]! {
                            self.groups.append(group)
                        }
                        self.refreshGroupTable()
                    } else {
                        HudUtil.displayErrorHUD(self.view, displayText: NETWORK_ERROR, displayTime: 1.5)
                        self.refreshGroupTable()
                    }
                })
                
                /* use strings as attributes */
                self.course["course_name"] = titleString
                self.course["course_id"] = courseId
            }
        }
    }
    
    func refreshGroupTable() {
        self.tableView.reloadData()
        /* show alternate view when no groups found */
        if self.groups.count > 0 {
            self.emptyView.hidden = true
        } else {
            self.emptyView.hidden = false
        }
    }
    
    func hasGroup(group:PFObject) -> Bool {
        for obj in self.groups {
            if Utilities.isIdenticalPFObject(obj, obj2: group) {
                return true
            }
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func createGroupButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("groupSelectToCreateSegue", sender: self)
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groups.count == 0 {
            return 0
        } else {
            return groups.count + 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == self.groups.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("newCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as! GroupsCell
        cell.bindData(self.groups[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.groups.count {
            self.performSegueWithIdentifier("groupSelectToCreateSegue", sender: self)
        }
        else {
            self.selectedGroup = self.groups[indexPath.row] as PFObject
            self.performSegueWithIdentifier("groupSelectToGroupInfoSegue", sender: self)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupSelectToCreateSegue" {
            let createVC = segue.destinationViewController as! CreateGroupTableViewController
            createVC.delegate = self.delegate
            createVC.course = self.course
        } else if segue.identifier == "groupSelectToGroupInfoSegue" {
            let groupInfoVC = segue.destinationViewController as! GroupInfoTableViewController
            groupInfoVC.delegate = self.delegate
            groupInfoVC.course = self.course
            groupInfoVC.selectedGroup = self.selectedGroup
        }
    }

}
