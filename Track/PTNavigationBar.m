//
//  PTNavigationBar.m
//  PTKit
//
//  Created by LeeHu on 15/2/6.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTNavigationBar.h"
#import <QuartzCore/QuartzCore.h>
#import "PTOSMacro.h"
#import "PTRectMacro.h"
#import "UIView+Extents.h"

#define TAG_TITLELABEL_NAVIGATIONBAR 50000

@interface PTNavigationBar ()

@property (nonatomic, strong) UIView *bottomBorder;

@end

@implementation PTNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame needBlurEffect:YES];
}

- (instancetype)initWithFrame:(CGRect)frame needBlurEffect:(BOOL)needBlurEffect
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        self.clipsToBounds = NO;

        self.containerView = [[UIView alloc]
            initWithFrame:CGRectMake(0, 0, frame.size.width,
                                     frame.size.height - ((NSFoundationVersionNumber >
                                                           NSFoundationVersionNumber_iOS_6_1)
                                                              ? kPTStatusBarHeight
                                                              : 0))];

        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 && needBlurEffect) {

            UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];

            self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
            self.effectView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            self.effectView.tintColor = [UIColor redColor];
            [self addSubview:self.effectView];
            [self.effectView.contentView addSubview:self.containerView];

        } else {
            self.backgroundColor = [UIColor redColor];
            [self addSubview:self.containerView];
        }

        //描边
        self.bottomBorder =
            [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.containerView.frame) -
                                                            1 / [UIScreen mainScreen].scale,
                                                     CGRectGetWidth(self.containerView.frame),
                                                     1 / [UIScreen mainScreen].scale)];
        self.bottomBorder.backgroundColor = [UIColor clearColor];
        [self.containerView addSubview:self.bottomBorder];
        frame.origin.y = CGRectGetHeight(self.bounds) - frame.size.height;
        CGRect frame = self.containerView.frame;
        frame.origin.y = CGRectGetHeight(self.bounds) - frame.size.height;
        self.containerView.frame = frame;
    }

    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (nil == _titleView) {
        _titleView = [[UIView alloc]
            initWithFrame:CGRectMake((CGRectGetWidth(self.containerView.frame) - 200) / 2, 0, 200,
                                     CGRectGetHeight(self.containerView.frame))];
    } else {
        [_titleView ex_removeAllSubViews];
    }
    _titleView.frame = CGRectMake((CGRectGetWidth(self.containerView.frame) - 200) / 2, 0, 200,
                                  CGRectGetHeight(self.containerView.frame));
    _titleView.backgroundColor = [UIColor clearColor];

    UILabel *titleLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 5, 200, CGRectGetHeight(_titleView.frame) - 10)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = _title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 14 / 18.f;
    titleLabel.tag = TAG_TITLELABEL_NAVIGATIONBAR;
    [_titleView addSubview:titleLabel];

    [_titleView removeFromSuperview];
    [self.containerView addSubview:_titleView];
}

- (void)setTitleColor:(UIColor *)color
{
    UILabel *titleLabel = (UILabel *)[_titleView viewWithTag:TAG_TITLELABEL_NAVIGATIONBAR];
    titleLabel.textColor = color;
}

- (void)setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    _titleView = nil;
    if (titleView) {
        _titleView = titleView;
        _titleView.center = CGPointMake(CGRectGetWidth(self.containerView.frame) / 2.0,
                                        CGRectGetHeight(self.containerView.frame));
        [self.containerView addSubview:_titleView];
    }
}

- (UILabel *)titleLabel
{
    UILabel *titleLabel = (UILabel *)[_titleView viewWithTag:TAG_TITLELABEL_NAVIGATIONBAR];
    return titleLabel;
}

- (void)setLeftBarButton:(UIView *)leftBarButton
{
    [_leftBarButton removeFromSuperview];
    _leftBarButton = nil;
    if (leftBarButton) {
        _leftBarButton = leftBarButton;
        _leftBarButton.center = CGPointMake(CGRectGetWidth(_leftBarButton.bounds) / 2.0,
                                            CGRectGetHeight(self.containerView.frame) / 2.0);
        [self.containerView addSubview:_leftBarButton];
    }
}

- (void)setRightBarButton:(UIView *)rightBarButton
{
    [_rightBarButton removeFromSuperview];
    _rightBarButton = nil;
    if (rightBarButton) {
        _rightBarButton = rightBarButton;
        _rightBarButton.center = CGPointMake(CGRectGetWidth(self.containerView.frame) -
                                                 (CGRectGetWidth(_rightBarButton.frame) / 2),
                                             CGRectGetHeight(self.containerView.frame) / 2);
        [self.containerView addSubview:_rightBarButton];
        [self.containerView bringSubviewToFront:_rightBarButton];
    }
}

- (void)setBottomBorderColor:(UIColor *)color
{
    self.bottomBorder.backgroundColor = color;
}

@end
