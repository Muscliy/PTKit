//
//  UIControl+Extents.m
//  PTKit
//
//  Created by LeeHu on 9/21/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "UIControl+Extents.h"
#import <objc/runtime.h>

@implementation UIControl (Extents)

@dynamic hitTestEdgeInsets;
@dynamic ex_acceptEventInterval;
@dynamic ex_ignoreEvent;

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(__ex_sendAction:to:forEvent:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success =
        class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - property

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if (value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (NSTimeInterval)ex_acceptEventInterval
{
    NSNumber *interval = objc_getAssociatedObject(self, _cmd);
    if (interval) {
        return interval.doubleValue;
    }
    return 0;
}

- (void)setEx_acceptEventInterval:(NSTimeInterval)ex_acceptEventInterval
{
    SEL key = @selector(ex_acceptEventInterval);
    objc_setAssociatedObject(self, key, @(ex_acceptEventInterval),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ex_ignoreEvent
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.ex_ignoreEvent = NO;
    return NO;
}

- (void)setEx_ignoreEvent:(BOOL)ex_ignoreEvent
{
    SEL key = @selector(ex_ignoreEvent);
    objc_setAssociatedObject(self, key, @(ex_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - private method

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled ||
        self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

- (void)__ex_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (self.ex_ignoreEvent)
        return;
    if (self.ex_acceptEventInterval > 0) {
        self.ex_ignoreEvent = YES;
        [self performSelector:@selector(setEx_ignoreEvent:)
                   withObject:@(NO)
                   afterDelay:self.ex_acceptEventInterval];
    }
    [self __ex_sendAction:action to:target forEvent:event];
}


@end
