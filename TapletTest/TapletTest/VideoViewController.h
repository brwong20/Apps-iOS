//
//  VideoViewController.h
//  TapletTest
//
//  Created by Brian Wong on 10/3/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PBJVideoPlayerController.h>


@interface VideoViewController : UIViewController<PBJVideoPlayerControllerDelegate>

@property (nonatomic,strong) NSString *videoPath;

@end
