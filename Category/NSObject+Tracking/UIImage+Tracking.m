//
//  UIImage+Tracking.m
//  xmLife
//
//  Created by weihuazhang on 14/11/18.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "UIImage+Tracking.h"
#import "NSObject+Tracking.h"

@implementation UIImage (Tracking)

+ (void)load
{
    if (!PTOS_IOS7) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addMissingMethod:@selector(imageWithRenderingMode:)
                        withMethod:@selector(trackImageWithRenderingMode:)];
        });
    }
}

- (UIImage *)trackImageWithRenderingMode:(UIImageRenderingMode)renderingMode
{
    return self;
}

@end
