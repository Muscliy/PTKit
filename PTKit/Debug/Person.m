//
//  Person.m
//  PTKit
//
//  Created by LeeHu on 12/25/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "Person.h"
#import "NSObject+Introspection.h"

@interface Person ()

@property (nonatomic, strong) NSString *father;

@end

@implementation Person {
    NSArray *_friends;
}

- (NSString *)description
{
    NSArray *keys = [[self class] ex_propertyKeys];
    NSMutableDictionary *dict = [@{} mutableCopy];
    for (NSString *key in keys) {
        [dict setValue:[self valueForKey:key] forKey:key];
    }
    return
        [NSString stringWithFormat:@"<%@ : %p, %@ >", NSStringFromClass([self class]), self, dict];
}

@end
