//
//  VideoCell.h
//  TapletTest
//
//  Created by Brian Wong on 10/20/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UICollectionViewCell

@property (nonatomic,strong)NSURL *videoURL;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end
