//
//  UIImage+Extents.m
//  PTKit
//
//  Created by LeeHu on 15/2/9.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "UIImage+Extents.h"

@implementation UIImage (Extents)

+ (UIImage *)imageNamed:(NSString *)name edge:(UIEdgeInsets)edge
{
    if (nil == name || name.length < 1) {
        return nil;
    }
    
    return [[UIImage imageNamed:name] imageResize:edge];
}

- (UIImage *)imageResize:(UIEdgeInsets)edge
{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
        // iOS 6.x code
        return [self resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeTile];
    } else if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        // iOS 5.x code
        return [self resizableImageWithCapInsets:edge];
    } else {
        // iOS 4.x code
        return [self stretchableImageWithLeftCapWidth:edge.right topCapHeight:edge.bottom];
    }
}


@end
