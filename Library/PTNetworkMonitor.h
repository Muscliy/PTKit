//
//  PTNetworkMonitor.h
//  PTKit
//
//  Created by LeeHu on 12/7/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTNetworkMonitor : NSObject


+ (instancetype)shareInstance;

- (BOOL)isReachable;

// wifi
- (BOOL)isReachableWIFI;

// 2 3 4G
- (BOOL)isReachableWWAN;

- (void)notifyNetWorkFailed;


@end
