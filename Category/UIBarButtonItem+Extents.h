//
//  UIBarButtonItem+Extents.h
//  PTKit
//
//  Created by LeeHu on 15/2/9.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extents)
+ (UIBarButtonItem *)leftIconItemTarget:(id)target
                                 action:(SEL)action
                             normalIcon:(NSString *)nPath
                          highlightIcon:(NSString *)hPath;

+ (UIBarButtonItem *)rightIconItemTarget:(id)target
                                  action:(SEL)action
                              normalIcon:(NSString *)nPath
                           highlightIcon:(NSString *)hPath;

+ (UIBarButtonItem *)leftTitleItemTarget:(id)target action:(SEL)action text:(NSString *)text;

+ (UIBarButtonItem *)rightAttriTitleItemTarget:(id)target
                                        action:(SEL)action
                                          text:(NSString *)text
                                     withSpace:(NSInteger)space
                                         color:(UIColor *)color
                                          font:(UIFont *)font
                                      fontSize:(CGFloat)fontSize;

+ (UIBarButtonItem *)backButtonItemTarget:(id)target action:(SEL)action;

@end
