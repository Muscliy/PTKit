//
//  UIView+Extents.m
//  PTKit
//
//  Created by LeeHu on 8/25/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "UIView+Extents.h"

@implementation UIView (Extents)

- (UIImage*)ex_snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

- (void)ex_removeAllSubViews
{
    NSArray *views = [self subviews];
    [views makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
