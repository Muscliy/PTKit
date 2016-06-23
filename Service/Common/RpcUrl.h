//
//  RpcUrl.h
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcServiceProtocol.h"

@interface RpcUrl : NSObject

+ (NSString *)RpcBaseUrl:(NSObject<RpcServiceProtocol> *)obj method:(NSString *)method;

@end
