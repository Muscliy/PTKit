//
//  PTViewControllerPopAnimatedTransitioning.m
//  PTKit
//
//  Created by LeeHu on 15/3/1.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTViewControllerPopAnimatedTransitioning.h"
#import "PTInteractiveCollectionViewController.h"
#import "PTInteractiveDetailViewController.h"

@implementation PTViewControllerPopAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	NSLog(@"trasn");
    PTInteractiveDetailViewController *fromVC = (PTInteractiveDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PTInteractiveCollectionViewController *toVC = (PTInteractiveCollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    NSLog(@"durantion :%zd",duration);
    UIView *imageSnapShot = [fromVC.imageView snapshotViewAfterScreenUpdates:NO];
    imageSnapShot.frame = [containView convertRect:fromVC.imageView.frame fromView:fromVC.imageView.superview];
    fromVC.imageView.hidden = YES;
    
    PTInteractiveCollectionViewCell *cell = (PTInteractiveCollectionViewCell *)fromVC.transitionFromView;
    cell.networkImageView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containView insertSubview:toVC.view belowSubview:fromVC.view];
    [containView addSubview:imageSnapShot];
    
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.alpha = 0.0;
        imageSnapShot.frame = [containView convertRect:fromVC.transitionFromView.frame fromView:fromVC.transitionFromView.superview];
    } completion:^(BOOL finished) {
        [imageSnapShot removeFromSuperview];
        fromVC.imageView.hidden = NO;
        cell.networkImageView.hidden = NO;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
