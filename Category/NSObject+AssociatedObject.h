//
//  NSObject+AssociatedObject.h
//  PTKit
//
//  Created by LeeHu on 12/7/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AssociatedObject)

- (instancetype)ex_object:(SEL)key;

- (void)ex_setAssignObject:(id)object withKey:(SEL)key;

- (void)ex_setRetainNonatomicObject:(id)object withKey:(SEL)key;

- (void)ex_setCopyNonatomicObject:(id)object withKey:(SEL)key;

- (void)ex_setRetainObject:(id)object withKey:(SEL)key;

- (void)ex_setCopyObject:(id)object withKey:(SEL)key;

@end
