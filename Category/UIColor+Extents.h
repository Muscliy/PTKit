//
//  UIColor+Extents.h
//  PTKit
//
//  Created by LeeHu on 5/28/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extents)

+ (UIColor *)ex_colorFromHexRGB:(NSString *)inColorString;

+ (UIColor *)ex_colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)ex_colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

+ (UIColor *)ex_colorFromInt:(NSInteger)intValue;
- (BOOL)ex_isEqualToColor:(UIColor *)color;

@end
