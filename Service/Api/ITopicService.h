//
//  ITopicService.h
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICallService.h"
#import "RpcContext.h"

@interface ITopicService : ICallService

+ (ITopicService *)create;

- (RpcContext *)getWeather:(NSString *)format onSuccess:(void (^)(id ret, RpcContext* context)) successBlock onFail:(void (^)(RpcContext* context)) failBlock;

- (void)getTopicHomePage:(NSInteger)page tab:(NSString *)tab limit:(NSInteger)limit mdrender:(NSString *)mdrender onSuccess:(void (^)(NSInteger ret, RpcContext* context)) successBlock onFail:(void (^)(RpcContext* context)) failBlock context:(RpcContext*) context invoke:(BOOL) invoke;
@end
