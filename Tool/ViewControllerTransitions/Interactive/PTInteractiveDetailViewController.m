//
//  PTInteractiveDetailViewController.m
//  PTKit
//
//  Created by LeeHu on 15/3/1.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTInteractiveDetailViewController.h"
#import "PTViewControllerPopAnimatedTransitioning.h"

@interface PTInteractiveDetailViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UILabel *overViewLabel;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation PTInteractiveDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.userData.title;
    self.view.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 60, 200, 200)];

    _overViewLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(50, CGRectGetMaxY(_imageView.frame) + 20, 200, 100)];
    _overViewLabel.textAlignment = NSTextAlignmentCenter;
    _overViewLabel.numberOfLines = 0;
    _overViewLabel.font = [UIFont systemFontOfSize:15];
    _overViewLabel.text = self.userData.overView;

    [self.view addSubview:_imageView];
    [self.view addSubview:_overViewLabel];

    UIScreenEdgePanGestureRecognizer *popRecognizer =
        [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(handlePopRecognizer:)];
    popRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:popRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.imageView.image = self.userData.image;
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark UIGestureRecognizer handlers

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    CGFloat progress =
        [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.interactivePopTransition updateInteractiveTransition:progress];
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        } else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (fromVC == self && [toVC isKindOfClass:[PTInteractiveCollectionViewController class]]) {
        return [[PTViewControllerPopAnimatedTransitioning alloc] init];
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[PTViewControllerPopAnimatedTransitioning class]]) {
        return self.interactivePopTransition;
    }
    
    return nil;
}

@end
