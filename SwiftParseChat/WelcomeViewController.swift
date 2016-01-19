//
//  WelcomeViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/21/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Signing in..."
        PFFacebookUtils.logInWithPermissions(["public_profile", "email", "user_friends", "user_education_history"], block: { (user: PFUser!, error: NSError!) -> Void in
            hud.hide(true)
            if user != nil {
                if user[PF_USER_FACEBOOKID] == nil {
                    self.requestFacebook(user)
                } else {
                    self.userLoggedIn(user)
                }
            } else {
                if error != nil {
                    println(error)
                    if let info = error.userInfo {
                        println(info)
                    }
                }
                HudUtil.displayErrorHUD(self.view, displayText: "Failed to sign in with Facebook", displayTime: 1.5)
            }
        })
    }
    
    func hasDukeEducation(userData: [String: AnyObject]!) -> Bool {
        println(userData["education"] as! NSArray)
        for object in userData["education"] as! NSArray {
            let dict = object as! NSDictionary
            println(dict["school"])
            if let school = dict["school"] as? NSDictionary {
                println(school["name"])
                if let schoolName = school["name"] as? String {
                    if schoolName.lowercaseString.rangeOfString("duke") != nil {
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    func requestFacebook(user: PFUser) {
        var request = FBRequest.requestForMe()
        request.startWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                var userData = result as! [String: AnyObject]!
                self.processFacebook(user, userData: userData)
//                if (self.hasDukeEducation(userData)) {
//                    self.processFacebook(user, userData: userData)
//                }
//                else {
//                    PFUser.logOut()
//                    ProgressHUD.showError("Please authenticate with Duke NetID")
//                }
            } else {
                PFUser.logOut()
                HudUtil.displayErrorHUD(self.view, displayText: "Failed to fetch Facebook user data", displayTime: 1.5)
            }
        }
    }
    
    func processFacebook(user: PFUser, userData: [String: AnyObject]) {
        let facebookUserId = userData["id"] as! String
        var link = "http://graph.facebook.com/\(facebookUserId)/picture"
        let url = NSURL(string: link)
        var request = NSURLRequest(URL: url!)
        let params = ["height": "200", "width": "200", "type": "square"]
        Alamofire.request(.GET, link, parameters: params).response() {
            (request, response, data, error) in
            
            if error == nil {
                var image = UIImage(data: data! as! NSData)!
                
                if image.size.width > 280 {
                    image = Images.resizeImage(image, width: 280, height: 280)!
                }
                var filePicture = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image, 0.6))
                filePicture.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                    if error != nil {
                        HudUtil.displayErrorHUD(self.view, displayText: "Failed to save photo", displayTime: 1.5)
                    }
                })
                
                if image.size.width > 60 {
                    image = Images.resizeImage(image, width: 60, height: 60)!
                }
                var fileThumbnail = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image, 0.6))
                fileThumbnail.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                    if error != nil {
                        HudUtil.displayErrorHUD(self.view, displayText: "Failed to save thumbnail", displayTime: 1.5)
                    }
                })
                
                user[PF_USER_EMAIL] = userData["email"]
                user[PF_USER_EMAILCOPY] = userData["email"]
                user[PF_USER_FULLNAME] = userData["name"]
                user[PF_USER_FULLNAME_LOWER] = (userData["name"] as! String).lowercaseString
                user[PF_USER_FACEBOOKID] = userData["id"]
                user[PF_USER_PICTURE] = filePicture
                user[PF_USER_THUMBNAIL] = fileThumbnail
                user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                    if error == nil {
                        self.userLoggedIn(user)
                    } else {
                        PFUser.logOut()
                        if let info = error!.userInfo {
                            HudUtil.displayErrorHUD(self.view, displayText: "Failed to login", displayTime: 1.5)
                            println(info["error"] as! String)
                        }
                    }
                })
            } else {
                PFUser.logOut()
                if let info = error!.userInfo {
                    HudUtil.displayErrorHUD(self.view, displayText: "Failed to fetch Facebook photo", displayTime: 1.5)
                    println(info["error"] as! String)
                }
            }
        }
    }
    
    func userLoggedIn(user: PFUser) {
        PushNotication.parsePushUserAssign()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
