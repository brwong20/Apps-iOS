//
//  DetailViewController.m
//  Photo Bombers
//
//  Created by Brian Wong on 8/15/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotosController.h"
#import "THMetadataView.h"

@interface DetailViewController ()

//Private to this class
@property (nonatomic, strong) UIImageView* imageView;
//To implement physics into our view
@property (nonatomic, strong) UIDynamicAnimator *animator;
//Displays metadata - avatar image, likes, comments, date
@property (nonatomic) THMetadataView *metadataView;

@end

@implementation DetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    self.view.clipsToBounds = YES;
    
    //Metadata format and passes our photo data to the class
    self.metadataView = [[THMetadataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 400.0f)];
    self.metadataView.alpha = 0.0f;
    self.metadataView.photo = self.photo;
    [self.view addSubview:self.metadataView];
    
    //Creates the image above the view so it can fall down and snap into place at the center
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, -320.0, 320.0f, 320.0f)];
    
    //Adds "sibling view" (our rectangle) on top of original view
    [self.view addSubview:self.imageView];
    
    [PhotosController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    //Swipe the photo to close the view
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
}

//Snap is set in here so it can have a delay for better effect - animation happens after image is loaded
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //Center point of view
    CGPoint point = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    //Animator with reference to current view
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //Snaps our image view to the center of the view
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self.imageView snapToPoint:point];
    [self.animator addBehavior:snap];
    
    //Animating the metadata in as well - appears from being invisible (alpha = 0.0)
    self.metadataView.center = point;
    [UIView animateWithDuration:0.5 delay:0.7 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:kNilOptions animations:^{
        self.metadataView.alpha = 1.0f;
    } completion:nil];
    
}

/*Unncessary because our snap behavior centers our imageview
 
//For dynamic resizing of photo
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //Size of whole screen
    CGSize size = self.view.bounds.size;
    //Make the image a square
    CGSize imageSize = CGSizeMake(size.width, size.width);
    
    //Parameters: 0.0 = Pins photo to left; Second parameter finds the vertical center by allocating the remaining part of the screen(not used by image) on the top and bottom of the image; The last 2 params just make it a square
    self.imageView.frame = CGRectMake(0.0, ((size.height - imageSize.height)/2.0), imageSize.width, imageSize.height);
}
 */

-(void)close{
    [self.animator removeAllBehaviors];
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //Snaps our image view to beneath the bounds of the view controller
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self.imageView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds)+180.0f)];
    [self.animator addBehavior:snap];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
