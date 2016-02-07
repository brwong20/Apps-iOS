//
//  PresentDetailTransition.m
//  Photo Bombers
//
//  Created by Brian Wong on 8/16/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "PresentDetailTransition.h"

@implementation PresentDetailTransition

//transitionContext manages all aspects of the transition between two views
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //Retrieves the context of the view we are transitioning TO
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //Holds both views within the transition
    UIView *containerView = [transitionContext containerView];
    
    detail.view.alpha = 0.0; //Make second view transparent first
    
    //CRUCIAL: We always have to have a frame for the transition AND add it to our containerview
    
    //Makes sure the entire view is always moved down 20 pts (to show our status bar)
    CGRect frame = containerView.bounds;
    frame.origin.y += 20.0;
    frame.size.height -= 20.0;//Since we are shrinking the view vertically, we have to cut off the same amount at the bottom of the view so it there isn't extra white space hanging at the bottom
    detail.view.frame = frame;
    
    [containerView addSubview:detail.view];//Add the transition view to our container 
    
    //Fade in a view in 0.3 seconds, and then tell the transitioncontext we're done
    [UIView animateWithDuration:0.3 animations:^{
        detail.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3; // 1/3 of a second
}

@end