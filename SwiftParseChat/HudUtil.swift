//
//  HudUtil.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 5/9/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation
import MBProgressHUD

class HudUtil {
    
    class func displayAlertHUDWithImage(view: UIView!, imageName: String, displayText: String, displayTime: Double) {
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = MBProgressHUDModeCustomView
        let image = UIImage(named: imageName)
        //let imageResized = Utilities.resizeImage(image!, newSize: CGSizeMake(40.0, 40.0))
        hud.customView = UIImageView(image: image)
        hud.labelText = displayText
        hud.hide(true, afterDelay: displayTime)
    }
    
    class func displayAlertHUD(view: UIView!, displayText: String, displayTime: Double) {
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = MBProgressHUDModeText
        hud.labelText = displayText
        hud.hide(true, afterDelay: displayTime)
    }
    
    class func displayErrorHUD(view: UIView!, displayText: String, displayTime: Double) {
        HudUtil.displayAlertHUDWithImage(view, imageName: "error", displayText: displayText, displayTime: displayTime)
    }
    
    class func displaySuccessHUD(view: UIView!, displayText: String, displayTime: Double) {
        HudUtil.displayAlertHUDWithImage(view, imageName: "checkmark_filled", displayText: displayText, displayTime: displayTime)
    }
}