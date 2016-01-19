//
//  ProfilePasswordEditViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 4/26/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class ProfilePasswordEditViewController:UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = EDIT_PASSWORD
    }
    
    @IBAction func saveClicked(sender: AnyObject) {
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        var user = PFUser.currentUser()
        
        if count(password) == 0 {
            HudUtil.displayErrorHUD(self.view, displayText: "Password must be set", displayTime: 1.5)
            return
        }
        if count(confirmPassword) == 0 || password != confirmPassword {
            HudUtil.displayErrorHUD(self.view, displayText: "Passwords do not match", displayTime: 1.5)
            return
        }
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Saving...."
        
        user[PF_USER_PASSWORD] = password
        user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
            hud.hide(true)
            if error == nil {
                HudUtil.displaySuccessHUD(self.view, displayText: "Saved", displayTime: 1.5)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                HudUtil.displayErrorHUD(self.view, displayText: "Email is already taken or network error", displayTime: 1.5)
            }
        })
    }
}
