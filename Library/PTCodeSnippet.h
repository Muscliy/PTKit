//
//  PTCodeSnippet.h
//  PTKit
//
//  Created by LeeHu on 14/12/11.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "EXTScope.h"

#ifndef PTKit_PTCodeSnippet_h
#define PTKit_PTCodeSnippet_h

#undef PTWeak
#define PTWeak(...) @weakify(__VA_ARGS__)
#define PTWeakSelf PTWeak(self);

#undef PTStrong
#define PTStrong(...) @strongify(__VA_ARGS__)
#define PTStrongSelf PTStrong(self);

#define PT_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \


#define PTViewBorderRadius(View, Radius, Width, Color)\\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


#define kApplication        [UIApplication sharedApplication]

#define kKeyWindow          [UIApplication sharedApplication].keyWindow

#define kAppDelegate        [UIApplication sharedApplication].delegate

#define kUserDefaults      [NSUserDefaults standardUserDefaults]

#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kSystemVersion [[UIDevice currentDevice] systemVersion]

#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


// path NSCachesDirectory

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define kTempPath NSTemporaryDirectory()

#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define kDownloadPath(file)                                                                         \
[DocumentsDirectory stringByAppendingPathComponent:([NSString stringWithFormat:@"%@", file])]

// gcd
#define PT_dispatch_back(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define PT_dispatch_main(block) dispatch_async(dispatch_get_main_queue(),block)


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

#define PTPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif
