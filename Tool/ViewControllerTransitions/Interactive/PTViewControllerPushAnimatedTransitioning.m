//
//  PTViewControllerPushAnimatedTransitioning.m
//  PTKit
//
//  Created by LeeHu on 15/3/1.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTViewControllerPushAnimatedTransitioning.h"
#import "PTInteractiveDetailViewController.h"
#import "PTInteractiveCollectionViewController.h"

@implementation PTViewControllerPushAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    PTInteractiveDetailViewController *toVC = (PTInteractiveDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *imageSnapShot = [toVC.transitionFromView snapshotViewAfterScreenUpdates:NO];
    imageSnapShot.frame = [containView convertRect:toVC.transitionFromView.frame fromView:toVC.transitionFromView.superview];
    toVC.transitionFromView.hidden = YES;
    
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0.0;
    toVC.imageView.hidden = YES;
    [containView addSubview:toVC.view];
    [containView addSubview:imageSnapShot];
    
    [UIView animateWithDuration:duration animations:^{
        toVC.view.alpha = 1.0;
        CGRect frame = [containView convertRect:toVC.imageView.frame fromView:toVC.view];
        imageSnapShot.frame = frame;
        
    } completion:^(BOOL finished) {
        toVC.imageView.hidden = NO;
        toVC.transitionFromView.hidden = NO;
        [imageSnapShot removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
