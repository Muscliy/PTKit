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
#define kLeftBarButtomItemMargin 10
#define kBarButtonItemContainerViewHeight 40

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
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 14 / 18.f;
    titleLabel.tag = TAG_TITLELABEL_NAVIGATIONBAR;

    NSMutableAttributedString *titleString =
        [[NSMutableAttributedString alloc] initWithString:title];

    titleLabel.attributedText = titleString;

    [_titleView addSubview:titleLabel];
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

- (void)addRightBarButtonItemContainerView
{
    [_rightBarButtonItemcontainerView removeFromSuperview];
    _rightBarButtonItemcontainerView = nil;
    _rightBarButtonItemcontainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_rightBarButtonItemcontainerView];
}

- (void)addLeftBarButtonItemContainerView
{
    [_leftBarButtonItemcontainerView removeFromSuperview];
    _leftBarButtonItemcontainerView = nil;
    _leftBarButtonItemcontainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_leftBarButtonItemcontainerView];
}

- (void)layoutRightBarButtonItemContainerView
{
    _rightBarButtonItemcontainerView.frame =
        CGRectMake(CGRectGetWidth(self.bounds), 0, 20, kBarButtonItemContainerViewHeight);

    CGFloat startX = kLeftBarButtomItemMargin;
    for (UIView *view in [_rightBarButtonItemcontainerView subviews]) {
        view.frame =
            CGRectMake(startX, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        view.center = CGPointMake(view.center.x,
                                  CGRectGetHeight(_rightBarButtonItemcontainerView.bounds) / 2);
        startX += kLeftBarButtomItemMargin + CGRectGetWidth(view.bounds);
    }
    CGRect rect = _rightBarButtonItemcontainerView.frame;
    rect.size.width = startX;
    rect.origin.y = CGRectGetWidth(self.bounds) - startX;
    _rightBarButtonItemcontainerView.frame = rect;
    _rightBarButtonItemcontainerView.center = CGPointMake(
        _rightBarButtonItemcontainerView.center.x,
        kPTStatusBarHeight + 2 + CGRectGetHeight(_rightBarButtonItemcontainerView.bounds) / 2);
}

- (void)layoutLeftBarButtonItemContainerView
{
    _leftBarButtonItemcontainerView.frame = CGRectMake(0, 0, 20, kBarButtonItemContainerViewHeight);

    CGFloat startX = kLeftBarButtomItemMargin;
    for (UIView *view in [_leftBarButtonItemcontainerView subviews]) {
        view.frame =
            CGRectMake(startX, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        view.center =
            CGPointMake(view.center.x, CGRectGetHeight(_leftBarButtonItemcontainerView.bounds) / 2);
        startX += kLeftBarButtomItemMargin + CGRectGetWidth(view.bounds);
    }
    CGRect rect = _leftBarButtonItemcontainerView.frame;
    rect.size.width = startX;
    _leftBarButtonItemcontainerView.frame = rect;
    _leftBarButtonItemcontainerView.center = CGPointMake(
        _leftBarButtonItemcontainerView.center.x,
        kPTStatusBarHeight + 2 + CGRectGetHeight(_leftBarButtonItemcontainerView.bounds) / 2);
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    _rightBarButtonItem = rightBarButtonItem;
    if (!rightBarButtonItem) {
        [_rightBarButtonItemcontainerView removeFromSuperview];
        return;
    }
    [self addRightBarButtonItemContainerView];
    [_rightBarButtonItemcontainerView addSubview:rightBarButtonItem.customView];
    [self layoutRightBarButtonItemContainerView];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    _leftBarButtonItem = leftBarButtonItem;
    if (!leftBarButtonItem) {
        [_leftBarButtonItemcontainerView removeFromSuperview];
        return;
    }
    [self addLeftBarButtonItemContainerView];
    [_leftBarButtonItemcontainerView addSubview:leftBarButtonItem.customView];
    [self layoutLeftBarButtonItemContainerView];
}

- (void)setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems
{
    _rightBarButtonItems = rightBarButtonItems;
    if (!rightBarButtonItems) {
        [_rightBarButtonItemcontainerView removeFromSuperview];
        return;
    }
    [self addRightBarButtonItemContainerView];
    for (UIBarButtonItem *item in rightBarButtonItems) {
        [_rightBarButtonItemcontainerView addSubview:item.customView];
    }
    [self layoutRightBarButtonItemContainerView];
}

- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems
{
    _leftBarButtonItems = leftBarButtonItems;
    if (!leftBarButtonItems) {
        [_leftBarButtonItemcontainerView removeFromSuperview];
        return;
    }
    [self addLeftBarButtonItemContainerView];
    for (UIBarButtonItem *item in leftBarButtonItems) {
        [_leftBarButtonItemcontainerView addSubview:item.customView];
    }
    [self layoutLeftBarButtonItemContainerView];
}

- (void)setBottomBorderColor:(UIColor *)color
{
    self.bottomBorder.backgroundColor = color;
}

@end
