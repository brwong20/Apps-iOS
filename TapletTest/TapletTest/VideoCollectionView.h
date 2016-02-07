//
//  VideoCollectionView.h
//  TapletTest
//
//  Created by Brian Wong on 10/15/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoCollectionView : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSArray *assets;

@end
