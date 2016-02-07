//
//  VideoViewController.m
//  TapletTest
//
//  Created by Brian Wong on 10/3/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@property (nonatomic,strong) PBJVideoPlayerController *videoPlayer;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _videoPlayer = [[PBJVideoPlayerController alloc]init];
    _videoPlayer.delegate = self;
    _videoPlayer.view.frame = _videoView.bounds;
    _videoPlayer.videoPath = self.videoPath;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addChildViewController:_videoPlayer];
    [_videoView addSubview:_videoPlayer.view];
    [_videoPlayer didMoveToParentViewController:self];
    [self videoPlayerReady:_videoPlayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//PBJVideoPlayer Delegate Methods
-(void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer{
    [videoPlayer playFromBeginning];
}

-(void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer{
    //Segue
}

-(void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer{
    //...
}

-(void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer{
    //...
}

@end
