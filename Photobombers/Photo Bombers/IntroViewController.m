//
//  IntroViewController.m
//  Photo Bombers
//
//  Created by Brian Wong on 8/19/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "IntroViewController.h"
#import "PhotosViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//Asks for hashtag
-(void) viewWillAppear:(BOOL)animated{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Welcome to Hash Tagger!" message:@"This app lets you find all the recent photos of a specific hashtag you desire. Just enter one below to get started! (Don't forget the #!)" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0];
    [alertView show];
    
}

//Retrieves and sends hashtag to Photo VC
- (void)alertView:(UIAlertView *)hashtagField clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //If "OK" is pressed
    if(buttonIndex == 1){
        UITextField *textfield = [hashtagField textFieldAtIndex:0];
        if (textfield.text.length > 0) {
            PhotosViewController *photoVC = [[PhotosViewController alloc]init];
            NSString *formattedTag = [textfield.text substringFromIndex:1];
            photoVC.hashtag = formattedTag;
            [self.navigationController pushViewController:photoVC animated:YES];
        }else{
            PhotosViewController *photoVC = [[PhotosViewController alloc]init];
            photoVC.hashtag = nil;
            [self.navigationController pushViewController:photoVC animated:YES];
        }
    }
    
    if(buttonIndex == 0){
       PhotosViewController *photoVC = [[PhotosViewController alloc]init];
        photoVC.hashtag = nil;
        [self.navigationController pushViewController:photoVC animated:YES];
    }
}

@end
