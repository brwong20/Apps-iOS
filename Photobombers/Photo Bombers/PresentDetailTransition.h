//
//  PresentDetailTransition.h
//  Photo Bombers
//
//  Created by Brian Wong on 8/16/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PresentDetailTransition : NSObject <UIViewControllerAnimatedTransitioning>

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

@end