//
//  UITextField+Tracking.m
//  xmLife
//
//  Created by weihuazhang on 14-8-14.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "UITextField+Tracking.h"
#import "NSObject+Tracking.h"
#import "PTColorMacro.h"

@implementation UITextField (Tracking)

+ (void)load
{
    if (PTOS_IOS7) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self swizzleMethod:@selector(initWithFrame:)
                     withMethod:@selector(trackInitWithFrame:)];
        });
    }
}

- (id)trackInitWithFrame:(CGRect)frame
{
    typeof(self) retView = [self trackInitWithFrame:frame];
    if (![NSStringFromClass([retView class]) isEqualToString:@"UISearchBarTextField"]) {
        retView.tintColor = COLOR_CURSOR;
    }

    return retView;
}

@end
