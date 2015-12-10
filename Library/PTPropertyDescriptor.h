//
//  PTPropertyDescriptor.h
//  PTKit
//
//  Created by LeeHu on 12/1/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTPropertyDescriptor : NSObject

@property (nonatomic, readonly) NSString *defaultsKey;
@property (nonatomic, readonly) BOOL isSetter;
@property (nonatomic, readonly) NSString *type;

- (instancetype)initWithDefaultsKey:(NSString *)defaultsKey type:(NSString *)type isSetter:(BOOL)isSetter;

@end
