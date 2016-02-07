//
//  SignUpViewController.h
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *hometownField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)signUpButton: (id)sender;
- (IBAction)dismissButton:(id)sender;

@end
