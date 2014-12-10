//
//  PTWebViewProgress.h
//  xmLife
//
//  Created by LeeHu on 14/12/8.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const float PTInitialProgressValue;
extern const float PTInteractiveProgressValue;
extern const float PTFinalProgressValue;


typedef void (^PTWebViewProgressBlock)(CGFloat progress);

@protocol PTWebViewProgressDelegate;

@interface PTWebViewProgress : NSObject<UIWebViewDelegate>

@property (nonatomic, weak) id<PTWebViewProgressDelegate> progressDelegate;
@property (nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;
@property (nonatomic, copy) PTWebViewProgressBlock progressBlock;

- (void)reset;

@end

@protocol PTWebViewProgressDelegate <NSObject>

@optional
- (void)webViewProgress:(PTWebViewProgress *)webViewProgress updatePogress:(CGFloat)progress;
@end
