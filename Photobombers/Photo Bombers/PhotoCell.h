//
//  PhotoCell.h
//  Photo Bombers
//
//  Created by Brian Wong on 8/4/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *cellPhoto;
@property (nonatomic, strong) NSDictionary *photo;

-(void)setPhoto:(NSDictionary *)photo;

@end
