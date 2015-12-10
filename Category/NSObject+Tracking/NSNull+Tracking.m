//
//  NSNull+Tracking.m
//  xmLife
//
//  Created by weihuazhang on 14-10-13.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "NSNull+Tracking.h"

#define NSNullObjects @[ @"", @0, @{}, @[] ]

@implementation NSNull (Tracking)

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *sig = [[NSNull class] instanceMethodSignatureForSelector:selector];
    if (sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    return sig;
}

@end
