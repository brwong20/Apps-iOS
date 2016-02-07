//
//  LoginViewController.m
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([UIScreen mainScreen].bounds.size.height == 568){
        self.backgroundImageView.image = [UIImage imageNamed:@"loginBackground"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpButton:(id)sender {
    [self performSegueWithIdentifier:@"showSignUp" sender:self];
}


- (IBAction)loginButton:(id)sender {
    //Gets text input from fields and checks for white spaces
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
    if([username length] == 0 || [password length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a valid username or password!" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
        [progressBar stopAnimating];
        [alertView show];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error){
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [progressBar stopAnimating];
                    });
                    
                    [alertView show];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [progressBar stopAnimating];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                }
                
            }];
        });
        
    }
}



@end