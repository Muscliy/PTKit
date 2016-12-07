//
//  PTPushHandler.h
//  PTKit
//
//  Created by LeeHu on 10/17/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTPushHandler : NSObject

PTSingletonInterface;

+ (void)registerRemoteNotification;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;


@end
