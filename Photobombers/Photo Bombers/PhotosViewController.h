//
//  PhotosViewController.h
//  Photo Bombers
//
//  Created by Brian Wong on 8/4/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UICollectionViewController

@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *hashtag;

-(void)refreshPhotos;

@end