//
//  PTMediaDeviceAuthorize.h
//  PTKit
//
//  Created by LeeHu on 15/2/7.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kMediaDeviceCamera = 1,
    kMediaDeviceAlbum,
    kMediaDeviceMicroPhone,
    kMediaDeviceLocation,
    kMediaDeviceUndefined
} MediaDeviceType;

typedef void (^completion)(NSInteger authorizationStatus, BOOL granted);
typedef void (^handler)(BOOL grant);

@interface PTMediaDeviceAuthorize : NSObject

+ (void)isMediaDeviceAvailable:(MediaDeviceType)type
             completionHandler:(void (^)(BOOL granted))handler;
+ (void)isMediaDeviceAvailable:(MediaDeviceType)type
   shouldRequestAccessForMedia:(BOOL)bRequest
             completionHandler:(void (^)(BOOL granted))handler;
+ (void)showMediaAuthorizedAlert:(NSString *)title content:(NSString *)content;
+ (void)showMicPhoneAccessFailed;


@end
