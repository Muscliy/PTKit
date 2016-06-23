//
//  RpcContext.h
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RpcServiceProtocol;
@protocol RpcDelegate;
@interface RpcContext : NSObject

@property (nonatomic, assign) BOOL sync;
@property(nonatomic, assign) NSInteger timeout;

- (void)setRequstDone:(BOOL)isOK;

- (NSString *)getUserId;
- (void)setUserId:(NSString *)u;

-(NSInteger) getHttpCode;
-(void) setHttpCode:(NSInteger)code;

-(BOOL) hasTimeouted;
-(BOOL) hasHttpError;

-(NSInteger) getReturnCode;
-(void) setReturnCode:(NSInteger) code;
-(BOOL) isOK;

-(NSString*)getErrorString;
-(void) setErrorString:(NSString*) s;

-(id) getReturnObject;
-(void) setReturnObject:(id) obj;

-(NSString*) getDebugFullUrl;
-(void) setDebugFullUrl:(NSString*) url;

-(NSString*) getClassName;
-(NSString*) getSimpleClassName;
-(NSString*) getMethodName;

-(id<RpcDelegate>) getRpcDelegate;


-(BOOL)setInvokeArgs:(NSObject<RpcServiceProtocol>*) obj arg:(NSDictionary *)arg onProgress:(void (^)(RpcContext *context))progressBlock onSucess:(void (^)(RpcContext *context))successBlock onFail:(void (^)(RpcContext *context))failBlock onLoadedCache:(void (^)(RpcContext *context))cacheBlock methodName:(NSString *)methodName;

- (BOOL)invoke;

@end
