//
//  NSObject+AssociatedObject.m
//  PTKit
//
//  Created by LeeHu on 12/7/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "NSObject+AssociatedObject.h"
#import <objc/runtime.h>


@implementation NSObject (AssociatedObject)


- (instancetype)ex_object:(SEL)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)ex_setAssignObject:(id)object withKey:(SEL)key
{
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_ASSIGN);
}

- (void)ex_setRetainNonatomicObject:(id)object withKey:(SEL)key
{
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ex_setCopyNonatomicObject:(id)object withKey:(SEL)key
{
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ex_setRetainObject:(id)object withKey:(SEL)key
{
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ex_setCopyObject:(id)object withKey:(SEL)key
{
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
