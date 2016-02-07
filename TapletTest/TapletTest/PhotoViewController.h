//
//  PhotoViewController.h
//  TapletTest
//
//  Created by Brian Wong on 10/3/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIImage *screenshotImage;

@end
