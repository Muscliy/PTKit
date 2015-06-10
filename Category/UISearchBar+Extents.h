//
//  UISearchBar+Extents.h
//  PTKit
//
//  Created by LeeHu on 6/2/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (Extents)

- (UITextField *)ex_textField;
- (void)ex_setPlaceholderTextColor:(UIColor *)color;
- (void)ex_setPlaceholderTextFont:(UIFont *)font;
- (void)ex_setTextFieldLeftView:(UIView *)view;

@end
