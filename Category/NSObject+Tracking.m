//
//  NSObject+Tracking.m
//  xmLife
//
//  Created by weihuazhang on 14-9-24.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "NSObject+Tracking.h"
#include <objc/objc.h>
#include <objc/runtime.h>
#include <objc/message.h>
#import <JRSwizzle/JRSwizzle.h>
#import "PTLogger.h"

@implementation NSObject (Tracking)

+ (void)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_
{
    NSError *error = nil;
    [self jr_swizzleMethod:origSel_ withMethod:altSel_ error:&error];
}

+ (void)swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_
{
    NSError *error = nil;
    [self jr_swizzleClassMethod:origSel_ withClassMethod:altSel_ error:&error];
}

+ (void)addMissingMethod:(SEL)missSelector withMethod:(SEL)addSelector
{
    Method addMethod = class_getInstanceMethod(self, addSelector);
    if (!addMethod) {
        PTLogError(@"addMissSelector method %@ not found for class %@",
                   NSStringFromSelector(addSelector), [self class]);
        return;
    }
    class_addMethod(self, missSelector, class_getMethodImplementation(self, addSelector),
                    method_getTypeEncoding(addMethod));
}

+ (void)swizzleAllBaseTrackingMethod
{
    [self swizzleMethod:@selector(doesNotRecognizeSelector:)
             withMethod:@selector(trackDoesNotRecognizeSelector:)];
}

- (NSString *)pDescription
{
    NSMutableString *descriptionString = [@"" mutableCopy];

    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);

    for (NSUInteger i = 0; i < propertyCount; i++) {
        NSString *selector = [NSString stringWithCString:property_getName(properties[i])
                                                encoding:NSUTF8StringEncoding];
        SEL sel = sel_registerName([selector UTF8String]);

        const char *rawAttributeString = property_getAttributes(properties[i]);
        NSString *attributeString = [NSString stringWithUTF8String:rawAttributeString];
        NSArray *attributeArray = [attributeString componentsSeparatedByString:@","];
        NSString *attributeType = [attributeArray objectAtIndex:0];
        NSString *propertyType = [attributeType substringFromIndex:1];
        const char *rawPropertyType = [propertyType UTF8String];

        NSString *formatString = nil; //[[NSString alloc] init];
        if (strcmp(rawPropertyType, @encode(char)) == 0) {
            formatString = @"%s : %d\r ";
        } else if (strcmp(rawPropertyType, @encode(unsigned char)) == 0) {
            formatString = @"%s : %u\r ";
        } else if (strcmp(rawPropertyType, @encode(short)) == 0) {
            formatString = @"%s : %d\r ";
        } else if (strcmp(rawPropertyType, @encode(unsigned short)) == 0) {
            formatString = @"%s : %u\r ";
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            formatString = @"%s : %d\r ";
        } else if (strcmp(rawPropertyType, @encode(unsigned int)) == 0) {
            formatString = @"%s : %u\r ";
        } else if (strcmp(rawPropertyType, @encode(long)) == 0) {
            formatString = @"%s : %ld\r ";
        } else if (strcmp(rawPropertyType, @encode(unsigned long)) == 0) {
            formatString = @"%s : %lu\r ";
        } else if (strcmp(rawPropertyType, @encode(long long)) == 0) {
            formatString = @"%s : %lld\r ";
        } else if (strcmp(rawPropertyType, @encode(unsigned long long)) == 0) {
            formatString = @"%s : %llu\r ";
        } else if (strcmp(rawPropertyType, @encode(float)) == 0) {
            formatString = @"%s : %f\r ";
        } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
            formatString = @"%s : %f\r ";
        } else if ([propertyType hasPrefix:@"@"]) {
            formatString = @"%s : %@\r ";
        } else {
            continue;
        }
    }

    free(properties);

    [descriptionString insertString:@"{\r " atIndex:0];
    [descriptionString appendString:@"}\r"];

    return descriptionString;
}

#pragma mark - doesNotRecognizeSelector

- (void)printCallStack
{
    // 打印当前调用栈
    NSArray *callStack = [NSThread callStackSymbols];
    for (NSString *symbol in callStack) {
        PTLogInfo(@"%@", symbol);
    }
}

- (void)trackDoesNotRecognizeSelector:(SEL)aSelector
{
    NSString *strClass = nil;
    NSString *strSel = nil;
    NSString *expReason = @"reason";
    @try {
        strClass = [[self class] description];
        strSel = NSStringFromSelector(aSelector);
        PTLogError(@"doesNotRecognizeSelector() class=%@ selector=%@", strClass, strSel);
        // 打印当前调用栈
        [self printCallStack];

        [self trackDoesNotRecognizeSelector:aSelector];
    }
    @catch (NSException *exception)
    {
        // 打印当前调用栈
        [self printCallStack];
    }
#if !TARGET_IPHONE_SIMULATOR
    @catch (...)
    {
        // 打印当前调用栈
        [self printCallStack];
    }
#endif
    @finally
    {
    }
    //必须要抛异常出去给外面捕获，不然会直接crassh
    NSException *e =
        [NSException exceptionWithName:@"doesNotRecognizeSelector" reason:expReason userInfo:nil];
    @throw e;
}

@end

@interface NSObjectBaseTracking : NSObject

@end

@implementation NSObjectBaseTracking

+ (void)load
{
    [NSObject swizzleAllBaseTrackingMethod];
}

@end
