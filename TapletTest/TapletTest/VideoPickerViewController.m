//
//  VideoPickerViewController.m
//  TapletTest
//
//  Created by Brian Wong on 10/2/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import "VideoPickerViewController.h"
#import "VideoPlayerViewController.h"
#import "VideoViewController.h"

@interface VideoPickerViewController ()

@property (nonatomic,strong) UIImagePickerController *imagePicker;
//@property (nonatomic,strong) NSURL *videoURL;
@property (nonatomic,strong) NSString *videoPath;

@end

@implementation VideoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickVideoButtonPressed:(id)sender {
    
    //Check if recording/videos are supported
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];

    
    [self presentViewController:self.imagePicker animated:NO completion:nil];
}


#pragma mark - UIImagePickerDelegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo)
    {
        
        self.videoURL =(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        //NSLog(@"%@",moviePath);
        
    }
    
    //Move to AVMediaPlayer and pass video data
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self performSegueWithIdentifier: @"showMediaPlayer" sender:self];
    [self performSegueWithIdentifier:@"showMediaPlayer" sender:self];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

//Pass picked video to player
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqualToString: @"showMediaPlayer"]){
        UINavigationController *videoPlayerNav = (UINavigationController*)segue.destinationViewController;
        VideoPlayerViewController *videoPlayerVC = (VideoPlayerViewController*)videoPlayerNav.topViewController;
        videoPlayerVC.videoURL = self.videoURL;
    }
}



@end
