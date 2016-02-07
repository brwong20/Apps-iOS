//
//  CameraPreviewLayer.m
//  TapletTest
//
//  Created by Brian Wong on 10/17/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

@import AVFoundation;
#import "CameraPreviewLayer.h"


@implementation CameraPreviewLayer

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}


@end
