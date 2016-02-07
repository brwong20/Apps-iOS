//
//  LoginViewController.swift
//  On The Map
//
//  Created by Brian Wong on 9/14/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{
    
    let clientInstance = UdacityClient.sharedInstance()
    let parseInstance = ParseClient.sharedInstance()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginButton.delegate = self
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        //Create the Facebook login button and configure
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        //Check for existing access token
        if(FBSDKAccessToken.currentAccessToken() == nil){
            print("Not logged into facebook")
        }else{
            print("Logged into facebook")
        }
        
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if(usernameField.text!.isEmpty || passwordField.text!.isEmpty){
            let alertView = UIAlertView(title: "Oops!", message: "Please enter both your username and password", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }else{
            self.loginUser()
        }
    }
    
    func loginUser(){
        self.clientInstance.authenticateWithViewController(self, username: usernameField.text!, password: passwordField.text!) { (success, errorString) -> Void in
            if success {
                self.completeLogin()
            } else {
                //Have to present on the main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alertView = UIAlertController(title: "Oops!", message: "The username and password combination you entered are incorrect! Please try again.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                })
            }
        }
    }
    
    //Present Tab Controller if POST method is successful
    func completeLogin(){
        parseInstance.userID = clientInstance.userID!
        MapViewController.facebookLogin = false
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    //MARK: - Facebook protocol methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil){
            //print(error.localizedDescription)
            print("Failed in fb login")
        }else{
           //Now, move to tab bar VC
            MapViewController.facebookLogin = true
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        
        }
        
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //...
    }
    
//    @IBAction func testButton(sender: UIButton) {
//        parseInstance.getStudentLocations { (success, locations, errorString) -> Void in
//            if success{
//                print(locations)
//            }
//        }
//    }
    
}