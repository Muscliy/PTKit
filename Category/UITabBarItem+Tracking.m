//
//  UITabBarItem+Tracking.m
//  xmLife
//
//  Created by weihuazhang on 14/11/18.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "UITabBarItem+Tracking.h"
#import "NSObject+Tracking.h"

@implementation UITabBarItem (Tracking)

+ (void)load
{
    if (!PTOS_IOS7) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addMissingMethod:@selector(initWithTitle:image:selectedImage:)
                        withMethod:@selector(trackInitWithTitle:image:selectedImage:)];
        });
    }
}

- (instancetype)trackInitWithTitle:(NSString *)title
                             image:(UIImage *)image
                     selectedImage:(UIImage *)selectedImage
{
    return [self initWithTitle:title image:image tag:0];
}

@end
