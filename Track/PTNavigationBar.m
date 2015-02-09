//
//  PTNavigationBar.m
//  PTKit
//
//  Created by LeeHu on 15/2/6.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTNavigationBar.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat kEndPoint = 1.5;

@interface PTNavigationBar ()
@end

@implementation PTNavigationBar

-(void)awakeFromNib
{
    [super awakeFromNib];
    if (self.color) {
        [self setNavigationBarWithColor:self.color];
    } else {
        [self setNavigationBarWithColor:[UIColor whiteColor]];
    }
}
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)setNavigationBarWithColor:(UIColor *)color
{
    UIImage *image = [self imageWithColor:color];
    
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self setBarStyle:UIBarStyleDefault];
    [self setShadowImage:[UIImage new]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self setTintColor:[UIColor whiteColor]];
    [self setTranslucent:YES];
    
}

@end
