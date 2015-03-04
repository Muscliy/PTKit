//
//  UIDevice+Extents.h
//  PTKit
//
//  Created by LeeHu on 15/2/11.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

typedef enum tagDeviceType {
    Device_iPhoneNone,
    Device_iPhoneSimulator,
    
    Device_iPhone1G,
    Device_iPhone3G,
    Device_iPhone3GS,
    Device_iPhone4,
    Device_iPhone4S,
    Device_iPhoneLater,
    
    Device_iPodTouch1G,
    Device_iPodTouch2G,
    Device_iPodTouch3G,
    Device_iPodTouch4G,
    Device_iPodTouchLater,
    
    Device_iPad1,
    Device_iPad2,
    Device_iPad3,
    Device_iPadLater,
} DeviceType;

#define SYSTEM_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface UIDevice (Extents)

+ (NSString *)getDeviceUserName;
+ (NSString *)getDeviceToken;
+ (void)saveDeviceToken:(NSData *)token;
+ (DeviceType)deviceVersion;

@end