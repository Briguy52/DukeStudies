//
//  Constants.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/20/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation

/* TODO: Try struct format for constants */
struct Constants {
    struct PF {
        struct Installation {
            static let ClassName = "_Installation"
        }
    }
}

//let HEXCOLOR(c) = [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]

let DEFAULT_TAB							= 0

let MESSAGE_INVITE						= "Check out SwiftParseChat on GitHub: https://github.com/huyouare/SwiftParseChat"

/* Installation */
let PF_INSTALLATION_CLASS_NAME			= "_Installation"           //	Class name
let PF_INSTALLATION_OBJECTID			= "objectId"				//	String
let PF_INSTALLATION_USER				= "user"					//	Pointer to User Class

/* User */
let PF_USER_CLASS_NAME					= "_User"                   //	Class name
let PF_USER_OBJECTID					= "objectId"				//	String
let PF_USER_USERNAME					= "username"				//	String
let PF_USER_PASSWORD					= "password"				//	String
let PF_USER_EMAIL						= "email"                   //	String
let PF_USER_EMAILCOPY					= "emailCopy"               //	String
let PF_USER_FULLNAME					= "fullname"				//	String
let PF_USER_FULLNAME_LOWER				= "fullname_lower"          //	String
let PF_USER_FACEBOOKID					= "facebookId"              //	String
let PF_USER_PICTURE						= "picture"                 //	File
let PF_USER_THUMBNAIL					= "thumbnail"               //	File

/* Chat */
let PF_CHAT_CLASS_NAME					= "Chat"					//	Class name
let PF_CHAT_USER						= "user"					//	Pointer to User Class
let PF_CHAT_GROUPID						= "groupId"                 //	String
let PF_CHAT_TEXT						= "text"					//	String
let PF_CHAT_PICTURE						= "picture"                 //	File
let PF_CHAT_VIDEO						= "video"                   //	File
let PF_CHAT_CREATEDAT					= "createdAt"               //	Date

/* Group */
let PF_GROUP_CLASS_NAME                 = "Group"                    //	 Class name
let PF_GROUP_OBJECTID                   = "objectId"                 //	 String
let PF_GROUP_COURSE_NAME                = "courseName"               //  String
let PF_GROUP_NAME                       = "name"                     //	 String
let PF_GROUP_COURSEID                   = "courseId"                 //  String
let PF_GROUP_DESCRIPTION                = "description"              //  String
let PF_GROUP_LOCATION                   = "location"                 //  String
let PF_GROUP_DATETIME                   = "dateTime"                 //  Date
let PF_GROUP_USERS                      = "users"                    //  [PFUser]
let PF_GROUP_UPDATED_AT                 = "updatedAt"                //  Date

/* Messages*/
let PF_MESSAGES_CLASS_NAME				= "Messages"				//	Class name
let PF_MESSAGES_USER					= "user"					//	Pointer to User Class
let PF_MESSAGES_GROUPID					= "groupId"                 //	String
let PF_MESSAGES_DESCRIPTION				= "description"             //	String
let PF_MESSAGES_LASTUSER				= "lastUser"				//	Pointer to User Class
let PF_MESSAGES_LASTMESSAGE				= "lastMessage"             //	String
let PF_MESSAGES_COUNTER					= "counter"                 //	Number
let PF_MESSAGES_UPDATEDACTION			= "updatedAction"           //	Date

/* Notification */
let NOTIFICATION_APP_STARTED			= "NCAppStarted"
let NOTIFICATION_USER_LOGGED_IN			= "NCUserLoggedIn"
let NOTIFICATION_USER_LOGGED_OUT		= "NCUserLoggedOut"

/* Group Settings */
let NOTIFY_ACTION                       = "Notifications"
let SAVE_TO_CALENDAR                    = "Save to Calendar"
let LEAVE_ACTION                        = "Leave Group"
let EDIT_GROUP_NAME                     = "Group Name"
let EDIT_DESCRIPTION                    = "Description"
let EDIT_TIME                           = "Date & Time"
let EDIT_LOCATION                       = "Location"
let DISPLAY_COURSE_NAME                 = "courseName"

/* Profile Settings */
let EDIT_PROFILE_NAME                   = "Name"
let EDIT_PASSWORD                       = "Password"
let EDIT_EMAIL                          = "Email"
let SEND_FEEDBACK                       = "Feedback"

let EDIT_TEXT_SEGUE                     = "editTextSegue"
let EDIT_PASSWORD_SEGUE                 = "editPasswordSegue"
let SEND_FEEDBACK_SEGUE                 = "sendFeedbackSegue"

/* Error Messages */
let NETWORK_ERROR                       = "Connection Error"
let NETWORK_SUCCESS                     = "Success"


