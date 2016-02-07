//
//  VideoCellCollectionViewCell.m
//  TapletTest
//
//  Created by Brian Wong on 10/20/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import "VideoCellCollectionViewCell.h"

@interface VideoCellCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation VideoCellCollectionViewCell


- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

@end
