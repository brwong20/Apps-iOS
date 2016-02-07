//
//  CameraPreviewLayer.h
//  TapletTest
//
//  Created by Brian Wong on 10/17/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureSession;

@interface CameraPreviewLayer : UIView

@property (nonatomic) AVCaptureSession *session;

@end
