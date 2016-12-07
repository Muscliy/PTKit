//
//  RpcInfo.m
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "RpcInfo.h"
#import "RpcDelegateCenter.h"
#import "VersionControl.h"
#import "PTDevice.h"
#import "PTLogger.h"
#import "RpcContext.h"
#import "PTNotificationCenter.h"
#import "LocalUserInfo.h"
#import "IReturnCode.h"
#import "NetWorkType.h"
#import "NetWorkMonitor.h"

@interface RpcInfo ()<RpcDelegate>

@end

@implementation RpcInfo
static RpcInfo *instance = nil;

+ (RpcInfo *)singleton
{
	@synchronized(self)
	{
	if (instance == nil) {
		instance = [[RpcInfo alloc] init];
		return instance;
	}
	}
	return instance;
}

+ (void)initialize
{
	[RpcInfo singleton];
}

- (id)init
{
	self = [super init];
	if (self) {
		[RpcDelegateCenter singleton].delegate = self;
	}
	return self;
}

- (NSString *)getSesionKey
{
	return @"dsl";
}

- (NSString *)getVersionStr
{
	return [VersionControl appBuildVersion];
}

- (NSInteger)getClientVersion
{
	return [VersionControl appVersionInt];
}

- (NSInteger)getClientType
{
	return 1;
}

- (NSString *)getUid
{
	return @"dsnld";
}

- (NSString *)getDeviceModel
{
	return [[PTDevice deviceInfo] modelString];
}

- (NSString *)getDeviceVersion
{
	return [[UIDevice currentDevice] systemVersion];
}

- (NSInteger)getScreenWidth
{
	return [[UIScreen mainScreen] bounds].size.width;
}

- (NSInteger)getScreenHeight
{
	return [[UIScreen mainScreen] bounds].size.height;
}

- (NSString *)getDeviceId
{
	return [[PTDevice deviceInfo] uniqueGlobalDeviceIdentifier];
}

- (NSString *)getDeviceToken
{
	return [[PTDevice deviceInfo] getDeviceToken];
}

- (int)getScreenScale
{
	return 1;
}

- (void)onSessionChanged:(NSString *)newSession
{
	PTLogDebug(@"onSessionChanged: %@", newSession);
	[LocalUserInfo saveSessionId:newSession];
}

- (NSString *)getAcceptLanguage
{
	return nil;
}

- (int)getNetworkType
{
	if ([NetWorkMonitor shareInstance].isReachableWIFI) {
		return NETWORKTYPE_WIFI;
	} else if ([NetWorkMonitor shareInstance].isReachableWWAN) {
		return NETWORKTYPE_TWOG;
	} else {
		return NETWORKTYPE_NONE;
	}
}


- (void)onRpcKickOut:(NSInteger)sesssionCode
{
	[[PTNotificationCenter defaultCenter] notifyKickout];
}

- (BOOL)onProcessResponse:(RpcContext *)context
{
	if ([context getUserId] && [context getReturnCode] == IRETURNCODE_BLOCKED_USERID) {
		[[PTNotificationCenter defaultCenter] notifyUserBlocked];
		return TRUE;
	} else if ([context getUserId] && [context getReturnCode] == IRETURNCODE_BLOCKED_DEVICEID) {
		[[PTNotificationCenter defaultCenter] notifyDeviceBlocked];
		return TRUE;
	} else if ([context getHttpCode] == 503) {
		//维护中
		return FALSE;
	}
	return FALSE;
}

static NSString *gDataDir = nil;
- (NSString *)getDataDir
{
	if (gDataDir) {
		return gDataDir;
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if (paths.count < 1)
		return nil;
	gDataDir = [[paths objectAtIndex:0] copy];
	return gDataDir;
}

static NSString *g_agentCache = nil;
- (NSString *)getUserAgent
{
	if (!g_agentCache) {
		@synchronized([RpcInfo class])
		{
		if (!g_agentCache) { // Xl_c//custom/1
			g_agentCache = [[NSString
							 stringWithFormat:@"Xl_c (%@; %@; %@; %zdx%zd)", [self getDeviceModel],
							 [self getDeviceVersion], [self getVersionStr],
							 (long)[self getScreenWidth], [self getScreenHeight]] copy];
		}
		}
	}
	return g_agentCache;
}

- (void)onNeedUpgrade:(NSString *)version
{
}
@end
