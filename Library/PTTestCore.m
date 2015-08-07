//
//  PTTestCore.m
//  PTKit
//
//  Created by LeeHu on 14/12/13.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTTestCore.h"

@implementation PTTestCore

+ (UIColor *)colorForNumber:(NSNumber *)num
{
    return [UIColor colorWithHue:((19 * num.intValue) % 255) / 255.f
                      saturation:1.f
                      brightness:1.f
                           alpha:1.f];
}

@end
