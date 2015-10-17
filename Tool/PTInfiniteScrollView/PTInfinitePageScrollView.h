//
//  PTInfinitePageScrollView.h
//  PTKit
//
//  Created by LeeHu on 9/24/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTInfinitePageScrollViewItem.h"

@class PTInfinitePageScrollView;

@protocol PTInfinitePageScrollViewDataSource <NSObject>

- (NSInteger)infinitePageScrollView:(PTInfinitePageScrollView *)infinitePageScrollView numberOfPages:(NSInteger)pages;

- (PTInfinitePageScrollViewItem *)infinitePageScrollView:(PTInfinitePageScrollView *)infinitePageScrollView itemForPageAtIndex:(NSInteger)index;

@optional
- (NSInteger)infinitePageScrollView:(PTInfinitePageScrollView *)infinitePageScrollView startFromPage:(NSInteger *)index;

@end

@interface PTInfinitePageScrollView : UIScrollView

@end
