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
#import "extobjc.h"

#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 793.00
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_6_1
#define kCFCoreFoundationVersionNumber_iOS_6_1 793.00
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_1
#define kCFCoreFoundationVersionNumber_iOS_7_1 847.24
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1129.15
#endif

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
// path NSCachesDirectory
#define DocumentsDirectory                                                                         \
    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define DownloadFile(file)                                                                         \
    [DocumentsDirectory stringByAppendingPathComponent:([NSString stringWithFormat:@"%@", file])]

// singleton

#undef PTSingletonInterface
#define PTSingletonInterface +(instancetype)sharedInstance;

#undef PTSingletonImplementation
#define PTSingletonImplementation                                                                  \
    +(instancetype)sharedInstance                                                                  \
    {                                                                                              \
        static dispatch_once_t once;                                                               \
        static id __singleton__ = nil;                                                             \
        dispatch_once(&once, ^{ __singleton__ = [[self alloc] init]; });                           \
        return __singleton__;                                                                      \
    }

#undef PTInstance
#define PTInstance(CLASSNAME) [CLASSNAME sharedInstance]

#undef PTWeak
#define PTWeak(...) @weakify(__VA_ARGS__)
#define PTWeakSelf PTWeak(self);

#undef PTStrong
#define PTStrong(...) @strongify(__VA_ARGS__)
#define PTStrongSelf PTStrong(self);


#define PTPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

// pop-MCAnimate

#define MCANIMATE_SHORTHAND

#endif
