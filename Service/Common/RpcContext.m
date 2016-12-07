//
//  RpcContext.m
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "RpcContext.h"
#import "RpcCall.h"
#import "JSONKit.h"
#import "RpcServiceProtocol.h"
#import "RpcUtil.h"
#import "HttpRequestConstants.h"
#import "RpcDelegateCenter.h"

@interface RpcContext() {
	NSInteger httpCode;
	NSInteger returnCode;
	long long startRequestTime;
	long long endRequestTime;
	BOOL canceled;
}

@property (nonatomic, copy) void (^argSuccessBlock)(RpcContext *context);
@property (nonatomic, copy) void (^argFailBlock)(RpcContext *context);
@property (nonatomic, copy) void (^argProgressBlock)(RpcContext *context);
@property (nonatomic, copy) void (^argCacheBlock)(RpcContext *context);
@property (nonatomic, strong) NSObject<RpcServiceProtocol> *argObj;
@property (nonatomic, strong) NSDictionary *argDict;
@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, copy) NSString *fullUrl;
@property(nonatomic, assign) id<RpcDelegate> delegate;


//status value
@property (nonatomic, copy) NSString *errorString;
@property(nonatomic, strong) id retObject;
@property (nonatomic, copy) NSString *uid;

@end


@implementation RpcContext

- (void)dealloc
{
	self.argSuccessBlock = nil;
	self.argFailBlock = nil;
	self.argCacheBlock = nil;
	self.argProgressBlock = nil;
	self.delegate = nil;
}

-(void)freeBlocks {
	self.argSuccessBlock = nil;
	self.argFailBlock = nil;
	self.argCacheBlock = nil;
	self.argProgressBlock = nil;
}

- (instancetype)init
{
	if ((self = [super init])) {
		
	}
	return self;
}

-(BOOL)setInvokeArgs:(NSObject<RpcServiceProtocol>*) obj arg:(NSDictionary *)arg onProgress:(void (^)(RpcContext *context))progressBlock onSucess:(void (^)(RpcContext *context))successBlock onFail:(void (^)(RpcContext *context))failBlock onLoadedCache:(void (^)(RpcContext *context))cacheBlock methodName:(NSString *)methodName {
	self.argObj = obj;
	self.argDict = arg;
	self.argSuccessBlock = successBlock;
	self.argFailBlock = failBlock;
	self.argCacheBlock = cacheBlock;
	self.argProgressBlock = progressBlock;
	self.methodName = methodName;
	return TRUE;
}

- (BOOL)invoke{
	[RpcCall invoke:self.argObj method:self.methodName parameters:self.argDict context:self];
	return YES;
}

- (void)setRequstDone:(BOOL)isOK
{
	endRequestTime = [RpcUtil getCurrentTimeMs];
	if(isOK) {
		if (self.argSuccessBlock) {
			self.argSuccessBlock(self);
		}
		[self freeBlocks];
	} else {
		if(self.argFailBlock) {
			self.argFailBlock(self);
		}
		[self freeBlocks];
	}
	
}

#pragma mark - systh

-(NSString*) getUserId {
	return self.uid;
}

-(void) setUserId:(NSString*) u {
	self.uid = u;
}


- (NSInteger)getHttpCode {
	return httpCode;
}

- (void)setHttpCode:(NSInteger)code
{
	httpCode = code;
}

-(BOOL) hasTimeouted {
	if(startRequestTime <= 0)
		return NO;
	long long time = endRequestTime;
	if(time < 1)
		time = [RpcUtil getCurrentTimeMs];
	return (time - startRequestTime) > (self.timeout * 1000 - 1000);
}

-(NSInteger) getReturnCode {
	return returnCode;
}

-(void) setReturnCode:(NSInteger) code {
	returnCode = code;
}

-(BOOL) isOK {
	return httpCode == HTTPREQUESTCONSTANTS_HTTP_CODE_OK;
}

-(NSString*)getErrorString
{
	return self.errorString;
}

-(void) setErrorString:(NSString*) s
{
	self.errorString = s;
}

-(NSString*) getDebugFullUrl
{
	return self.fullUrl;
}

-(id) getReturnObject
{
	return self.retObject;
}

-(void) setReturnObject:(id) obj
{
	self.retObject = obj;
}

-(void) setDebugFullUrl:(NSString*) url
{
	self.fullUrl = url;
}

-(NSString*) getClassName
{
	return [self.argObj getClassName];
}

-(NSString*) getSimpleClassName
{
	return [self.argObj getSimpleClassName];
}

-(NSString*) getMethodName
{
	return self.methodName;
}


-(id<RpcDelegate>) getRpcDelegate {
	if(self.delegate) {
		return self.delegate;
	}
	return [RpcDelegateCenter singleton];
}

-(void) setRpcDelegate:(id<RpcDelegate>) d {
	self.delegate = d;
}

@end
