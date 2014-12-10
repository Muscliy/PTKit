//
//  PTWebViewProgressView.m
//  xmLife
//
//  Created by LeeHu on 14/12/8.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTWebViewProgressView.h"
#import "PTWebViewProgress.h"

@implementation PTWebViewProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self configureViews];
    }
    return self;
}

- (void)configureViews
{
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds))];
    _progressBarView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIColor *tintColor =
        [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];

    _progressBarView.backgroundColor = tintColor;
    _progressBarView.alpha = 0.0;
    [self addSubview:_progressBarView];

    _barAnimationDuration = 4.0f;
    _barSlowAnimationDuration = 6.0f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animted:NO];
}

- (void)setProgress:(CGFloat)progress animted:(BOOL)animated
{
    BOOL isLoadding = progress > PTInitialProgressValue && progress < PTFinalProgressValue;
    _progress = progress;
    PTWeakSelf;
    [UIView animateWithDuration:isLoadding ? _barAnimationDuration : 0.27f
        delay:_fadeOutDelay
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{

            CGRect frame = _progressBarView.frame;
            frame.size.width = progress * self.bounds.size.width;
            _progressBarView.frame = frame;

        }
        completion:^(BOOL completed) {
            PTStrongSelf;
            if (_progress < PTFinalProgressValue) {
                self.progress = PTFinalProgressValue;
                [UIView animateWithDuration:_barSlowAnimationDuration
                                 animations:^{
                                     CGRect frame = _progressBarView.frame;
                                     frame.size.width = self.progress * self.bounds.size.width;
                                     _progressBarView.frame = frame;
                                 }];
            }

        }];

    if (progress > PTFinalProgressValue) {
        [UIView animateWithDuration:_fadeAnimationDuration * 3
            delay:0.0
            options:UIViewAnimationOptionCurveEaseInOut
            animations:^{

                CGRect frame = _progressBarView.frame;
                frame.size.width = self.bounds.size.width;
                _progressBarView.frame = frame;

            }
            completion:^(BOOL completed) {

                CGRect frame = _progressBarView.frame;
                frame.size.width = 0;
                _progressBarView.frame = frame;
                _progressBarView.alpha = 0.0;
            }];
    } else {
        [UIView animateWithDuration:_fadeAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{ _progressBarView.alpha = progress > 0 ? 1.0 : 0; }
                         completion:nil];
    }
}

@end
