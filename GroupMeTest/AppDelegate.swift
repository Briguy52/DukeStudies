//
//  AppDelegate.swift
//  GroupMeTest
//
//  Created by Brian Lin on 12/15/15.
//  Copyright © 2015 Brian Lin. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var ACCESS_TOKEN: String!
    var ADMIN_TOKEN: String! = "mKwo1rVF68TzCEVzXT4RTkjG6fl0gnRnyYqPWgDK"
    
    
    // Add handleOpenURL function- will call this function everytime the app is opened from a URL
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let urlString = url.query // take in String https://YOUR_CALLBACK_URL/?access_token=ACCESS_TOKEN
        let queryArray = urlString!.componentsSeparatedByString("=") // split url like Java's String.split()
        ACCESS_TOKEN = queryArray[1]; // should contain ACCESS TOKEN only
        print(ACCESS_TOKEN);
        
        // Make group with ADMIN_TOKEN
//        let parameters: [String: AnyObject] = ["name":"Test 3", "share":true]
//        Alamofire.request(.POST, "https://api.groupme.com/v3/groups?token=" + ADMIN_TOKEN, parameters: parameters, encoding: .JSON).responseJSON { response in
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//            
//            
//            
//           
//            }
        
        
        Alamofire.request(.GET, "https://api.groupme.com/v3/groups/18621904?token=" + ACCESS_TOKEN)
            .responseJSON { response in
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
                if let test = response.result.value {
                    print("test: \(test["response"]!!["group_id"])") // Use this format to parse JSON!! 
                    
                }
        }
        
        return true;
        //TODO: Add bad request check?
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

