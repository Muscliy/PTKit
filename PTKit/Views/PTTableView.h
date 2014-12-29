//
//  PTTableView.h
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTTableViewDelegate <NSObject>

@optional
- (UIView *)getEmptyView;
- (UIView *)getErrorView;
- (UIView *)getLoadingView;

@end

@interface PTTableView : UITableView

@property (nonatomic, strong) UIView *guideView;
@property (nonatomic, weak) id<PTTableViewDelegate> guidedDelegate;

- (void)addGuideView:(UIView *)theGuideView;
- (void)showEmptyView;
- (void)showErrorGuideView;
- (void)showLoadingGuideView;
- (void)checkAndShowEmptyView;

@end
