//
//  PhotosController.h
//  Photo Bombers
//
//  Created by Brian Wong on 8/15/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosController : NSObject

+ (void)imageForPhoto:(NSDictionary*)photo size:(NSString*)size completion:(void(^)(UIImage* image))completion;

@end
