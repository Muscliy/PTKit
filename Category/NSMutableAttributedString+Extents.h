//
//  NSMutableAttributedString+Extents.h
//  PTKit
//
//  Created by LeeHu on 15/2/9.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Extents)

+ (instancetype)attributeStringWithString:(NSString *)text
                                 spaceNum:(NSInteger)spaceNumPx
                                    color:(UIColor *)textColor
                                     font:(UIFont *)font
                                 fontSize:(CGFloat)size;

@end
