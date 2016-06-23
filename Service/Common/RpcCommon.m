//
//  RpcCommon.m
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "RpcCommon.h"

BOOL isJsonNull(id obj) {
	return !obj || obj == [NSNull null];
}

id toSafeValue(id obj) {
	if(!obj)
		return [NSNull null];
	return obj;
}


@implementation RpcCommon

@end
