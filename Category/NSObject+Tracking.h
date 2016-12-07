//
//  NSObject+Tracking.h
//  xmLife
//
//  Created by weihuazhang on 14-9-24.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tracking)

@property (nonatomic, readonly) NSString *pDescription;

+ (void)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_;
+ (void)swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_;
+ (void)addMissingMethod:(SEL)missSelector_ withMethod:(SEL)addSelector_;

- (void)printCallStack;

@end
