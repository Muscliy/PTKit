//
//  ICallService.h
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcServiceProtocol.h"

@interface ICallService : NSObject<RpcServiceProtocol>
{
	BOOL debugMode;
}

+ (instancetype)create;

-(instancetype) setDebugMode:(BOOL) debug;
-(BOOL) isDebugMode;

@end
