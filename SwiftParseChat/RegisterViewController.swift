//
//  RegisterViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/21/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import SHEmailValidator
import MBProgressHUD

class RegisterViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: SHEmailValidationTextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        self.tableView?.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nameField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else if textField == confirmPasswordField {
            self.register()
        }
        return true
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        self.register()
    }
    
    func register() {
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        
        if count(name) == 0 {
            HudUtil.displayErrorHUD(view, displayText: "Name must be set", displayTime: 1.5)
            return
        }
        if !Utilities.validateEmail(emailField.text, view: self.view) {
            return
        }
        if count(password) == 0 {
            HudUtil.displayErrorHUD(view, displayText: "Password must be set", displayTime: 1.5)
            return
        }
        if count(confirmPassword) == 0 || password != confirmPassword {
            HudUtil.displayErrorHUD(view, displayText: "Passwords do not match", displayTime: 1.5)
            return
        }
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Registering...."
        
        var user = PFUser()
        user.username = email
        user.password = password
        user.email = email
        user[PF_USER_EMAILCOPY] = email
        user[PF_USER_FULLNAME] = name
        user[PF_USER_FULLNAME_LOWER] = name.lowercaseString
        user.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            hud.hide(true)
            if error == nil {
                PushNotication.parsePushUserAssign()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                if let userInfo = error.userInfo {
                    HudUtil.displayErrorHUD(self.view, displayText: userInfo["error"] as! String, displayTime: 1.5)
                }
            }
        }
    }
}
