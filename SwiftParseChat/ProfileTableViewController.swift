//
//  ProfileTableViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 4/26/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation
import UIKit

protocol EditProfileDelegate {
    func didSelectProfileTableRow(segueID: String, action: String)
}

class ProfileTableViewController: UITableViewController {
    
    let actionItemsWithoutFB = [EDIT_PROFILE_NAME, EDIT_PASSWORD, SEND_FEEDBACK]
    let actionItemsWithFB = [EDIT_PROFILE_NAME, SEND_FEEDBACK]
    var delegate: EditProfileDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoginByFB() {
            return actionItemsWithFB.count
        } else {
            return actionItemsWithoutFB.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func isLoginByFB() -> Bool {
        var user = PFUser.currentUser()
        return user[PF_USER_FACEBOOKID] != nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var action: String!
        if isLoginByFB() {
            action = actionItemsWithFB[indexPath.row]
        } else {
            action = actionItemsWithoutFB[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = action
        cell.detailTextLabel?.text = "Not Set"
        var user = PFUser.currentUser()
        
        switch (action) {
        case EDIT_PROFILE_NAME:
            cell.detailTextLabel?.text = user[PF_USER_FULLNAME] as? String
            break
        case EDIT_EMAIL:
            cell.detailTextLabel?.text = user[PF_USER_EMAIL] as? String
            println(cell.detailTextLabel?.text)
            println(user[PF_USER_EMAIL] as? String)
            println(user[PF_USER_EMAIL])
            break
        default:
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var action:String!
        if isLoginByFB() {
            action = actionItemsWithFB[indexPath.row]
        } else {
            action = actionItemsWithoutFB[indexPath.row]
        }
        
        switch (action) {
        case EDIT_PROFILE_NAME:
            if self.delegate != nil {
                self.delegate.didSelectProfileTableRow(EDIT_TEXT_SEGUE, action: action)
            }
            break
        case EDIT_EMAIL:
            if self.delegate != nil {
                self.delegate.didSelectProfileTableRow(EDIT_TEXT_SEGUE, action: action)
            }
            break
        case EDIT_PASSWORD:
            if self.delegate != nil {
                self.delegate.didSelectProfileTableRow(EDIT_PASSWORD_SEGUE, action: action)
            }
            break
        case SEND_FEEDBACK:
            if self.delegate != nil {
                self.delegate.didSelectProfileTableRow(SEND_FEEDBACK_SEGUE, action: action)
            }
            break
        default:
            println("No profile attribute selected")
        }
    }
    
}
