//
//  RpcServiceProtocol.h
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RpcServiceProtocol <NSObject>

@optional

- (NSString *)getCategory;
- (NSString *)getVersion;
- (NSString *)getClassName;
- (NSString *)getSimpleClassName;

- (NSString *)getUrlPath:(NSString *)method;
- (NSString *)getRequestType:(NSString *)method;

- (NSString *)getUrlPrefix:(NSString *)method;
- (NSString *)getFullUrl:(NSString *)method;
- (void)changeUrlPrefix:(NSString *)prefix;
- (NSString *)getMethodPathMap:(NSString *)method;

- (BOOL)isSecurity;
- (void)setSecurity:(BOOL)security;
- (void)addTryCount;

- (BOOL)isDebugMode;

- (void)setSupportWebsocketProxy:(BOOL)support;
- (BOOL)isSupportWebsocketProxy;

- (NSString *)getRpcContextId;
- (NSString *)getMethodCategory:(NSString *)method;

@end
