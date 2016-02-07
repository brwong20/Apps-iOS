//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Brian Wong on 9/14/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

import UIKit

extension UdacityClient{

    //If this method's completion handler is set to true, our LoginViewController presents our tab controller
    func authenticateWithViewController(hostViewController: UIViewController, username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.loginWithInfo(username: username, password: password) { (success, errorString) in
            if success{
                completionHandler(success: true, errorString: nil)
            }else{
                completionHandler(success: false, errorString: "Authentication Error")
            }
        }
    }
    
    func loginWithInfo(username username: String?, password: String?, completionHandler: (success: Bool, errorString: String?) -> Void){
        
        let jsonBody: [String:[String:AnyObject]] = [
            JSONBodyKeys.Udacity:[
                JSONBodyKeys.Username : username!,
                JSONBodyKeys.Password : password!
            ]
        ]
        
        let task = taskForLogin(jsonBody, completionHandler: { (result, error) -> Void in
            if let error = error{
                print("Login Error (Couldn't authenticate)")
                print(error)
            }else{
                if let loginSuccess: AnyObject = result{
                    let validUser = loginSuccess.valueForKey(JSONResponseKeys.AccountLogin) as? NSDictionary
                    if (validUser != nil){
                        
                        //Used to retrieve public user data to pass to Parse
                        self.userID = loginSuccess.valueForKey(JSONResponseKeys.AccountLogin)!.valueForKey(JSONResponseKeys.UserID) as? String //User ID for Parse API
                        
                        completionHandler(success: true, errorString: nil)
                    }else{
                        //Invalid username/password
                        completionHandler(success: false, errorString: nil)
                        print("Could not find account")
                    }
                }
            }
        })
    }
}