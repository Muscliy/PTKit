//
//  UISearchBar+Extents.m
//  PTKit
//
//  Created by LeeHu on 6/2/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "UISearchBar+Extents.h"
#import "PTAssert.h"
#import <CoreText/CoreText.h>

@implementation UISearchBar (Extents)

- (UITextField *)ex_textField
{
    for (UIView *subView in self.subviews) {
        for (UIView *ssubView in subView.subviews) {
            if ([ssubView isKindOfClass:[UITextField class]]) {
                UITextField *ssTextField = (UITextField *)ssubView;
                return ssTextField;
            }
        }
    }
    PTASSERT(@"没有找到");
    return nil;
}

- (void)ex_setPlaceholderTextColor:(UIColor *)color
{
    UITextField *textField = [self ex_textField];
    if ([textField.placeholder length] < 1) {
        return;
    }
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:textField.attributedPlaceholder];
        NSRange range = [textField.placeholder rangeOfString:textField.placeholder];
        [attString addAttribute:(id)kCTForegroundColorAttributeName value:color range:range];
        textField.attributedPlaceholder = attString;
    }
}

- (void)ex_setPlaceholderTextFont:(UIFont *)font
{
    UITextField *textField = [self ex_textField];
    if ([textField.placeholder length] < 1) {
        return;
    }
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:textField.attributedPlaceholder];
        NSRange range = [textField.placeholder rangeOfString:textField.placeholder];
        [attString addAttribute:(id)kCTFontAttributeName value:font range:range];
        textField.attributedPlaceholder = attString;
    }
}

- (void)ex_setTextFieldLeftView:(UIView *)view
{
    UITextField *textField = [self ex_textField];
    textField.leftView = view;
}

@end
