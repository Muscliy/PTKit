//
//  PTInfiniteScrollView.m
//  PTKit
//
//  Created by LeeHu on 14/12/12.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTInfiniteScrollView.h"
#import "PTInfinitePageView.h"

@interface PTInfiniteScrollView () {
}
@property (nonatomic, strong) NSMutableArray *visibleViews;
@property (nonatomic, strong) UIView *pageContainerView;

@end

@implementation PTInfiniteScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.contentSize = CGSizeMake(5000, 500);
        _visibleViews = [[NSMutableArray alloc] init];
        _pageContainerView = [[UIView alloc] init];
        _pageContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height / 2);
        [self addSubview:_pageContainerView];
        [_pageContainerView setUserInteractionEnabled:NO];
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
    }
    
    return self;
}

#pragma mark - Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0))
    {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        for (UILabel *label in self.visibleViews) {
            CGPoint center = [self.pageContainerView convertPoint:label.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            label.center = [self convertPoint:center toView:self.pageContainerView];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.pageContainerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tilePagesFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}


#pragma mark - Label Tiling

- (PTInfinitePageView *)insertPage
{
    PTInfinitePageView *page = [PTInfinitePageView randonPageView];
    [self.pageContainerView addSubview:page];
    
    return page;
}

- (CGFloat)placeNewPageOnRight:(CGFloat)rightEdge
{
    PTInfinitePageView *page = [self insertPage];
    [self.visibleViews addObject:page];
    
    CGRect frame = [page frame];
    frame.origin.x = rightEdge;
    frame.origin.y = [self.pageContainerView bounds].size.height - frame.size.height;
    [page setFrame:frame];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewPageOnLeft:(CGFloat)leftEdge
{
    PTInfinitePageView *page = [self insertPage];
    [self.visibleViews insertObject:page atIndex:0];
    
    CGRect frame = [page frame];
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = [self.pageContainerView bounds].size.height - frame.size.height;
    [page setFrame:frame];
    
    return CGRectGetMinX(frame);
}

- (void)tilePagesFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{

    if ([self.visibleViews count] == 0)
    {
        [self placeNewPageOnRight:minimumVisibleX];
    }
    
    UILabel *lastLabel = [self.visibleViews lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastLabel frame]);
    while (rightEdge < maximumVisibleX)
    {
        rightEdge = [self placeNewPageOnRight:rightEdge];
    }
    
    UILabel *firstLabel = self.visibleViews[0];
    CGFloat leftEdge = CGRectGetMinX([firstLabel frame]);
    while (leftEdge > minimumVisibleX)
    {
        leftEdge = [self placeNewPageOnLeft:leftEdge];
    }
    
    lastLabel = [self.visibleViews lastObject];
    while ([lastLabel frame].origin.x > maximumVisibleX)
    {
        [lastLabel removeFromSuperview];
        [self.visibleViews removeLastObject];
        lastLabel = [self.visibleViews lastObject];
    }
    
    firstLabel = self.visibleViews[0];
    while (CGRectGetMaxX([firstLabel frame]) < minimumVisibleX)
    {
        [firstLabel removeFromSuperview];
        [self.visibleViews removeObjectAtIndex:0];
        firstLabel = self.visibleViews[0];
    }
}

@end
