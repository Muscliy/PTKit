//
//  RpcCall.m
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "RpcCall.h"
#import "AFNetworking.h"
#import "RpcContext.h"
#import "RpcServiceProtocol.h"
#import "AFSecurityPolicy.h"
#import "HttpRequestConstants.h"
#import "PTLogger.h"
#import "RpcDelegateCenter.h"
#import "IReturnCode.h"

@implementation RpcCall

+ (BOOL) shouldLog:(NSObject<RpcServiceProtocol> *)obj {
	if (![obj isDebugMode]) {
		return FALSE;
	}
	return TRUE;
}

+ (BOOL)invoke:(NSObject<RpcServiceProtocol> *)obj
        method:(NSString *)method
       parameters:(NSDictionary *)parameters
       context:(RpcContext *)context
{

	RpcDelegateCenter* delegate = [context getRpcDelegate];

	
	NSMutableString *fullUrl = [@"" mutableCopy];
	[fullUrl appendString:[obj getFullUrl:method]];
	
	
    NSURL *baseUrl = [NSURL URLWithString:[obj getUrlPrefix:method]];

	AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
	AFHTTPRequestSerializer *requestSerializer = sessionManager.requestSerializer;
	[requestSerializer setValue:[delegate getUserAgent] forHTTPHeaderField:@"User-Agent"];
	[requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	
	if ([baseUrl.absoluteString hasPrefix:@"https"]) {
		sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
	}
	
	//get request Type POST OR GET
	NSString *requestType = [obj getRequestType:method];
	
	// retuen abs_path  @"IAddressService/getAddress/"
	NSString *urlPath = [obj getUrlPath:method];
	
	if (obj.isDebugMode) {
		[context setDebugFullUrl:@"dsjl"];
	}
	
	if ([requestType isEqualToString:@"POST"]) {
		[sessionManager POST:urlPath parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
			[self onProgress:obj context:context progress:uploadProgress];
		} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			[self onSuccess:obj context:context task:task responseObject:responseObject];
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			[self onFailure:obj conetxt:context task:task error:error];
		}];
	} else if ([requestType isEqualToString:@"GET"]) {
		
		[sessionManager GET:urlPath parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
			[self onProgress:obj context:context progress:downloadProgress];
		} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			[self onSuccess:obj context:context task:task responseObject:responseObject];
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			[self onFailure:obj conetxt:context task:task error:error];
		}];
	}
    return YES;
}

+ (void)onProgress:(NSObject<RpcServiceProtocol> *)obj context:(RpcContext *)context progress:(NSProgress *)progress {
	
}

+ (void)onSuccess:(NSObject<RpcServiceProtocol> *)obj context:(RpcContext *)context task:(NSURLSessionTask *)task responseObject:(id _Nullable)responseObject{
	
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
	if (httpResponse.statusCode == HTTPREQUESTCONSTANTS_HTTP_CODE_DECRYPT_FAIL) {
		
	}
	
	if(httpResponse.statusCode != HTTPREQUESTCONSTANTS_HTTP_CODE_OK && httpResponse.statusCode != HTTPREQUESTCONSTANTS_HTTP_CODE_DIFF_PATCH && httpResponse.statusCode !=HTTPREQUESTCONSTANTS_HTTP_CODE_NOT_MODIFIED) {
		[self onFailure:obj conetxt:context task:task error:nil];
		return ;
	}
	
	if(httpResponse.statusCode == HTTPREQUESTCONSTANTS_HTTP_CODE_NOT_MODIFIED) {
		//TODO: etag jobs
	} else {
	
	}
	if (httpResponse.statusCode == HTTPREQUESTCONSTANTS_HTTP_CODE_OK) {
		
	}
	
	if (![self onServerReturn:obj context:context task:task responseObject:responseObject]) {
		[context setRequstDone:NO];
	}
	//TODO version update
	
}

+ (BOOL)onServerReturn:(NSObject<RpcServiceProtocol> *)obj context:(RpcContext *)context task:(NSURLSessionTask *)task responseObject:(id _Nullable)responseObject {
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
	NSInteger statusCode = httpResponse.statusCode;
	RpcDelegateCenter* delegate = [context getRpcDelegate];
	if([RpcCall shouldLog:obj]) {
	
	}
	NSString* currentUid = [delegate getUid];
	NSString* requestUid = [context getUserId];
	if(statusCode == HTTPREQUESTCONSTANTS_HTTP_CODE_NOT_MODIFIED) {
		statusCode = HTTPREQUESTCONSTANTS_HTTP_CODE_OK;
	}
	[context setHttpCode:httpResponse.statusCode];
	
	if(requestUid && ![currentUid isEqualToString:requestUid]) {
		[context setReturnCode:IRETURNCODE_USER_CHANGED];
		[context setErrorString:@"user changed"];
		return FALSE;
	}
	
	[context setReturnObject:responseObject];
	[context setRequstDone:YES];
	return TRUE;
}

+ (void)onFailure:(NSObject<RpcServiceProtocol> *)obj conetxt:(RpcContext *)context task:(NSURLSessionTask *)task error:(NSError *)error{
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
	if (httpResponse.statusCode == HTTPREQUESTCONSTANTS_HTTP_CODE_NOT_MODIFIED) {
		
	} else {
		
		if (httpResponse.statusCode == HTTPREQUESTCONSTANTS_HTTP_CODE_DECRYPT_FAIL) {
			//加密失败
		}
		
		if([RpcCall shouldLog:obj]) {
			PTLog(@"%@ request error=%@",[context getDebugFullUrl],error)
		}
		NSString *errorStr = [NSString stringWithFormat:@"%@", error];
		
		[context setHttpCode:httpResponse.statusCode];
		[context setErrorString:errorStr];
		[context setRequstDone:NO];
	}
	
}

@end
