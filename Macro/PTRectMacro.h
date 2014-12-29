//
//  XMRectMacro.h
//  xmLife
//
//  Created by leehu on 7/2/14.
//  Copyright (c) 2014 PaiTao. All rights reserved.
//

#ifndef xmLife_XMRectMacro_h
#define xmLife_XMRectMacro_h

#define Application_Frame [[UIScreen mainScreen] applicationFrame]

#define App_Frame_Height [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width [[UIScreen mainScreen] applicationFrame].size.width
#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width [[UIScreen mainScreen] bounds].size.width

#define X(v) (v).frame.origin.x
#define Y(v) (v).frame.origin.y
#define WIDTH(v) (v).frame.size.width
#define HEIGHT(v) (v).frame.size.height

#define MinX(v) CGRectGetMinX((v).frame)
#define MinY(v) CGRectGetMinY((v).frame)

#define MidX(v) CGRectGetMidX((v).frame)
#define MidY(v) CGRectGetMidY((v).frame)
#define MidInX(v) CGRectGetMidX((v).bounds)
#define MidInY(v) CGRectGetMidY((v).bounds)

#define MaxX(v) CGRectGetMaxX((v).frame)
#define MaxY(v) CGRectGetMaxY((v).frame)
#define MaxInX(v) CGRectGetMaxX((v).bounds)
#define MaxInY(v) CGRectGetMaxY((v).bounds)

#define Center(v) CGPointMake(MidX(v), MidY(v))
#define CenterIn(v) CGPointMake(MidInX(v), MidInY(v))

#define kPTStatusBarHeight (20.f)

#define kTopBarHeight (44.f)
#define kBottomBarHeight (49.f)

#define kCellDefaultHeight (44.f)

#define isRetina                                                                                   \
    ([UIScreen instancesRespondToSelector:@selector(currentMode)]                                  \
         ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)       \
         : NO)

#define isiPhone5                                                                                  \
    ([UIScreen instancesRespondToSelector:@selector(currentMode)]                                  \
         ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)      \
         : NO)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#endif
