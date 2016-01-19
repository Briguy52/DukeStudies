//
//  CreateGroupTableViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/17/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit

class CreateGroupTableViewController: UITableViewController, UITextFieldDelegate {

    var course: [String: String]!
    var delegate: GroupSelectTableViewControllerDelegate!
    
    @IBOutlet var courseLabel: UILabel!
    @IBOutlet var groupNameField: UITextField!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var locationField: UITextField!
    
    @IBOutlet var dateTimeCell: UITableViewCell!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var noneButton: UIButton!
    
    var noneSelected = true
    var expanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        self.courseLabel.text = self.course["course_name"]
        self.noneButton.highlighted = true
        self.datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User actions
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func dateButtonPressed(sender: UIButton) {
        dateTimePressed()
    }

    func dateTimePressed() {
        self.noneSelected = false
        self.noneButton.highlighted = true
        self.dateButton.titleLabel?.alpha = 1.0
        self.datePicker.alpha = 1.0
        self.view.endEditing(true)
    }
    
    func datePickerChanged(datePicker: UIDatePicker) {
        dateTimePressed()
        self.dateButton.setTitle(Utilities.getFormattedTextFromDate(datePicker.date), forState: UIControlState.Normal)
    }
    
    @IBAction func noneButtonPressed(sender: UIButton) {
        self.noneSelected = true
        self.dateButton.highlighted = true
        self.dateButton.titleLabel?.alpha = 0.25
        self.datePicker.alpha = 0.25
        self.view.endEditing(true)
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func createGroupPressed(sender: AnyObject) {
        let groupName = groupNameField.text
        
        if count(groupName) > 0 {
            var group = PFObject(className: PF_GROUP_CLASS_NAME)
            group[PF_GROUP_NAME] = groupName
            group[PF_GROUP_COURSE_NAME] = self.course["course_name"]
            group[PF_GROUP_COURSEID] = self.course["course_id"]
            group[PF_GROUP_DESCRIPTION] = self.descriptionField.text
            group[PF_GROUP_LOCATION] = self.locationField.text
            if !self.noneSelected {
                group[PF_GROUP_DATETIME] = self.datePicker.date
            }
            group.addObject(PFUser.currentUser(), forKey: PF_GROUP_USERS)
            group.saveInBackgroundWithBlock ({ (success: Bool, error: NSError!) -> Void in
                if error == nil {
                    HudUtil.displaySuccessHUD(self.view, displayText: "Saved", displayTime: 1.5)
                    println("Group \(group[PF_GROUP_NAME]) created for class: \(group[PF_GROUP_COURSEID])")
                } else {
                HudUtil.displayErrorHUD(self.view, displayText: NETWORK_ERROR, displayTime: 1.5)
                    println("%@", error)
                }
            })
        } else {
            HudUtil.displayErrorHUD(self.view, displayText: "Group name field must not be empty", displayTime: 1.5)
            return
        }
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate 
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.groupNameField {
            self.descriptionField.becomeFirstResponder()
        } else if textField == self.descriptionField {
            self.locationField.becomeFirstResponder()
        } else if textField == self.locationField {
            self.view.endEditing(true)
        }
        return true
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
