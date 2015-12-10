//
//  PTRefreshControl.h
//  PTKit
//
//  Created by LeeHu on 10/22/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PTRefreshControlStyle) {
    PTRefreshControlStyleHeader = 0,
    PTRefreshControlStyleFooter,
};

typedef NS_ENUM(NSInteger, PTRefreshControlState) {
    PTRefreshControlStatePulling = 0,
    PTRefreshControlStateNormal,
    PTRefreshControlStateLoading,
};


@class PTRefreshContentView;
@class PTRefreshControl;

@protocol PTRefreshControlDataSource <NSObject>

@required
- (BOOL)refreshControlIsLoading:(PTRefreshControl *)control;

@optional
- (CGFloat)refreshControlDistanceOfLoadingTrigger:(PTRefreshControl *)control;
- (CGFloat)refreshControlBeginPullAtScrollPosition:(PTRefreshControl *)control;
- (PTRefreshContentView *)refreshControlContentView:(PTRefreshControl *)control;
@end

@protocol PTRefreshControlDelegate <NSObject>

- (void)refreshControlDidTriggerRefresh:(PTRefreshControl *)control;

@end

@interface PTRefreshControl : UIView

@property (nonatomic, weak) id<PTRefreshControlDataSource> dataSource;
@property (nonatomic, weak) id<PTRefreshControlDelegate> delegate;
@property (nonatomic, assign) PTRefreshControlStyle style;

- (instancetype)initWithFrame:(CGRect)frame style:(PTRefreshControlStyle)style;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidFinishedLoading:(UIScrollView *)scrollView;

@end
