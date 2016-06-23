//
//  ICallService.m
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "ICallService.h"
#import "ServerConfig.h"

@implementation ICallService

+ (instancetype)create
{
	return [[[self class] alloc] init];	
}

-(instancetype) setDebugMode:(BOOL) debug {
#if defined(DEBUG) || defined(NI_DEBUG)
	debugMode = debug;
#endif
	return self;
}

-(BOOL) isDebugMode {
#if defined(DEBUG) || defined(NI_DEBUG)
	return debugMode;
#else
	return false;
#endif
}


- (NSString *)getCategory
{
    return @"Default";
}

- (NSString *)getUrlPath:(NSString *)method
{
    return nil;
}

- (NSString *)getFullUrl:(NSString *)method
{
    return
        [NSString stringWithFormat:@"%@%@", [self getUrlPrefix:method], [self getUrlPath:method]];
}

- (NSString *)getUrlPrefix:(NSString *)method
{
    return [[ServerConfig getUrls:[self getMethodCategory:method]] firstObject];
}

- (NSString *)getRequestType:(NSString *)method
{
	return @"POST";
}

@end
