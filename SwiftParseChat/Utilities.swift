//
//  Utilities.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/20/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation
import SHEmailValidator

class Utilities {
    
    class func loginUser(target: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewControllerWithIdentifier("navigationVC") as! UINavigationController
        target.presentViewController(welcomeVC, animated: true, completion: nil)
        
    }
    
    class func postNotification(notification: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
    }
    
    class func timeElapsed(seconds: NSTimeInterval) -> String {
        var elapsed: String
        if seconds < 60 {
            elapsed = "Just now"
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds / 60)
            let suffix = (minutes > 1) ? "mins" : "min"
            elapsed = "\(minutes) \(suffix) ago"
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            let suffix = (hours > 1) ? "hours" : "hour"
            elapsed = "\(hours) \(suffix) ago"
        }
        else {
            let days = Int(seconds / (24 * 60 * 60))
            let suffix = (days > 1) ? "days" : "day"
            elapsed = "\(days) \(suffix) ago"
        }
        return elapsed
    }
    
    class func isIdenticalPFObject(obj1:PFObject, obj2:PFObject) -> Bool {
        if  obj1.parseClassName == obj2.parseClassName && obj1.objectId == obj2.objectId {
            return true
        }
        return false
    }
    
    class func getFormattedTextFromDate(date:NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(date)
    }
    
    class func isSpring(month:Int) -> Bool {
        return month >= 1 && month <= 5
    }
    
    class func isSummer(month:Int) -> Bool {
        return month >= 6 && month <= 8
    }
    
    class func isFall(month:Int) -> Bool {
        return month >= 9 && month <= 12
    }
    
    class func getSemesterCode() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
        let month = components.month
        let year = components.year
        var seasonCode = ""
        if isSpring(month) {
            seasonCode = "SPRING"
        } else if isSummer(month) {
            seasonCode = "SUMMER"
        } else if isFall(month) {
            seasonCode = "FALL"
        }
        var yearStr = String(year)
        var yearCode = (yearStr as NSString).substringFromIndex(2)
        var semesterCode = seasonCode + yearCode
        return semesterCode
    }
    
    class func resizeImage(image:UIImage, newSize: CGSize) -> UIImage {
        let hasAlpha = false
        let scale:CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(newSize, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    class func validateEmail(email:String, view: UIView!) -> Bool {
        var error: NSError?
        let validator = SHEmailValidator()
        validator.validateSyntaxOfEmailAddress(email, withError: &error)
        if error != nil {
            let code = error?.code
            switch UInt32(code!) {
            case SHBlankAddressError.value:
                HudUtil.displayErrorHUD(view, displayText: "Email must be set", displayTime: 1.0)
                break
//            case SHInvalidSyntaxError.value:
//                ProgressHUD.showError("Email has invalid syntax")
//                break
//            case SHInvalidUsernameError.value:
//                ProgressHUD.showError("Email local portion is invalid")
//                break
//            case SHInvalidDomainError.value:
//                ProgressHUD.showError("Email domain is invalid")
//                break
//            case SHInvalidTLDError.value:
//                ProgressHUD.showError("Email TLD is invalid")
//                break
            default:
                HudUtil.displayErrorHUD(view, displayText: "Invalid Email", displayTime: 1.0)
                break
            }
        } else {
            return true
        }
        return false
    }
}

