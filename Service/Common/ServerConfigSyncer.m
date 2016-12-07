//
//  ServerConfigSyncer.m
//  PTKit
//
//  Created by LeeHu on 6/22/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "ServerConfigSyncer.h"
#import "RpcInfo.h"
#import "LocalUserInfo.h"
#import "JSONKit.h"
#import "ServerConfig.h"

@interface ServerConfigSyncer ()
{
	BOOL started;
	long long lastSyncTime;
	BOOL syncing;
	BOOL hasSyncedData;
}
@end

@implementation ServerConfigSyncer


static ServerConfigSyncer *instance = nil;

+ (ServerConfigSyncer *) singleton {
	@synchronized (self) {
		if (instance == nil) {
			instance = [[ServerConfigSyncer alloc] init];
			return instance;
		}
	}
	return instance;
}


-(void) sync {
	[self performSelectorInBackground:@selector(doSyncServerInfo:) withObject:nil];
}

-(void) start {
	if(started)
		return;
	[RpcInfo singleton];
	NSString* path = [self getJsonFile];
	NSFileManager *manager = [NSFileManager defaultManager];
	if([manager fileExistsAtPath:path]) {
		[manager removeItemAtPath:path error:nil];
	}
	
	[self loadServerInfo];
	started = YES;
#if defined(DEBUG) || defined(CC_DEBUG)
	//[self doSyncServerInfo:@(0)];
	[self syncAllData];
#else
	[self doSyncServerInfo:@(0)];
#endif
}

-(void) loadServerInfo {
#if defined(DEBUG) || defined(CC_DEBUG)
	NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
	NSString* serverKey = [userData valueForKey:@"_debug_server_key"];
	if(serverKey != nil && serverKey.length > 0) {
		[self syncAllData];
		return ;
	}
#endif
	
	NSString* path = [self getJsonFile];
	if(!path) {
		return ;
	}
	
	NSData* data = [NSData dataWithContentsOfFile:path];
	if(!data)
		return ;
	NSDictionary* dict = [data objectFromJSONData];
	if(![dict isKindOfClass:[NSDictionary class]])
		return ;
	
	if([dict count] < 1)
		return ;
	
	[self setToServerConfig:dict];
	return ;
}


-(void) setToServerConfig:(NSDictionary*) dict {
	for(NSString* key in dict) {
		NSArray* arr = [dict valueForKey:key];
		if(!arr || ![arr isKindOfClass:[NSArray class]])
			continue;
		[ServerConfig setUrls:key urls:arr serverTypeKey:@"production"];
	}
	
#if 0
	//[ServerConfig setDefaultUrls:@[@"http://192.168.6.12:8080/kiss-product/"]];
	[ServerConfig setUrls:CC_CATEGORY_IM urls:@[@"http://192.168.7.211:9080/JsonServerTest/"]];
	[ServerConfig setUrls:CC_CATEGORY_LONG urls:@[@"ws://192.168.7.211:9090/websocket"]];
#endif
}


-(void) syncAllData {
	if(hasSyncedData)
		return;
	hasSyncedData = YES;
	if([LocalUserInfo hasUserLogined]) {
		//[[CCDataSyncer singleton] doSync];
//		[[KissIMClient singleton] createClient:getCurrentUser()];
	 
	}
}

-(void) doSyncServerInfo:(NSNumber*) repeat
{

}

- (NSString *)getJsonFile {
	return [self getConfigPath:@"ServerInfo"];
}

- (NSString *)getConfigPath:(NSString *)fileName
{
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,
															  YES) objectAtIndex:0];
	NSString *path = [rootPath stringByAppendingPathComponent:@"configs"];
	NSFileManager *manager = [NSFileManager defaultManager];
	[manager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
	path = [path stringByAppendingPathComponent:fileName];
	return path;
}

@end
