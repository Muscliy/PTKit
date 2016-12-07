//
//  PTTableView.h
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NITableViewModel;
@protocol PTTableViewDelegate;

@interface PTTableView : UITableView

@property (nonatomic, assign) UIEdgeInsets defaultScrollViewInsets;
@property (nonatomic, strong) UIView *guideView;
@property (nonatomic, weak) id<PTTableViewDelegate> ptDelegate;
@property (nonatomic, weak) NITableViewModel *model;

- (void)delayReloadData;

@end