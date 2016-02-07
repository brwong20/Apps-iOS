//
//  DismissDetailTransition.m
//  Photo Bombers
//
//  Created by Brian Wong on 8/16/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "DismissDetailTransition.h"

@implementation DismissDetailTransition

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //Retrieves the context of the view we are transitioning FROM - don't need all the other extra code b/c PresentDetailTransition set everything up already (containerview, addSubview, etc)
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //Show the original view clearly (0.0) and remove the transitioned view (detailView)
    [UIView animateWithDuration:0.3 animations:^{
        detail.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [detail.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3; // 1/3 of a second
}

@end
