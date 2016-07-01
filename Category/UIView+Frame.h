//
//  UIView+Frame.h
//  PTKit
//
//  Created by LeeHu on 7/1/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// shortcuts for frame properties
@property (nonatomic, assign) CGPoint ex_origin;
@property (nonatomic, assign) CGSize ex_size;

// shortcuts for positions
@property (nonatomic) CGFloat ex_centerX;
@property (nonatomic) CGFloat ex_centerY;


@property (nonatomic) CGFloat ex_top;
@property (nonatomic) CGFloat ex_bottom;
@property (nonatomic) CGFloat ex_right;
@property (nonatomic) CGFloat ex_left;

@property (nonatomic) CGFloat ex_width;
@property (nonatomic) CGFloat ex_height;

@end
