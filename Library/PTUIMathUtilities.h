//
//  PTUIMathUtilities.h
//  PTKit
//
//  Created by LeeHu on 14/11/25.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTScreen.h"

//------------------------

#pragma mark - Round pixel

//------------------------
CGFloat PTRoundPixelValueForScale(CGFloat f, CGFloat scale);
CGFloat PTRoundPixelValue(CGFloat f);
NSInteger PTRoundPixIntValue(CGFloat f);