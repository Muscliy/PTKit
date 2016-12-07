//
//  PTRefreshControl.m
//  PTKit
//
//  Created by LeeHu on 10/22/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTRefreshControl.h"
#import "PTRefreshContentView.h"

#define DISTANCE_TRIGGER 95.0

@interface PTRefreshControl () {
    struct {
        int isImplementRefreshDistanceOfTrigger : 1;
        int isImplementRefreshControlContentView : 1;
        int isImplementRefreshBeginPull : 1;
        int isImplementRefreshIsLoading : 1;
    } _datasourceRespondsTo;

    struct {
        int isImplementRefreshDidTriggerRefresh : 1;
    } _delegateRespondsTo;
}

@property (nonatomic, strong) PTRefreshContentView *contentView;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat startPoistion;
@property (nonatomic, assign) PTRefreshControlState state;
@property (nonatomic, assign) CGFloat progress;

@end

@implementation PTRefreshControl

- (instancetype)initWithFrame:(CGRect)frame style:(PTRefreshControlStyle)style
{
    if ((self = [super initWithFrame:frame])) {
        [self initData];
        self.style = style;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self initData];
    }
    return self;
}

- (instancetype)init
{
    if ((self = [super init])) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.distance = DISTANCE_TRIGGER;
    self.style = PTRefreshControlStyleHeader;
    self.state = PTRefreshControlStateNormal;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (CGRectEqualToRect(self.contentView.frame, CGRectZero)) {
        self.contentView.frame = CGRectMake(0, 0, self.ex_width, 60);
    }
}

- (void)setDataSource:(id<PTRefreshControlDataSource>)dataSource
{
    _dataSource = dataSource;
    _datasourceRespondsTo.isImplementRefreshDistanceOfTrigger =
        [_dataSource respondsToSelector:@selector(refreshControlDistanceOfLoadingTrigger:)];
    _datasourceRespondsTo.isImplementRefreshControlContentView =
        [_dataSource respondsToSelector:@selector(refreshControlContentView:)];
    _datasourceRespondsTo.isImplementRefreshBeginPull =
        [_dataSource respondsToSelector:@selector(refreshControlBeginPullAtScrollPosition:)];
    _datasourceRespondsTo.isImplementRefreshIsLoading =
        [_dataSource respondsToSelector:@selector(refreshControlIsLoading:)];
    if (!_datasourceRespondsTo.isImplementRefreshControlContentView) {
        _contentView = [[PTRefreshContentView alloc] initWithFrame:CGRectZero];
    } else {
        self.contentView = [_dataSource refreshControlContentView:self];
    }
    if (_datasourceRespondsTo.isImplementRefreshDistanceOfTrigger) {
        self.distance = [_dataSource refreshControlDistanceOfLoadingTrigger:self];
    }
    if (_datasourceRespondsTo.isImplementRefreshBeginPull) {
        self.startPoistion = [_dataSource refreshControlBeginPullAtScrollPosition:self];
    } else {
        self.startPoistion = 0;
    }
    [self addSubview:self.contentView];
}

- (void)setDelegate:(id<PTRefreshControlDelegate>)delegate
{
    _delegate = delegate;
    _delegateRespondsTo.isImplementRefreshDidTriggerRefresh =
        [_delegate respondsToSelector:@selector(refreshControlDidTriggerRefresh:)];
}

- (void)updateRefreshControlOriginPoint:(UIScrollView *)scrollView
{
    if (self.style == PTRefreshControlStyleFooter) {
        if (self.state == PTRefreshControlStateLoading) {
            self.contentView.hidden = NO;
        } else if (scrollView.isDragging) {
            self.contentView.hidden = NO;
        }
    }
}

- (BOOL)isPulling:(UIScrollView *)scrollView
{
    if (self.style == PTRefreshControlStyleHeader) {
        return scrollView.contentOffset.y < self.startPoistion;
    }
    self.startPoistion = scrollView.contentSize.height;
    return scrollView.contentSize.height - scrollView.contentOffset.y <
           scrollView.bounds.size.height;
}

- (BOOL)isDraggingToLoadPosition:(UIScrollView *)scrollView
{
    if (self.style == PTRefreshControlStyleHeader) {
        return scrollView.contentOffset.y <= (self.startPoistion - self.distance);
    }
    return scrollView.contentSize.height - scrollView.contentOffset.y <
           scrollView.bounds.size.height - self.distance;
}

- (BOOL)isLoading
{
    BOOL _loading = NO;
    if (_datasourceRespondsTo.isImplementRefreshIsLoading) {
        _loading = [_dataSource refreshControlIsLoading:self];
    }

    return _loading;
}

- (void)setControlLoadingContentInset:(UIScrollView *)scrollView isEndDragging:(BOOL)isEndDragging
{
    if (!isEndDragging) {
        if (self.style == PTRefreshControlStyleHeader) {
            CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
            offset = MIN(offset, -self.startPoistion + self.distance);
            if (scrollView.contentOffset.y >= (self.startPoistion - self.distance)) {
                scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
                NSLog(@"reset 1");
            }
        } else {
            CGFloat offset =
                MIN(scrollView.contentOffset.y,
                    scrollView.contentSize.height - scrollView.bounds.size.height + self.distance);
            offset = offset - (scrollView.contentSize.height - scrollView.bounds.size.height);
            if (scrollView.contentOffset.y <=
                (scrollView.contentSize.height - scrollView.bounds.size.height + self.distance)) {
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
                NSLog(@"reset 2");
            }
        }
        return;
    }
    if (self.style == PTRefreshControlStyleHeader) {

        if (scrollView.contentOffset.y >= (self.startPoistion - self.distance)) {
            scrollView.contentInset =
                UIEdgeInsetsMake(-self.startPoistion + self.distance, 0.0f, 0.0f, 0.0f);
             NSLog(@"reset 3");
        }
    } else {
        if (scrollView.contentOffset.y <=
            (scrollView.contentSize.height - scrollView.bounds.size.height + self.distance)) {
            scrollView.contentInset =
                UIEdgeInsetsMake(0.0f, 0.0f, self.startPoistion + self.distance, 0.0f);
            NSLog(@"reset 3");
        }
    }
}

- (void)resetScrollContentInset:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > self.startPoistion &&
        (self.style == PTRefreshControlStyleHeader)) {
        return;
    }

    if (scrollView.contentOffset.y <
            (scrollView.contentSize.height - scrollView.bounds.size.height) &&
        (self.style == PTRefreshControlStyleFooter)) {
        return;
    }
    PTWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:.25
          animations:^{
            PTStrongSelf;
            if (self.style == PTRefreshControlStyleHeader) {
                scrollView.contentInset = UIEdgeInsetsMake(-self.startPoistion, 0.0f, 0.0f, 0.0f);
            } else {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
          }
          completion:^(BOOL finished){
          }];
    });
}

- (void)setControlPullProgress:(UIScrollView *)scrollView
{
    if (self.style == PTRefreshControlStyleHeader) {
        self.progress =
            MAX((scrollView.contentOffset.y * -1 + self.startPoistion) / self.distance, 0.0);
        self.progress = MIN(self.progress, 1.0);
    } else {
        self.progress = MAX((scrollView.contentOffset.y -
                             (scrollView.contentSize.height - scrollView.bounds.size.height)) /
                                self.distance,
                            0.0);
        self.progress = MIN(self.progress, 1.0);
    }
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == PTRefreshControlStateLoading) {
        NSLog(@"contentoffset %@",NSStringFromCGPoint(scrollView.contentOffset));
        [self setControlLoadingContentInset:scrollView isEndDragging:NO];
    } else if ([self isPulling:scrollView] && scrollView.isDragging) {
        [self setControlPullProgress:scrollView];
        [self updateRefreshControlOriginPoint:scrollView];
        [self.contentView refreshControlPullingProgress:self.progress];
    } else {
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = [self isLoading];
    if ([self isDraggingToLoadPosition:scrollView] && !_loading) {
        if (_delegateRespondsTo.isImplementRefreshDidTriggerRefresh) {
            [_delegate refreshControlDidTriggerRefresh:self];
        }
        [self setState:PTRefreshControlStateLoading];
        [self.contentView refreshControlBeginLoading:YES];
        //[self setControlLoadingContentInset:scrollView isEndDragging:YES];
    }
}

- (void)refreshScrollViewDidFinishedLoading:(UIScrollView *)scrollView
{
    [self setState:PTRefreshControlStateNormal];
    [self resetScrollContentInset:scrollView];
    [self.contentView refreshControlFinishLoading:YES];
    if (self.style == PTRefreshControlStyleFooter) {
        self.contentView.hidden = YES;
    }
}

@end
