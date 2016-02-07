//
//  VideoPlayerViewController.h
//  TapletTest
//
//  Created by Brian Wong on 10/2/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Photos/Photos.h>
#import "JSVideoScrubber.h"


@class AVPLayer;

@interface VideoPlayerViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic,strong) NSURL* videoURL;
@property (nonatomic,strong) PHAsset *videoAsset;


@end
