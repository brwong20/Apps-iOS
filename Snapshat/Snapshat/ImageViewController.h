//
//  ImageViewController.h
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController
@property (strong, nonatomic) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
