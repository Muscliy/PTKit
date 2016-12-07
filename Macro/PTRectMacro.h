//
//  XMRectMacro.h
//  xmLife
//
//  Created by leehu on 7/2/14.
//  Copyright (c) 2014 PaiTao. All rights reserved.
//

#ifndef xmLife_XMRectMacro_h
#define xmLife_XMRectMacro_h

#import "UIView+Frame.h"

#define kPTStatusBarHeight (20.f)

#define kTopBarHeight (44.f)
#define kBottomBarHeight (49.f)
#define k4InchScreenWith (320.0)
#define kCellDefaultHeight (44.f)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#endif
