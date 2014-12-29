//
//  PTCollectionView.m
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTCollectionView.h"

@implementation PTCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
    }
    return self;
}

- (instancetype)init
{
    if ((self = [super init])) {
    }
    return self;
}

- (void)setCollectionHeaderView:(UIView *)collectionHeaderView
{
    if (_collectionHeaderView == collectionHeaderView) {
        return;
    }
    [_collectionHeaderView removeFromSuperview];
    _collectionHeaderView = collectionHeaderView;
    [self addSubview:_collectionHeaderView];
    [self.collectionViewLayout invalidateLayout];
}

- (void)setCollectionFooterView:(UIView *)collectionFooterView
{
    if (_collectionFooterView == collectionFooterView) {
        return;
    }
    [_collectionFooterView removeFromSuperview];
    _collectionFooterView = collectionFooterView;
    [self addSubview:_collectionFooterView];
    [self.collectionViewLayout invalidateLayout];
}

- (void)addGuideView:(UIView *)theGuideView
{
    if (self.guideView == theGuideView)
        return;
    [self.guideView removeFromSuperview];
    self.guideView = theGuideView;
    [self addSubview:self.guideView];
    [self.guideView setHidden:NO];
    [self bringSubviewToFront:self.guideView];
}

- (void)checkAndShowEmptyView
{
    NSUInteger sections =
        [self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]
            ? [self.dataSource numberOfSectionsInCollectionView:self]
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

- (void)showLoadingGuidView
{
    if ([self.guidedDelegate respondsToSelector:@selector(getLoadingView)]) {
        UIView *theGuidedView = [self.guidedDelegate getLoadingView];
        [self addGuideView:theGuidedView];
    }
}

- (void)reloadData
{
    [super reloadData];
}


@end
