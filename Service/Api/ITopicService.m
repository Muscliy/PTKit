//
//  ITopicService.m
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "ITopicService.h"
#import "RpcCommon.h"
#import "ServerConfig.h"

@implementation ITopicService

- (NSString *)getUrlPath:(NSString *)method {
	if ([method isEqualToString:@"getWeather" ]) {
		return @"demos/weather_sample/weather.php";
	}
	
	return nil;
}

- (NSString *)getRequestType:(NSString *)method
{
	if ([method isEqualToString:@"getWeather" ]) {
		return @"GET";
	}
	
	return @"POST";
}

- (NSString *)getMethodCategory:(NSString *)method
{
	if ([method isEqualToString:@"getWeather" ]) {
		return CONSTANTS_TOPIC_CATEGORY;
	}
	return CONSTANTS_DEFAULT_CATEGORY;
}

- (RpcContext *)getWeather:(NSString *)format onSuccess:(void (^)(id ret, RpcContext* context)) successBlock onFail:(void (^)(RpcContext* context)) failBlock {
	return [self getWeather:format onSuccess:successBlock onFail:failBlock context:nil];
}

- (RpcContext *)getWeather:(NSString *)format onSuccess:(void (^)(id ret, RpcContext* context)) successBlock onFail:(void (^)(RpcContext* context)) failBlock context:(RpcContext*) context
{
	return [self getWeather:format onSuccess:successBlock onFail:failBlock context:context invoke:YES];
}

- (RpcContext *)getWeather:(NSString *)format onSuccess:(void (^)(id ret, RpcContext* context)) successBlock onFail:(void (^)(RpcContext* context)) failBlock context:(RpcContext*) context invoke:(BOOL) invoke{
	void (^retBlock)(RpcContext* context)  = successBlock ? ^void(RpcContext* context) {
		id _jsonValue = [context getReturnObject];
		successBlock(_jsonValue, context);
	} : nil;
	
	if(!context) {
		context = [[RpcContext alloc] init];
	}
	
	NSMutableDictionary *_jsonDict = [@{} mutableCopy];
	[_jsonDict setObject:toSafeValue(format) forKey:@"format"];
	
	[context setInvokeArgs:self arg:_jsonDict onProgress:nil onSucess:retBlock onFail:failBlock onLoadedCache:nil methodName:@"getWeather"];
	if(invoke) {
		[context invoke];
	}
	return context;
}

- (RpcContext *)getTopicHomePage:(NSInteger)page tab:(NSString *)tab limit:(NSInteger)limit mdrender:(NSString *)mdrender onSuccess:(void (^)(id ret, RpcContext* context)) successBlock onFail:(void (^)(RpcContext* context)) failBlock context:(RpcContext*) context invoke:(BOOL) invoke {
	
	void (^retBlock)(RpcContext* context)  = successBlock ? ^void(RpcContext* context) {
		id _jsonValue = [context getReturnObject];
		successBlock(_jsonValue, context);
	} : nil;
	
	if(!context) {
		context = [[RpcContext alloc] init];
	}
	
	return context;
	
	
}

@end
