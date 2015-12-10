//
//  PTWebViewProgressView.h
//  xmLife
//
//  Created by LeeHu on 14/12/8.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTWebViewProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIView *progressBarView;
@property (nonatomic, assign) NSTimeInterval barAnimationDuration;
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration;
@property (nonatomic, assign) NSTimeInterval barSlowAnimationDuration;
@property (nonatomic, assign) NSTimeInterval fadeOutDelay;

- (void)setProgress:(CGFloat)progress animted:(BOOL)animated;

@end
