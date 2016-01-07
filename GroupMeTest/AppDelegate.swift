//
//  AppDelegate.swift
//  GroupMeTest
//
//  Created by Brian Lin on 12/15/15.
//  Copyright © 2015 Brian Lin. All rights reserved.
//

import UIKit
import Alamofire
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var ACCESS_TOKEN: String! // This access token belongs to the user and will be used to join or leave groups that have been created already (user will never create a group)
    var ADMIN_TOKEN: String! = "Uy6V4BXpuvHDp6XUWZ0IkgSQojFRw1h3SRhAWoK6" // This access token corresponds to an admin account that we will use to create and track every single group
    var courseString = "Test1" // Placeholder Course String
    let baseURL = "https://api.groupme.com/v3" // Base String for all GroupMe API calls
    var joinURL = String() // URL for joining (mutable)
    
    // TODO: Make dedicated functions for:
    // 1. Creating a group
    // 2. Joining a group
    // 3. Checking for open group
    
    
    // Add handleOpenURL function- will call this function everytime the app is opened from a URL
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        // This code is for setting up PARSE
        Parse.setApplicationId("jy4MUG3yk2hLkU7NVTRRwQx1p5siV9BPwjr3410A",
            clientKey: "crnLPudofSLV9LmmydyAl2Eb8sJmlHi4Pd6HNtxW")
        
        // OAuth Login Parsing
        // CITE: Taken from Sam Wilskey's tutorial: http://samwilskey.com/swift-oauth/
        let urlString = url.query // take in String https://YOUR_CALLBACK_URL/?access_token=ACCESS_TOKEN
        let queryArray = urlString!.componentsSeparatedByString("=") // split url like Java's String.split()
        ACCESS_TOKEN = queryArray[1]; // should contain ACCESS TOKEN only
        //        print(ACCESS_TOKEN);

        self.checkForOpen(courseString)
        
        
        
        //        var groupID = String() // Store GroupID of newly created group
        //        var memberCount = Int() //
        //        var shareToken = String() // Store Share Token for Group
        
        //        let parameters: [String: AnyObject] = ["name":"Test", "share":true]
        
        //         This code SHOWS a group with the user's ACCESS_TOKEN
        //                Alamofire.request(.GET, "https://api.groupme.com/v3/groups/18779921?token=" + ACCESS_TOKEN) // SHOWS a group for a given groupID (hardcoded here)
        //        Alamofire.request(.POST, "https://api.groupme.com/v3/groups?token=" + ADMIN_TOKEN, parameters: parameters, encoding: .JSON) // CREATES a new group using above 'parameters' variable
        //                    .responseJSON { response in
        //                        if let test = response.result.value {
        //
        //                    print("Following 3 print statements come from Alamofire callback")
        //                    // Code for parsing Group ID
        //                    groupID = "\(test["response"]!!["group_id"]!!)"
        //                    print("Course String: " + self.courseString)
        //                    print("Group ID: " + groupID)
        //
        //                    // Code for parsing Share Token
        //                    var shareURL = test["response"]!!["share_url"]!!
        //                    var shareArray = shareURL.componentsSeparatedByString("/")
        //                    shareToken = shareArray[shareArray.count-1]
        //
        //                    // Code for finding number of members
        //                    memberCount = test["response"]!!["members"]!!.count
        //                    print("Member Count: " + String(memberCount))
        //
        //                }
        //        }
        return true;
    }
    
    // Helper function for finding open groups
    // Input: Class Name (String)
    // Output: /groups/:id/join/:share_token (String)
    func checkForOpen(myClass: String) -> Void {
        var objectID = String()
        var groupID = String()
        var shareToken = String()
        var maxMembers = 0
        
        // This code is for pulling stuff FROM PARSE
        // CITE: Taken from Parse's iOS Developers Guide: https://parse.com/docs/ios/guide#queries
        print("Receiving query from Parse")
        var query = PFQuery(className:myClass)
        query.whereKey("memberCount", lessThan: 7) // Max size pre add is 7 including Admin account
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) groups.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print("Object ID: " + object.objectId!)
                        print("Group ID: " + String(object["groupID"]))
                        print("Share Token: " + String(object["shareToken"]))
                        print("Member Count: " + String(object["memberCount"]))
                        
                        if object["memberCount"] as! Int > maxMembers {
                            objectID = object.objectId!
                            groupID = object["groupID"] as! String
                            shareToken = object["shareToken"] as! String
                            maxMembers = object["memberCount"] as! Int
                        }
                    }
                }

                self.checkEmpty(groupID, shareToken: shareToken, objID: objectID)
                
//              self.makeString(groupID, myToken: shareToken, objID: objectID)
            }
                
            else {
                // Log details of the failure
                // print("Error: \(error!) \(error!.userInfo)")
                // Should make a new group and add its info to Parse
                
                // Make a new group
                let parameters: [String: AnyObject] = ["name":myClass, "share":true]
                Alamofire.request(.POST, self.baseURL + "/groups?token=" + self.ADMIN_TOKEN, parameters: parameters, encoding: .JSON) // CREATES a new group using above 'parameters' variable
                    .responseJSON { response in
                        if let test = response.result.value {
                            // Code for parsing Group ID
                            groupID = "\(test["response"]!!["group_id"]!!)"
                            // Code for parsing Share Token
                            var shareURL = test["response"]!!["share_url"]!!
                            var shareArray = shareURL.componentsSeparatedByString("/")
                            shareToken = shareArray[shareArray.count-1]
                        }
                        
                }
                
                // Add new object to Parse
                // CITE: Taken from Parse's quick start tutorial: https://parse.com/apps/quickstart#parse_data/mobile/ios/swift/existing
                var testObject = PFObject(className: self.courseString)
                testObject["groupID"] = groupID
                testObject["shareToken"] = shareToken
                testObject["memberCount"] = 1
                testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        print("New group has been created and stored.")
                        self.makeString(groupID, shareToken: shareToken, objID: objectID) // Callback function
                    }
                    else {
                        print("Error has occurred in storing new group")
                        print(error)
                    }
                }
            }
        }
        
    }
    
    // Get group information for the group of interest
    // If empty, delete it and recall checkForOpen (empty = size 1 = only admin)
    // If not empty, calls makeString()
    func checkEmpty(groupID: String, shareToken: String, objID: String) -> Void {
        var memberCount = Int()
        Alamofire.request(.GET, self.baseURL + "/groups/" + groupID + "?token=" + self.ADMIN_TOKEN) // SHOW group information
            .responseJSON { response in
                if let test = response.result.value {
                    // Find number of members
                    memberCount = test["response"]!!["members"]!!.count
                    print("Member count of " + groupID + " in GroupeMe: " + String(memberCount))
                }
                if memberCount == 1 {
                    self.deleteGroup(groupID, objID: objID) //Delete group and recall checkForOpen()
                }
                else {
                    self.makeString(groupID, shareToken: shareToken, objID: objID) //Proceed to making the Alamofire request to join GroupMe group and updating Parse
                }
        }

    }
    
    // Delete group from both GroupMe and Parse
    func deleteGroup(groupID:String, objID:String) -> Void {
        //TODO: Delete from Parse
        var query = PFQuery(className:courseString)
        query.getObjectInBackgroundWithId(objID) {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                print("Error deleting group from Parse")
            } else if let object = object {
                object.deleteInBackground()
                print("Deleting " + groupID)
                Alamofire.request(.POST, self.baseURL + "/groups/" + groupID + "/destroy?token=" + self.ADMIN_TOKEN) // Delete from Alamofire
            }
            self.checkForOpen(self.courseString)
        }
    }
    
    // Prints a String
    func testFunc(myString: String) {
        print(myString)
    }
    
    // Callback function to be called by checkForOpen
    // Takes inputs of 'Share Token' and 'Group ID' and returns a URL String to be used in GroupMe JOIN calls
    // Output is of form: /groups/:id/join/:share_token (String)
    
    func makeString(groupID: String, shareToken: String, objID: String) -> Void {
        print("/groups/" + groupID + "/join/" + shareToken)
        self.joinURL = "/groups/" + groupID + "/join/" + shareToken
        joinGroup(joinURL, objID: objID)
    }
    
    // Helper function that joins a group
    // Inputs: output string from function 'makeString' and user's access token (ACCESS_TOKEN)
    // Output is boolean for success or fail
    
    func joinGroup(myRequest: String, objID: String) {
        
        // Add user to group
        Alamofire.request(.POST, self.baseURL + myRequest + "?token=" + self.ACCESS_TOKEN)
        print("Group Joined")
//            .responseJSON { response in
//                if let myResponse = response.result.value {
//                    if Int(myResponse["meta"]!!["code"]!! as! NSNumber) == 200 {
//                        return true
//                    }
//                    else {
//                        return false
//                    }
//                }
//        }
        
        // Update Parse's member count for that group
        var query = PFQuery(className:courseString)
        query.getObjectInBackgroundWithId(objID) {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let object = object {
                var temp: Int = object["memberCount"] as! Int
                object["memberCount"] = temp + 1
                object.saveInBackground()
            }
        }
    }

    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

