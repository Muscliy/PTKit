//
//  RpcDelegateCenter.m
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "RpcDelegateCenter.h"
#import "HttpRequestConstants.h"
#import "RpcUtil.h"
#import "RpcContext.h"
#import "PTLogger.h"

@implementation RpcDelegateCenter

static RpcDelegateCenter *instance = nil;

+ (RpcDelegateCenter *) singleton {
	@synchronized (self) {
		if (instance == nil) {
			instance = [[RpcDelegateCenter alloc] init];
			return instance;
		}
	}
	return instance;
}

-(instancetype) init {
	if((self = [super init])) {
	}
	return self;
}

- (NSString *)getSesionKey {
	NSString* ret = [self.delegate getSesionKey];
	[RpcUtil checkUnSafeLetter:ret onlyAscii:TRUE];
	return ret;
}

-(NSString*) getUid {
	NSString* ret = [self.delegate getUid];
	[RpcUtil checkUnSafeLetter:ret onlyAscii:TRUE];
	return ret;
}

-(NSString*) getDeviceId {
	NSString* ret = [self.delegate getDeviceId];
	[RpcUtil checkUnSafeLetter:ret onlyAscii:TRUE];
	return ret;
}

-(NSString*) getAcceptLanguage {
	NSString* ret = [self.delegate getAcceptLanguage];
	[RpcUtil checkUnSafeLetter:ret onlyAscii:TRUE];
	return ret;
}

-(NSInteger) getClientType {
	return [self.delegate getClientType];
}

-(void) onRpcKickOut:(NSInteger) returnCode
{
	[self.delegate onRpcKickOut:returnCode];
}

-(void) onNeedUpgrade:(NSString*) version {
	[self.delegate onNeedUpgrade:version];
}

-(BOOL) onProcessResponse:(RpcContext*) context {
	BOOL ret = [self.delegate onProcessResponse:context];
	if(ret) {
		PTLog(@"%@.%@ onProcessResponse already processed", [context getSimpleClassName], [context getMethodName]);
	}
	return ret;
}

-(void) onSessionChanged:(NSString*) newSession {
	return [self.delegate onSessionChanged:newSession];
}

-(NSString*) getVersionStr {
	NSString* ret = [self.delegate getVersionStr];
	[RpcUtil checkUnSafeLetter:ret onlyAscii:TRUE];
	return ret;
}

-(NSString*) getDeviceModel {
	NSString* ret = [self.delegate getDeviceModel];
	[RpcUtil checkUnSafeLetter:ret onlyAscii:TRUE];
	return ret;
}

-(NSString*) getDeviceVersion {
	NSString* ret = [self.delegate getDeviceVersion];
	[RpcUtil checkUnSafeLetter:ret onlyAscii:TRUE];
	return ret;
}

-(NSInteger) getScreenWidth {
	return [self.delegate getScreenWidth];
}

-(NSInteger) getScreenHeight {
	return [self.delegate getScreenHeight];
}

-(NSString*) getDeviceToken {
	NSString* ret = [self.delegate getDeviceToken];
	[RpcUtil checkUnSafeLetter:ret onlyAscii:TRUE];
	return ret;
}

-(NSString*) getDataDir {
	return [self.delegate getDataDir];
}

-(NSString*) getUserAgent {
	NSString* ret = [self.delegate getUserAgent];
	[RpcUtil checkUnSafeLetter:ret onlyAscii:TRUE];
	return ret;
}

-(int) getScreenScale {
	return [self.delegate getScreenScale];
}

-(int) getNetworkType {
	return [self.delegate getNetworkType];
}

-(BOOL) isUrlCached:(NSString*) url {
	return [self.delegate isUrlCached:url];
}

@end
