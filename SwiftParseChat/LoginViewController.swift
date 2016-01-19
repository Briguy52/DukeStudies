//
//  LoginViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/22/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var emailField: UITextField! {
        didSet { self.emailField.delegate = self }
    }
    @IBOutlet var passwordField: UITextField! {
        didSet { self.passwordField.delegate = self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        tableView?.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            login()
        }
        return true
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        login()
    }
    
    func login() {
        let email = emailField.text.lowercaseString
        let password = passwordField.text
        
        if count(email) == 0 {
            HudUtil.displayErrorHUD(view, displayText: "Email field is empty.", displayTime: 1.5)
            return
        }
        
        if count(password) == 0 {
            HudUtil.displayErrorHUD(view, displayText: "Password field is empty.", displayTime: 1.5)
            return
        }

        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Signing in..."
        PFUser.logInWithUsernameInBackground(email, password: password) { (user: PFUser!, error: NSError!) -> Void in
            hud.hide(true)
            if user != nil {
                PushNotication.parsePushUserAssign()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                if let info = error.userInfo {
                    HudUtil.displayErrorHUD(self.view, displayText: info["error"] as! String, displayTime: 1.5)
                }
            }
        }
    }
}
