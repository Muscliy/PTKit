//
//  PTCollectionView.h
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTCollectionViewDelegate <NSObject>

@optional
- (UIView *)getEmptyView;
- (UIView *)getErrorView;
- (UIView *)getLoadingView;

@end


@interface PTCollectionView : UICollectionView

@property (nonatomic, assign) BOOL gestureLock;
@property (nonatomic, strong) UIView *guideView;
@property (nonatomic, weak) id<PTCollectionViewDelegate> guidedDelegate;
@property (nonatomic, strong) UIView *collectionHeaderView;
@property (nonatomic, strong) UIView *collectionFooterView;

- (void)checkAndShowEmptyView;

@end
