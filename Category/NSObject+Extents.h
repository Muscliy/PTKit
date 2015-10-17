//
//  NSObject+Extents.h
//  PTKit
//
//  Created by LeeHu on 8/17/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extents)

+ (NSArray *)classes;
+ (NSArray *)properties;
+ (NSArray *)instanceVariables;
+ (NSArray *)classMethods;
+ (NSArray *)instanceMethods;

+ (NSArray *)protocols;
+ (NSDictionary *)descriptionForProtocol:(Protocol *)proto;


+ (NSString *)parentClassHierarchy;

@end
