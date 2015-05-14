//
//  PTPagerTabStripButtonBarView.h
//  PTKit
//
//  Created by LeeHu on 5/7/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPagerTabStripViewController.h"

@interface PTPagerTabStripButtonBarView : UICollectionView

@property (nonatomic, strong, readonly) UIView *selectedBar;
@property (nonatomic, strong) UIFont *lableFont;
@property (nonatomic, assign) NSUInteger leftRightMargin;

- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated swipeDirection:(PTPagerTabStripDirection)swiperDirection;

- (void)moveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex withProgressPercentage:(CGFloat)progressPercenttage;

@end
