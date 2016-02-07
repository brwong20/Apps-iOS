//
//  ImageViewController.m
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileURL = [[NSURL alloc]initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    self.imageView.image = [UIImage imageWithData:imageData];
    
    //Sets the title of the navigation bar to sender's name
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
    self.navigationItem.title = title;
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //Create a timer of 10 seconds that TARGETS the current view controller(self) with the specified selector(runs code in selector when done)
    
    if([self respondsToSelector:@selector(timeout)]){//Checks to see if selector works
        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }else{
        NSLog(@"Error: selector missing");
    }
}


#pragma mark - Helper Methods

-(void)timeout{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
