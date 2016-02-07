//
//  LoginViewController.h
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
- (IBAction)signUpButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end