//
//  SignUpViewController.m
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if([UIScreen mainScreen].bounds.size.height == 568){
        self.backgroundImageView.image = [UIImage imageNamed:@"loginBackground"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButton:(id)sender{
    //Gets text input from fields and checks for white spaces
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstName = [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastName = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *hometown = [self.hometownField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Display progress bar
    UIActivityIndicatorView *progressBar = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    progressBar.color = [UIColor blackColor];
    progressBar.center = [self.view center];
    [self.view addSubview:progressBar];
    [self.view bringSubviewToFront:progressBar];
    progressBar.hidden = NO;
    progressBar.hidesWhenStopped = YES;
    [progressBar startAnimating];

    
    //Display an error alert message if any field is empty
    if([username length] == 0 || [password length] == 0 || [email length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a valid username, password, and email address!" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
        
        [alertView show];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //Creates a new user and saves it into Parse back-end
            PFUser *newUser = [PFUser user];
            newUser.username = username;
            newUser.password = password;
            newUser.email = email;
            newUser[@"firstName"] = firstName;
            newUser[@"lastName"] = lastName;
            newUser[@"hometown"] = hometown;
            
            //This method is a BLOCK - primarily used for callback for ASYNCHRONOUS tasks that run ALONGSIDE the main thread
                [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    //Checks to see if there was an error in signup process
                    if(error){
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [progressBar stopAnimating];
                        [alertView show];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //Runs when asynchronous task has finished running (Signing up) in the back-end
                            //Navigates back to inbox (rootView of navigation controller)
                            [progressBar stopAnimating];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                    }
                    
                }];
        });
        
        //All other code are SEQUENTIAL tasks that run in order of execution on the MAIN THREAD;
    }
}

- (IBAction)dismissButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
