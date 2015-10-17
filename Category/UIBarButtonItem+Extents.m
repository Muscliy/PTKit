//
//  UIBarButtonItem+Extents.m
//  PTKit
//
//  Created by LeeHu on 15/2/9.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "UIBarButtonItem+Extents.h"
#import "UIImage+Extents.h"
#import "NSMutableAttributedString+Extents.h"

@implementation UIBarButtonItem (Extents)

+ (UIBarButtonItem *)ex_leftIconItemTarget:(id)target
                                    action:(SEL)action
                                normalIcon:(NSString *)nPath
                             highlightIcon:(NSString *)hPath;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageNormal = [UIImage imageNamed:nPath];

    UIImage *selected = [UIImage imageNamed:hPath];

    [button setImage:imageNormal forState:UIControlStateNormal];
    [button setImage:selected forState:UIControlStateHighlighted];
    [button setImage:selected forState:UIControlStateDisabled];

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 36, 44);

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    barButton.width = 44;
    return barButton;
}

+ (UIBarButtonItem *)ex_rightIconItemTarget:(id)target
                                     action:(SEL)action
                                 normalIcon:(NSString *)nPath
                              highlightIcon:(NSString *)hPath;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageNormal = [UIImage imageNamed:nPath];

    UIImage *selected = [UIImage imageNamed:hPath];

    [button setImage:imageNormal forState:UIControlStateNormal];
    [button setImage:selected forState:UIControlStateHighlighted];

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, imageNormal.size.width > 30 ? imageNormal.size.width : 30,
                              imageNormal.size.height > 30 ? imageNormal.size.height : 30);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
}

+ (UIBarButtonItem *)leftTitleItemTarget:(id)target action:(SEL)action text:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageNormal = [UIImage imageNamed:@"butn_navigation"];
    imageNormal = [imageNormal imageResize:UIEdgeInsetsMake(7, 7, 7, 7)];

    UIImage *selected = [UIImage imageNamed:@"butn_navigation_in"];
    selected = [selected imageResize:UIEdgeInsetsMake(7, 7, 7, 7)];

    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:selected forState:UIControlStateHighlighted];

    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button
        setTitleShadowColor:
            [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:0.5]
                   forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame =
        CGRectMake(0, 0, 50, imageNormal.size.height > 50 ? imageNormal.size.height : 50);

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    return barButton;
}

+ (UIBarButtonItem *)ex_backButtonItemTarget:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageNormal = [UIImage imageNamed:@"button_back_up"];
    UIImage *selected = [UIImage imageNamed:@"button_back_down"];
    [button setImage:imageNormal forState:UIControlStateNormal];
    [button setImage:selected forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, imageNormal.size.width > 30 ? imageNormal.size.width : 30,
                              imageNormal.size.height > 30 ? imageNormal.size.height : 30);

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
}

+ (UIBarButtonItem *)ex_rightAttriTitleItemTarget:(id)target
                                           action:(SEL)action
                                             text:(NSString *)text
                                        withSpace:(NSInteger)space
                                            color:(UIColor *)color
                                             font:(UIFont *)font
                                         fontSize:(CGFloat)fontSize
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    UIImage *imageNormal = [UIImage imageNamed:@"butn_navigation_in"];
    imageNormal = [imageNormal imageResize:UIEdgeInsetsMake(7, 7, 7, 7)];
    UIImage *selected = [UIImage imageNamed:@"butn_navigation"];
    selected = [selected imageResize:UIEdgeInsetsMake(7, 7, 7, 7)];

    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:selected forState:UIControlStateHighlighted];

    NSMutableAttributedString *buttonString =
        [NSMutableAttributedString attributeStringWithString:text
                                                    spaceNum:space
                                                       color:color
                                                        font:font
                                                    fontSize:fontSize];

    [button setAttributedTitle:buttonString forState:UIControlStateNormal];
    [button setAttributedTitle:buttonString forState:UIControlStateHighlighted];
    [button setAttributedTitle:buttonString forState:UIControlStateDisabled];

    button.titleLabel.shadowOffset = CGSizeMake(0, 1);

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame =
        CGRectMake(0, 0, 50, imageNormal.size.height > 50 ? imageNormal.size.height : 50);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
}

@end
