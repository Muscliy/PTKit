//
//  UINavigationBar+Extents.m
//  PTKit
//
//  Created by LeeHu on 4/24/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "UINavigationBar+Extents.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Extents)

- (void)setEx_colorLayer:(UIView *)ex_colorLayer
{
    SEL key = @selector(ex_colorLayer);
    objc_setAssociatedObject(self, key, ex_colorLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)ex_colorLayer
{
    UIView *__v__ = objc_getAssociatedObject(self, _cmd);
    return __v__;
}

- (void)ex_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.ex_colorLayer) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.ex_colorLayer = [[UIView alloc]
                              initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        self.ex_colorLayer.userInteractionEnabled = NO;
        self.ex_colorLayer.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.ex_colorLayer atIndex:0];
    }
    self.ex_colorLayer.backgroundColor = backgroundColor;
}

@end
