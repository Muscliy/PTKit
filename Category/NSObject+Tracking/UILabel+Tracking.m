//
//  UILabel+Tracking.m
//  xmLife
//
//  Created by weihuazhang on 14-9-24.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "UILabel+Tracking.h"
#import "NSObject+Tracking.h"

@implementation UILabel (Tracking)

+ (void)load
{
    if (!PTOS_IOS7) {
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
    self.backgroundColor = [UIColor clearColor];

    return retView;
}

@end
