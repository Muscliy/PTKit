//
//  RpcCall.h
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcServiceProtocol.h"

@class RpcContext;

@interface RpcCall : NSObject

+ (BOOL)invoke:(NSObject<RpcServiceProtocol> *)obj  method:(NSString *)method parameters:(NSDictionary *)parameters context:(RpcContext *)context;

@end
