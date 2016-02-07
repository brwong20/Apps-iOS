//
//  ScrollViewController.m
//  TapletTest
//
//  Created by Brian Wong on 10/13/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import "ScrollViewController.h"
#import "VideoPickerViewController.h"
#import "CameraViewController.h"
#import "VideoCollectionView.h"


@interface ScrollViewController ()


@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set "main" view for scroll view
    VideoCollectionView *vidCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"videoCollectionVC"];
    
    vidCollectionVC.view.frame = self.scrollView.bounds;
    
    [self addChildViewController:vidCollectionVC];
    [self.scrollView addSubview:vidCollectionVC.view];
    [vidCollectionVC didMoveToParentViewController:self];
    
    //Set next VC to start based on where the current VC ends
    CameraViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cameraVC"];
    
    cameraVC.view.frame = self.scrollView.bounds;
    CGRect frame1 = cameraVC.view.frame;
    frame1.origin.x = self.view.frame.size.width;
    cameraVC.view.frame = frame1;

    [self addChildViewController:cameraVC];
    [self.scrollView addSubview:cameraVC.view];
    [cameraVC didMoveToParentViewController:self];
    
    //Finally, we need to set the content size's width of the scroll view based on the number of VCs (width*X) and its height (-22 for under status bar, -66 for under nav bar + status bar)
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height)];
    
    //Allows us to start on a "middle" VC (1 page offset from the main view)
    self.scrollView.contentOffset = cameraVC.view.frame.origin;

}

-(void)viewDidLayoutSubviews{

}


-(BOOL)prefersStatusBarHidden{
    return YES;
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

@end
