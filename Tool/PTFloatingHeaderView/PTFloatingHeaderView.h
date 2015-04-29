//
//  PTFloatingHeaderView.h
//  PTKit
//
//  Created by LeeHu on 4/23/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTFloatingHeaderView : UIView

@property (nonatomic, assign) BOOL viewIsFullScreen;
@property (nonatomic, assign) CGFloat floatingHeight;

- (void)updateScrollViewInsets:(UIScrollView *)scrollView;
- (void)resetScrollViewInsets:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)hideFloatView:(BOOL)animated;
- (void)showFloadView:(BOOL)animated;

@end
