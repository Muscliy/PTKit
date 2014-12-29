//
//  PTTableView.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTTableView.h"

@implementation PTTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ((self = [super initWithFrame:frame style:style])) {
    }
    return self;
}

- (void)addGuideView:(UIView *)theGuideView
{
    self.separatorStyle = UITableViewCellSelectionStyleNone;
    if (self.guideView == theGuideView) {
        return;
    }
    [self.guideView removeFromSuperview];
    self.guideView = theGuideView;
    [self addSubview:self.guideView];
    [self.guideView setHidden:NO];
    [self bringSubviewToFront:self.guideView];
}

- (void)checkAndShowEmptyView
{
    NSInteger sections =
    [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]
    ? [self.dataSource numberOfSectionsInTableView:self]
    : 0;
    BOOL isEmpty = sections == 0;
    if (!isEmpty) {
        [self.guideView removeFromSuperview];
        return;
    }
    
    [self showEmptyView];
}

- (void)showEmptyView
{
    if ([self.guidedDelegate respondsToSelector:@selector(getEmptyView)]) {
        UIView *theGuidedView = [self.guidedDelegate getEmptyView];
        [self addGuideView:theGuidedView];
    }
}

- (void)showErrorGuideView
{
    if ([self.guidedDelegate respondsToSelector:@selector(getErrorView)]) {
        UIView *theGuidedView = [self.guidedDelegate getErrorView];
        [self addGuideView:theGuidedView];
    }
}

- (void)showLoadingGuideView
{
    if ([self.guidedDelegate respondsToSelector:@selector(getLoadingView)]) {
        UIView *theGuidedView = [self.guidedDelegate getLoadingView];
        [self addGuideView:theGuidedView];
    }
}


@end
