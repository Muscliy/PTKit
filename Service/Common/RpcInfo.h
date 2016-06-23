//
//  RpcInfo.h
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RpcInfo : NSObject

+ (RpcInfo *)singleton;
- (NSString *)getUserAgent;



@end
