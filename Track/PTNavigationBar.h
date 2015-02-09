//
//  PTNavigationBar.h
//  PTKit
//
//  Created by LeeHu on 15/2/6.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

static CGFloat const kDefaultNavigationBarAlpha = 0.70f;

@interface PTNavigationBar : UINavigationBar

@property (strong, nonatomic) IBInspectable UIColor *color;

-(void)setNavigationBarWithColor:(UIColor *)color;

@end

