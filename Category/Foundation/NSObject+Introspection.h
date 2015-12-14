//
//  NSObject+Introspection.h
//  PTKit
//
//  Created by LeeHu on 12/14/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Introspection)
+ (NSArray *)ex_classes;
+ (NSArray *)ex_properties;
+ (NSArray *)ex_instanceVariables;
+ (NSArray *)ex_classMethods;
+ (NSArray *)ex_instanceMethods;

+ (NSArray *)ex_protocols;
+ (NSDictionary *)ex_descriptionForProtocol:(Protocol *)proto;


+ (NSString *)ex_parentClassHierarchy;
@end
