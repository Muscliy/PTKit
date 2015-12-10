//
//  PTUIMathUtilities.h
//  xmLife
//
//  Created by LeeHu on 14/11/11.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PTScreen.h"

//------------------------

#pragma mark - Round pixel

//------------------------
CGFloat PTRoundPixelValueForScale(CGFloat f, CGFloat scale);
CGFloat PTRoundPixelValue(CGFloat f);
NSUInteger PTRoundPixIntValue(CGFloat f);
NSUInteger PTRoundLabelPixelValue(CGFloat f);

CGFloat PTRoundPixelSacle640Value(CGFloat f);
CGFloat PTRoundPixelSacle320Value(CGFloat f);

CGFloat PTRatio4InchWithCurrentPhoneSize();
