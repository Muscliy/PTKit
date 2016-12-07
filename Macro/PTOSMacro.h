//
//  XMOSMacro.h
//  xmLife
//
//  Created by leehu on 7/5/14.
//  Copyright (c) 2014 PaiTao. All rights reserved.
//

#ifndef PTKit_PTOSMacro_h
#define PTKit_PTOSMacro_h

#import <Foundation/Foundation.h>

//================================================================================================
// 判断系统版本

#define PT_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define PTOS_IOS5 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0)
#define PTOS_IOS6 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0)
#define PTOS_IOS7 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
#define PTOS_IOS8 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0)

#define PTOS_GE(os) (kCFCoreFoundationVersionNumber >= os)
#define PTOS_LE(os) (kCFCoreFoundationVersionNumber <= os)

//================================================================================================

// pop-MCAnimate

#define MCANIMATE_SHORTHAND

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

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start);

#endif
