//
//  CameraViewController.m
//  TapletTest
//
//  Created by Brian Wong on 10/13/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

@import AVFoundation;
@import Photos;

#import "CameraViewController.h"
#import "ScrollViewController.h"
#import "VideoPlayerViewController.h"
#import "VideoPickerViewController.h"

//Used to notify successful setup
typedef NS_ENUM( NSInteger, AVCamSetupResult ) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
};

@interface CameraViewController()<AVCaptureFileOutputRecordingDelegate>

//Utilities
@property (nonatomic,strong) dispatch_queue_t sessionQueue;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic,strong) NSURL *videoURL;

//Storyboard
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *stillImageView;
@property (strong, nonatomic) UIImage *stillImage;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *recordLongPressRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *photoGalleryButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *presentPlayerButton;

//AVFoundation
@property (nonatomic,strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCamSetupResult setupResult;
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic,strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

//Buttons
@property (nonatomic,strong) UIButton *takePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation CameraViewController
bool didTakePhoto = false;

//Set up camera and its properties


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.cancelButton.hidden = true;
    self.presentPlayerButton.hidden = true;
    [self.cameraView addGestureRecognizer:self.tapGestureRecognizer];
    
    self.captureSession = [[AVCaptureSession alloc]init];
    
    // Communicate with the session and other session objects on this queue.
    // Used to configure AVCaptureSession on a separate queue because we don't want to block any of our UI
    // Furthermore, [captureSessions startSession] is called on the main queue and can potentially block the UI.
    self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
    
    // Check video authorization status. Video access is required and audio access is optional.
    // If audio access is denied, audio is not recorded during movie recording.
    switch ( [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] )
    {
        case AVAuthorizationStatusAuthorized:
        {
            // The user has previously granted access to the camera.
            break;
        }
        case AVAuthorizationStatusNotDetermined:
        {
            // The user has not yet been presented with the option to grant video access.
            // We suspend the session queue to delay session setup until the access request has completed to avoid
            // asking the user for audio access if video access is denied.
            // Note that audio access will be implicitly requested when we create an AVCaptureDeviceInput for audio during session setup.
            dispatch_suspend( self.sessionQueue );
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^( BOOL granted ) {
                if ( ! granted ) {
                    self.setupResult = AVCamSetupResultCameraNotAuthorized;
                }
                dispatch_resume( self.sessionQueue );
            }];
            break;
        }
        default:
        {
            // The user has previously denied access.
            self.setupResult = AVCamSetupResultCameraNotAuthorized;
            break;
        }
    }
    
    dispatch_async( self.sessionQueue, ^{
        
        if ( self.setupResult != AVCamSetupResultSuccess ) {//Return if setup failed
            return;
        }
        
        //To signal we aren't recording
        self.backgroundRecordingID = UIBackgroundTaskInvalid;
    
        //Set quality
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        
        NSError *error = nil;
        
        //Set default live preview position for our preview view class
        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //Set up input for device
        AVCaptureDeviceInput *vidDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        //If device config wasn't successful
        if ( ! vidDeviceInput) {
            NSLog( @"Could not create video device input: %@", error );
        }
        
        
        [self.captureSession beginConfiguration];//Begin making changes
        
        //If your phone supports the inputs, associate the phone with the inputs
        if(error == nil && [self.captureSession canAddInput:vidDeviceInput]){
            [self.captureSession addInput:vidDeviceInput];
        
            //Track input configurations for current device (rear camera on startup)
            self.videoDeviceInput = vidDeviceInput;
            self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            
            
            //Since our preview layer is part of the UI, we need to update it on the main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                self.previewLayer.frame = self.cameraView.bounds;
                [self.cameraView.layer addSublayer:self.previewLayer];
                [self.cameraView addSubview:self.takePictureButton];
                NSLog(@"Setup");
            });
        }
        
        self.setupResult = AVCamSetupResultSuccess;
        
        //Add audio support for cameras
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if ( ! audioDeviceInput ) {
            NSLog( @"Could not create audio device input: %@", error );
        }
        
        if ( [self.captureSession canAddInput:audioDeviceInput] ) {
            [self.captureSession addInput:audioDeviceInput];
        }
        else {
            NSLog( @"Could not add audio device input to the session" );
        }
        
        //Add video writing support for cameras
        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ( [self.captureSession canAddOutput:movieFileOutput] ) {
            [self.captureSession addOutput:movieFileOutput];
            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if ( connection.isVideoStabilizationSupported ) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }
            self.movieFileOutput = movieFileOutput;
        }
        else {
            NSLog( @"Could not add movie file output to the session" );
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }
        
        //Add still image writing support for cameras
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ( [self.captureSession canAddOutput:stillImageOutput] ) {
            stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
            [self.captureSession addOutput:stillImageOutput];
            self.stillImageOutput = stillImageOutput;
        }
        else {
            NSLog( @"Could not add still image output to the session" );
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }
        
        [self.captureSession commitConfiguration]; //Perform all configurations above and commit them (smoother transition/setup)
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    dispatch_async( self.sessionQueue, ^{
        if ( self.setupResult == AVCamSetupResultSuccess ) {
            [self.captureSession stopRunning];
        }
    } );
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Run the capture session if setup was a success, if not, prompt user to setup camera/mic properly
    dispatch_async( self.sessionQueue, ^{
        switch ( self.setupResult )
        {
            case AVCamSetupResultSuccess:
            {
                //Make custom camera fill the view and resize accordingly
                self.previewLayer.frame = self.cameraView.bounds;
                // Only setup observers and start the session running if setup succeeded.
                [self.captureSession startRunning];
                break;
            }
            case AVCamSetupResultCameraNotAuthorized:
            {
                dispatch_async( dispatch_get_main_queue(), ^{
                    NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    // Provide quick access to Settings.
                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                    [alertController addAction:settingsAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                } );
                break;
            }
            case AVCamSetupResultSessionConfigurationFailed:
            {
                dispatch_async( dispatch_get_main_queue(), ^{
                    NSString *message = NSLocalizedString( @"Unable to capture media", @"Alert message when something goes wrong during capture session configuration" );
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                } );
                break;
            }
        }
    } );
}

- (void)didPressTakePhoto{
    
    dispatch_async( self.sessionQueue, ^{
        AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        AVCaptureVideoPreviewLayer *previewLayer = self.previewLayer;
        
        // Update the orientation on the still image output video connection before capturing.
        connection.videoOrientation = previewLayer.connection.videoOrientation;
        
        // Capture a still image.
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^( CMSampleBufferRef imageDataSampleBuffer, NSError *error ) {
            if ( imageDataSampleBuffer ) {
                // The sample buffer is not retained. Create image data before saving the still image to the photo library asynchronously.
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                
                CFDataRef cfData = CFDataCreate(NULL, [imageData bytes], [imageData length]);
    
                //Create a data provider
                CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(cfData);
    
                //Convert to CGImage with data provider
                struct CGImage *cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, YES, kCGRenderingIntentDefault);
                
                //Check for which camera used b/c front camera takes mirrored images;
                AVCaptureInput* currentCameraInput = [_captureSession.inputs objectAtIndex:0];
                if (((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack){
                    //Convert to UIImage
                    self.stillImage = [UIImage imageWithCGImage:cgImageRef scale:1.0 orientation:UIImageOrientationRight];
                }else{
                    self.stillImage = [UIImage imageWithCGImage:cgImageRef scale:1.0 orientation:UIImageOrientationLeftMirrored];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show image
                    self.stillImageView.bounds = self.previewLayer.frame;
                    self.stillImageView.image = self.stillImage;
                    self.stillImageView.hidden = NO;
                });
      
                //Auto save feature
                
//                [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
//                    if ( status == PHAuthorizationStatusAuthorized ) {
//                        // To preserve the metadata, we create an asset from the JPEG NSData representation.
//                        // Note that creating an asset from a UIImage discards the metadata.
//                        // In iOS 9, we can use -[PHAssetCreationRequest addResourceWithType:data:options].
//                        // In iOS 8, we save the image to a temporary file and use +[PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:].
//                        if ( [PHAssetCreationRequest class] ) {
//                            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                                [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
//                            } completionHandler:^( BOOL success, NSError *error ) {
//                                if ( ! success ) {
//                                    NSLog( @"Error occurred while saving image to photo library: %@", error );
//                                }
//                            }];
//                        }
//                        else {
//                            NSString *temporaryFileName = [NSProcessInfo processInfo].globallyUniqueString;
//                            NSString *temporaryFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[temporaryFileName stringByAppendingPathExtension:@"jpg"]];
//                            NSURL *temporaryFileURL = [NSURL fileURLWithPath:temporaryFilePath];
//                            
//                            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                                NSError *error = nil;
//                                [imageData writeToURL:temporaryFileURL options:NSDataWritingAtomic error:&error];
//                                if ( error ) {
//                                    NSLog( @"Error occured while writing image data to a temporary file: %@", error );
//                                }
//                                else {
//                                    [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:temporaryFileURL];
//                                }
//                            } completionHandler:^( BOOL success, NSError *error ) {
//                                if ( ! success ) {
//                                    NSLog( @"Error occurred while saving image to photo library: %@", error );
//                                }
//                                
//                                // Delete the temporary file.
//                                [[NSFileManager defaultManager] removeItemAtURL:temporaryFileURL error:nil];
//                            }];
//                        }
//                   }
//                }];
            }
            else {
                NSLog( @"Could not capture still image: %@", error );
            }
        }];
    } );
    
//        }
//    }];
    
}


-(IBAction)switchCameraTapped:(id)sender{
//    self.cameraButton.enabled = NO;
//    self.recordButton.enabled = NO;
//    self.stillButton.enabled = NO;
    
    dispatch_async( self.sessionQueue, ^{
        AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        AVCaptureDevicePosition currentPosition = currentVideoDevice.position;
        
        switch ( currentPosition )
        {
            case AVCaptureDevicePositionUnspecified:
                case AVCaptureDevicePositionFront:
                    preferredPosition = AVCaptureDevicePositionBack;
                    break;
                case AVCaptureDevicePositionBack:
                    preferredPosition = AVCaptureDevicePositionFront;
                    break;
        }
        
        AVCaptureDevice *videoDevice = [CameraViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        [self.captureSession beginConfiguration];
        
        // Remove the existing device input first, since using the front and back camera simultaneously is not supported.
        [self.captureSession removeInput:self.videoDeviceInput];
        
        if ( [self.captureSession canAddInput:videoDeviceInput] ) {
//            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
//            
//            //[CameraViewController setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
            
            //Switch to new orientation
            [self.captureSession addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
        }
        else {
            //Use old orientation
            [self.captureSession addInput:self.videoDeviceInput];
        }
        
        AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ( connection.isVideoStabilizationSupported ) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        [self.captureSession commitConfiguration];
        
//        dispatch_async( dispatch_get_main_queue(), ^{
//            self.cameraButton.enabled = YES;
//            self.recordButton.enabled = YES;
//            self.stillButton.enabled = YES;
//        } );
    } );

}

// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

-(void)toggleMovieRecording{
    // Disable the Camera button until recording finishes, and disable the Record button until recording starts or finishes. See the
    // AVCaptureFileOutputRecordingDelegate methods.
    self.switchCameraButton.enabled = NO;
    self.photoGalleryButton.enabled = NO;
    
    dispatch_async( self.sessionQueue, ^{
        if ( ! self.movieFileOutput.isRecording ) {
            
            //Basically, we need a background task to account for our app closing mid-way into recording - this allows whatever we recorded to be saved before the app closed
            
            if ( [UIDevice currentDevice].isMultitaskingSupported ) {
                // Setup background task. This is needed because the -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:]
                // callback is not received until AVCam returns to the foreground unless you request background execution time.
                // This also ensures that there will be time to write the file to the photo library when AVCam is backgrounded.
                // To conclude this background execution, -endBackgroundTask is called in
                // -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:] after the recorded file has been saved.
                self.backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            
            // Update the orientation on the movie file output video connection before starting recording.
            AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            AVCaptureVideoPreviewLayer *previewLayer = self.previewLayer;
            connection.videoOrientation = previewLayer.connection.videoOrientation;
            
            // Turn OFF flash for video recording.
            [CameraViewController setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
            
            // Start recording to a temporary file.
            NSString *outputFileName = [NSProcessInfo processInfo].globallyUniqueString;
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[outputFileName stringByAppendingPathExtension:@"mov"]];
            [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
        }
        else {
            [self.movieFileOutput stopRecording];
        }
    });

}


- (IBAction)takePhotoButtonPressed:(id)sender {
    [self toggleMovieRecording];
}


//If we have a photo, show it, if not, run our capture session again - used in button
- (void)takeAnotherPhoto{
    if(didTakePhoto == false){
        [self.captureSession startRunning];
        didTakePhoto = true;
        [self didPressTakePhoto];
        self.cancelButton.hidden = false;
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    if(didTakePhoto == true){
        //TODO: NEEDS TO BE REIMPLEMENTED INTO A "X" BUTTON
        self.stillImageView.hidden = YES;
        self.cancelButton.hidden = true;
        didTakePhoto = false;
    }
    
}

//Implement RETAKE PHOTO/VIDEO METHOD + MAKE A BUTTON VISIBLE TO MOVE ON AND EDIT

//"Tap to focus" function
- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
    //ADD IMAGE FADE IN AND OUT TO EXPLICITLY SHOW
    CGPoint devicePoint = [self.previewLayer captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

//HELPER

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async( self.sessionQueue, ^{
        AVCaptureDevice *device = self.videoDeviceInput.device;
        NSError *error = nil;
        if ( [device lockForConfiguration:&error] ) {
            // Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
            // Call -set(Focus/Exposure)Mode: to apply the new point of interest.
            if ( device.isFocusPointOfInterestSupported && [device isFocusModeSupported:focusMode] ) {
                device.focusPointOfInterest = point;
                device.focusMode = focusMode;
            }
            
            if ( device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode] ) {
                device.exposurePointOfInterest = point;
                device.exposureMode = exposureMode;
            }
            
            device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange;
            [device unlockForConfiguration];
        }
        else {
            NSLog( @"Could not lock device for configuration: %@", error );
        }
    } );
}

//Recording helper functions
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    //Enable the Record button to let the user stop the recording.
    dispatch_async( dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping: 0.3 initialSpringVelocity: 5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.recordButton setImage:[UIImage imageNamed:@"videoRecording"] forState:UIControlStateNormal];
            
        } completion:^ (BOOL completed) {
            self.recordButton.enabled = YES;
        }];
    });
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    // Note that currentBackgroundRecordingID is used to end the background task associated with this recording.
    // This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's isRecording property
    // is back to NO — which happens sometime after this method returns.
    // Note: Since we use a unique file path for each recording, a new recording will not overwrite a recording currently being saved.
    UIBackgroundTaskIdentifier currentBackgroundRecordingID = self.backgroundRecordingID;
    self.backgroundRecordingID = UIBackgroundTaskInvalid;
    if ( currentBackgroundRecordingID != UIBackgroundTaskInvalid ) {
        [[UIApplication sharedApplication] endBackgroundTask:currentBackgroundRecordingID];
    }
    
    //Called to end the recording's background task below (function that does this is endBackgroundTask w/ our task ID we initialized when toggling the record button) while also clearing the vid data that has been saved into photos album
//    dispatch_block_t cleanup = ^{
//        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
//        if ( currentBackgroundRecordingID != UIBackgroundTaskInvalid ) {
//            [[UIApplication sharedApplication] endBackgroundTask:currentBackgroundRecordingID];
//        }
//    };
//    
//    BOOL success = YES;
//    
//    if ( error ) {
//        NSLog( @"Movie file finishing error: %@", error );
//        success = [error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] boolValue];
//    }
//    if ( success ) {
//        
//        // Check authorization status.
//        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
//            if ( status == PHAuthorizationStatusAuthorized ) {
//                // Save the movie file to the photo library and cleanup.
//                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                    // In iOS 9 and later, it's possible to move the file into the photo library without duplicating the file data.
//                    // This avoids using double the disk space during save, which can make a difference on devices with limited free disk space.
//                    if ( [PHAssetResourceCreationOptions class] ) {
//                        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
//                        options.shouldMoveFile = YES;
//                        PHAssetCreationRequest *changeRequest = [PHAssetCreationRequest creationRequestForAsset];
//                        [changeRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:outputFileURL options:options];
//                    }
//                    else {
//                        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
//                    }
//                } completionHandler:^( BOOL success, NSError *error ) {
//                    if ( ! success ) {
//                        NSLog( @"Could not save movie to photo library: %@", error );
//                    }
//                    //cleanup();
//                }];
//            }
//            else {
//                //cleanup();
//            }
//        }];
//    }
//    else {
//        //cleanup();
//    }
    
    //Enable the Camera and Record buttons to let the user switch camera and start another recording.
    dispatch_async( dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping: 0.3 initialSpringVelocity: 5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.recordButton setImage:[UIImage imageNamed:@"takePhotoImage"] forState:UIControlStateNormal];
            
        } completion:^ (BOOL completed) {
            self.presentPlayerButton.hidden = NO;
            self.recordButton.enabled = YES;
            self.switchCameraButton.enabled = YES;
            self.photoGalleryButton.enabled = YES;
            
            //Pass onto VidePlayerViewController
            self.videoURL = outputFileURL;
        }];
    });
}

- (IBAction)moveToVideoPlayer:(id)sender {
    [self performSegueWithIdentifier:@"showMediaPlayer" sender:self];
    
    //To hide the arrow when the user wants to come back to this view
    self.presentPlayerButton.hidden = YES;
}

- (IBAction)photoGalleryButton:(id)sender {

}


//Used to change device hardware orientation by sending back the respective AVCaptureDevice
+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

//Flash configuration - set up flash button with this
+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ( device.hasFlash && [device isFlashModeSupported:flashMode] ) {
        NSError *error = nil;
        if ( [device lockForConfiguration:&error] ) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        }
        else {
            NSLog( @"Could not lock device for configuration: %@", error );
        }
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqual:@"showMediaPlayer"]){
        UINavigationController *videoPlayerNav = (UINavigationController*)segue.destinationViewController;
        VideoPlayerViewController *videoPlayerVC = (VideoPlayerViewController*)videoPlayerNav.topViewController;
        videoPlayerVC.videoURL = self.videoURL;
    }
}


@end
