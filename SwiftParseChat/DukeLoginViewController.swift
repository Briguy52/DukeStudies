//
//  DukeLoginViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/21/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import MBProgressHUD

class DukeLoginViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var netIdField: UITextField!
    @IBOutlet var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        self.netIdField.delegate = self
        self.passwordField.delegate = self
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.netIdField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.netIdField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.login()
        }
        return true
    }

    @IBAction func loginButtonPressed(sender: UIButton) {
        self.login()
    }
    
    func login() {
        let netId = netIdField.text.lowercaseString
        let password = passwordField.text
        
        if count(netId) == 0 {
            HudUtil.displayErrorHUD(self.view, displayText: "NetID field is empty", displayTime: 1.5)
            return
        } else {
            HudUtil.displayErrorHUD(self.view, displayText: "Password field is empty", displayTime: 1.5)
        }
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Signing in..."
        
        //        PFUser.logInWithUsernameInBackground(email, password: password) { (user: PFUser!, error: NSError!) -> Void in
        //            hud.hide(true)
        //            if user != nil {
        //                PushNotication.parsePushUserAssign()
        //                ProgressHUD.showSuccess("Welcome back, \(user[PF_USER_FULLNAME])!")
        //                self.dismissViewControllerAnimated(true, completion: nil)
        //            } else {
        //                if let info = error.userInfo {
        //                    ProgressHUD.showError(info["error"] as String)
        //                }
        //            }
        //        }
    }
}
