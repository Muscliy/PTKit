//
//  PTDevice.h
//  xmLife
//
//  Created by LeeHu on 14/11/19.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBDeviceInfo.h"

@interface PTDevice : GBDeviceInfo

+ (PTDevice *)deviceInfo;

- (BOOL)isPhone;

- (BOOL)isPad;

- (NSString *) uniqueAppIdentifier;

- (NSString *) uniqueGlobalDeviceIdentifier;

- (NSString *)getDeviceToken;

- (void)saveDeviceToken:(NSData *)token;

@end
