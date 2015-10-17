//
//  UIControl+Extents.h
//  PTKit
//
//  Created by LeeHu on 9/21/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Extents)

@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
@property (nonatomic, assign) NSTimeInterval ex_acceptEventInterval; // UIButton重复点击时间间隔
@property (nonatomic, assign) BOOL ex_ignoreEvent;

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets;

@end
