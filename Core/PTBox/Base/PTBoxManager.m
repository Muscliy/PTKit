//
//  PTBoxManager.m
//  xmLife
//
//  Created by weihuazhang on 14/10/31.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTBoxManager.h"

@interface PTBoxManager ()
@property (nonatomic, strong) NSMutableDictionary *boxGroupDictionary;
@end

@implementation PTBoxManager

+ (instancetype)sharedInstance
{
    static PTBoxManager *s_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[[self class] alloc] init];
    });
    return s_instance;
}

- (instancetype)init
{
    if ((self = [super init])) {
		_boxGroupDictionary = [@{} mutableCopy];
    }
    return self;
}

- (void)registerBoxGroup:(PTBoxGroup *)boxGroup forType:(id)types
{
    if (boxGroup == nil || types == nil) {
        return;
    }

    if ([types isKindOfClass:[NSArray class]]) {
        for (id type in types) {
            [self.boxGroupDictionary setValue:boxGroup forKey:type];
        }
    } else {
        [self.boxGroupDictionary setValue:boxGroup forKey:types];
    }
}

- (PTBoxGroup *)boxGroupForType:(id)type
{
    if (!type) {
        return nil;
    }
    return self.boxGroupDictionary[type];
}

@end
