//
//  RpcCommon.h
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL isJsonNull(id obj);
id toSafeValue(id obj);

@interface RpcCommon : NSObject

@end
