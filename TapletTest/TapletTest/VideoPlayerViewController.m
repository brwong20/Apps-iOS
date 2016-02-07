//
//  VideoPlayerViewController.m
//  TapletTest
//
//  Created by Brian Wong on 10/2/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "PhotosCollectionViewController.h"
#import "CameraViewController.h"


@interface VideoPlayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic,retain) AVPlayer *videoPlayer;
@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *playPauseRecognizer;
@property (strong,nonatomic) UIView *flashView;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet JSVideoScrubber *videoScrubber;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIView *videoControlView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *snapShotsButton;



@end

@implementation VideoPlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPlayer];
    [self setUpScrubber];
    self.gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenShot)];
    self.gestureRecognizer.numberOfTapsRequired = 1;
    [self.playerView addGestureRecognizer:self.gestureRecognizer];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.imageArray = [[NSMutableArray alloc]init];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.videoPlayer = nil;
    self.imageArray = nil;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)setUpPlayer{
    if (self.videoURL != nil) {
        self.videoPlayer = [[AVPlayer alloc]initWithURL:self.videoURL];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        playerLayer.frame = self.view.bounds;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.playerView.layer addSublayer:playerLayer];
        [self.playerView addSubview:self.videoScrubber];
        [self.playerView addSubview:self.videoControlView];
        self.snapShotsButton.enabled = false;
        [self.videoPlayer play];
    }
}

-(void)setUpScrubber{
    
    __weak VideoPlayerViewController *ref = self;
    
    
    AVURLAsset *asset = nil;
    
    asset = [AVURLAsset assetWithURL:self.videoURL];
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"tracks", @"duration", nil];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^(void) {
        
        //If you want to display duration
//        ref.duration.text = @"Duration: N/A";
//        ref.offset.text = @"Offset: N/A";
        
        [ref.videoScrubber setupControlWithAVAsset:asset];
        
//        double total = CMTimeGetSeconds(ref.videoScrubber.duration);
//        
//        //In case duration time is needed
//        int min = (int)total / 60;
//        int seconds = (int)total % 60;
        
        
       [ref.videoScrubber addTarget:self action:@selector(updateOffset:) forControlEvents:UIControlEventValueChanged];
    
    }];
}

//Updates video based on marker location(scrubbing)
-(void)updateOffset:(JSVideoScrubber*) videoScrubber{
    float offsetTime = (float)self.videoScrubber.offset;
    
    CMTime currentTime = CMTimeMakeWithSeconds(offsetTime, NSEC_PER_SEC);
    
    if(self.videoPlayer.status == AVPlayerStatusReadyToPlay && self.videoPlayer.currentItem.status == AVPlayerStatusReadyToPlay){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videoPlayer.currentItem seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                [self.videoPlayer play];
            }];
        });
    }
}

- (IBAction)playPausePressed:(id)sender {
    if(self.videoPlayer.rate == 0.0){
        [self.videoPlayer play];
        [self.playPauseButton setImage:[UIImage imageNamed:@"PauseImage"] forState:UIControlStateNormal];
        
    }else{
        [self.videoPlayer pause];
        [self.playPauseButton setImage:[UIImage imageNamed:@"PlayImage"] forState:UIControlStateNormal];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSFileManager defaultManager]removeItemAtURL:self.videoURL error:nil];
}

-(void)playPause{
    if(self.videoPlayer.rate == 1.0){
        [self.videoPlayer pause];
    }else{
        [self.videoPlayer play];
    }
}


-(void)screenShot{
    self.snapShotsButton.enabled = true;
    [self mimicScreenShotFlash];
    [self screenshotFromPlayer:self.videoPlayer];
}

- (IBAction)viewScreensots:(id)sender {
    [self performSegueWithIdentifier:@"showScreenshots" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"showScreenshots"]){
        [self.videoPlayer pause];
        PhotosCollectionViewController *photosVC = (PhotosCollectionViewController*) segue.destinationViewController;
        photosVC.imageArray = [NSArray arrayWithArray:self.imageArray];
    }
}


#pragma mark - Helper methods
-(void)mimicScreenShotFlash{
    
    self.flashView = [[UIView alloc]initWithFrame:self.view.frame];
    self.flashView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.flashView];
    
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.flashView.alpha = 0.0;
        AudioServicesPlaySystemSound(1108);
    } completion:^(BOOL finished) {
        [self.flashView removeFromSuperview];
    }];
    
}

- (UIImage *)screenshotFromPlayer:(AVPlayer *)player{
    
    CMTime actualTime;
    NSError *error;
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:player.currentItem.asset];
    
    //If a specific size is needed, add to function declaration
    //generator.maximumSize = maxSize;
    
    generator.appliesPreferredTrackTransform = YES; //To make picture vertical
    CGImageRef cgIm = [generator copyCGImageAtTime:player.currentTime
                                        actualTime:&actualTime
                                             error:&error];
    UIImage *image = [UIImage imageWithCGImage:cgIm];
    CFRelease(cgIm);
    
    if (nil != error) {
        NSLog(@"Error making screenshot: %@", [error localizedDescription]);
        NSLog(@"Actual screenshot time: %f Requested screenshot time: %f", CMTimeGetSeconds(actualTime),
              CMTimeGetSeconds(self.videoPlayer.currentTime));
        return nil;
    }
    
    [self.imageArray addObject:image];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    return image;
}

@end
