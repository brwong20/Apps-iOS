//
//  PhotosCollectionViewCell.h
//  TapletTest
//
//  Created by Brian Wong on 10/3/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UIImage *imageData;
@property (strong,nonatomic)UILongPressGestureRecognizer *longPress;

@end
