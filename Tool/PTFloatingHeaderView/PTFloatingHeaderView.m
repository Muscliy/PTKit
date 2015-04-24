//
//  PTFloatingHeaderView.m
//  PTKit
//
//  Created by LeeHu on 4/23/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTFloatingHeaderView.h"
#import "PTLogger.h"
#define FLOATTING_HEIGHT 44

@interface PTFloatingHeaderView ()

@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat startPointY;
@property (nonatomic) CGFloat lastScrollPosition;

@end

@implementation PTFloatingHeaderView {
    BOOL _isBeingDragged;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        self.floatingHeight = FLOATTING_HEIGHT;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.height = self.frame.size.height;
    self.startPointY = -self.floatingHeight;
    self.lastScrollPosition = -self.floatingHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)layoutSubviews
{
    self.height = self.frame.size.height;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.height = frame.size.height;
}

- (void)showFloatingHeaderView
{
}

- (void)updateScrollViewInsets:(UIScrollView *)scrollView
{
    UIEdgeInsets originalInset = scrollView.contentInset;
    UIEdgeInsets updatedInset = UIEdgeInsetsMake(self.height, originalInset.left,
                                                 originalInset.bottom, originalInset.right);
    scrollView.contentInset = updatedInset;
    scrollView.scrollIndicatorInsets = updatedInset;
}

- (void)resetScrollViewInsets:(UIScrollView *)scrollView
{
    UIEdgeInsets originalInset = scrollView.contentInset;
    UIEdgeInsets updatedInset =
        UIEdgeInsetsMake(0, originalInset.left, originalInset.bottom, originalInset.right);
    scrollView.contentInset = updatedInset;
    scrollView.scrollIndicatorInsets = updatedInset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    PTLogDebug(@"scrollViewWillBeginDragging %lf", scrollView.contentOffset.y);
    CGRect oriFrame = self.frame;
    if (scrollView.contentOffset.y <= -self.height) {
        PTLogDebug(@"scrollView.contentOffset.y <= -self.floatingHeight");
        oriFrame.origin.y = 0;
        self.frame = oriFrame;
        self.lastScrollPosition = -self.floatingHeight;
        return;
    }

    CGFloat scrollViewOffset = scrollView.contentOffset.y - self.lastScrollPosition;
    self.lastScrollPosition = scrollView.contentOffset.y;
    if (scrollViewOffset > 0) {
        PTLogDebug(@"scrollViewOffset > 0");
        CGRect desFrame = CGRectOffset(oriFrame, 0, -scrollViewOffset);
        if (desFrame.origin.y < -self.floatingHeight) {
            desFrame.origin.y = -self.floatingHeight;
        }
        if (!CGRectEqualToRect(oriFrame, desFrame)) {
            self.frame = desFrame;
        }
        PTLogDebug(@"scrollViewWillBeginDragging");
    } else {
        CGRect desFrame = CGRectOffset(oriFrame, 0, -scrollViewOffset);
        if (desFrame.origin.y > 0) {
            desFrame.origin.y = 0;
        }
        if (!CGRectEqualToRect(oriFrame, desFrame)) {
            self.frame = desFrame;
        }
        PTLogDebug(@"scrollViewWillBeginDragging");
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    PTLogDebug(@"scrollViewWillBeginDragging %lf", scrollView.contentOffset.y);
    self.lastScrollPosition = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    PTLogDebug(@"scrollViewDidEndDragging %lf", scrollView.contentOffset.y);
    if (!decelerate) {
        [self modifyScrollowViewOffset:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    PTLogDebug(@"scrollViewWillBeginDecelerating %lf", scrollView.contentOffset.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    PTLogDebug(@"scrollViewDidEndDecelerating %lf", scrollView.contentOffset.y);
}

- (void)modifyScrollowViewOffset:(UIScrollView *)scrollView
{
    PTLogDebug(@"modifyScrollowViewOffset %lf", scrollView.contentOffset.y);
    CGRect oriFrame = self.frame;
    if (oriFrame.origin.y < -(self.floatingHeight / 2)) {
        if (oriFrame.origin.y > -self.floatingHeight) {
            CGPoint contentOffset = scrollView.contentOffset;
            contentOffset.y -= -self.floatingHeight - oriFrame.origin.y;
            [scrollView setContentOffset:contentOffset animated:YES];
        }
    } else {
        if (oriFrame.origin.y < 0) {
            CGPoint contentOffset = scrollView.contentOffset;
            contentOffset.y -= 0 - oriFrame.origin.y;
            [scrollView setContentOffset:contentOffset animated:YES];
        }
    }
}

#pragma mark - Private

- (void)hideFloatView:(BOOL)animated
{
    CGRect oriFrame = self.frame;
    oriFrame.origin.y = -self.floatingHeight;
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                           self.frame = oriFrame;
                         }];
    } else {
        self.frame = oriFrame;
    }
}

- (void)showFloadView:(BOOL)animated
{
    CGRect oriFrame = self.frame;
    oriFrame.origin.y = 0;
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                           self.frame = oriFrame;
                         }];
    } else {
        self.frame = oriFrame;
    }
}

@end
