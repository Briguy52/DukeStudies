//
//  GroupDateEditViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 4/16/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Foundation

class GroupDateEditViewController:UIViewController {
    
    var group: PFObject!
    var editAttribute:String!
    var noneSelected = true
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var noneButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBAction func dateButtonPressed(sender: AnyObject) {
        dateTimePressed()
    }

    @IBAction func noneButtonPressed(sender: AnyObject) {
        nonePressed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = self.editAttribute
        self.datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
        if let dateTime = self.group[PF_GROUP_DATETIME] as? NSDate {
            dateTimePressed()
            updateDateButtonText(dateTime)
            self.datePicker.date = dateTime
        } else {
            nonePressed()
        }
    }
    
    func nonePressed() {
        self.noneSelected = true
        self.dateButton.highlighted = true
        self.dateButton.titleLabel?.alpha = 0.25
        self.datePicker.alpha = 0.25
        self.view.endEditing(true)
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
        updateDateButtonText(datePicker.date)
    }
    
    func updateDateButtonText(date:NSDate) {
        self.dateButton.setTitle(Utilities.getFormattedTextFromDate(date), forState: UIControlState.Normal)
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if !self.noneSelected {
            group[PF_GROUP_DATETIME] = self.datePicker.date
        } else {
            group[PF_GROUP_DATETIME] = NSNull()
        }
        
        self.group.saveInBackgroundWithBlock ({ (success: Bool, error: NSError!) -> Void in
            if error == nil {
                HudUtil.displaySuccessHUD(self.view, displayText: NETWORK_SUCCESS, displayTime: 1.5)
                println("Changed group's \(self.editAttribute)")
            } else {
                HudUtil.displayErrorHUD(self.view, displayText: NETWORK_ERROR, displayTime: 1.5)
                println("%@", error)
            }
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
}
