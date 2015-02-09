//
//  NSMutableAttributedString+Extents.m
//  PTKit
//
//  Created by LeeHu on 15/2/9.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "NSMutableAttributedString+Extents.h"
#import <CoreText/CoreText.h>


@implementation NSMutableAttributedString (Extents)

+ (instancetype)attributeStringWithString:(NSString *)text
                                 spaceNum:(NSInteger)spaceNumPx
                                    color:(UIColor *)textColor
                                     font:(UIFont *)font
                                 fontSize:(CGFloat)fontSize
{
    if (!text || [text isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSUInteger length = [attString length];
    
    //字间距
    if (spaceNumPx > 0) {
        NSNumber *space = @(spaceNumPx);
        [attString addAttribute:(id)kCTKernAttributeName value:space range:NSMakeRange(0, length)];
    }
    
    //字体颜色
    if (textColor) {
        [attString addAttribute:(id)NSForegroundColorAttributeName
                          value:(id)textColor
                          range:NSMakeRange(0, length)];
    }
    
    //字体 & 大小
    if (font && fontSize) {
        UIFont *usefont = nil;
        if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_0) {
            usefont = font;
        } else {
            usefont =
            CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName, fontSize, NULL));
        }
        
        [attString addAttribute:(id)kCTFontAttributeName
                          value:usefont
                          range:NSMakeRange(0, length)];
    }
    
    return attString;
}


@end
