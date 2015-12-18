//
//  ViewController.swift
//  GroupMeTest
//
//  Created by Brian Lin on 12/15/15.
//  Copyright © 2015 Brian Lin. All rights reserved.
//

// use: "let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate" to access the ACCESS_TOKEN variable of AppDelegate in other files like ViewController


import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var GroupMeLogin: UIButton!
    // Sends user to GroupMe login page within the browser 
    @IBAction func requestGroupMeAccess(sender: AnyObject) {
        let authURL = NSURL(string: "https://oauth.groupme.com/oauth/authorize?client_id=PbjA37nq8pWpjuHDALASadyhVccu3STL4Vj5DrjpZLooTwK6")
        UIApplication.sharedApplication().openURL(authURL!)
        print("buttonpressed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

