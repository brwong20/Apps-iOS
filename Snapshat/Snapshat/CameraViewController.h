//
//  CameraViewController.h
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) PFRelation *friendRelation;
@property (nonatomic, strong) NSMutableArray *recipients;
@property (nonatomic, strong)UIColor *disclosureColor;
- (IBAction)cancelButton:(id)sender;
- (IBAction)sendButton:(id)sender;
-(void) uploadMessage;

@end
