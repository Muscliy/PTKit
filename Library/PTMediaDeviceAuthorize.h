//
//  PTMediaDeviceAuthorize.h
//  PTKit
//
//  Created by LeeHu on 15/2/7.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PTMediaDeviceType) {
	PTMediaDeviceCamera = 0,
	PTMediaDeviceAlbum,
	PTMediaDeviceMicroPhone,
	PTMediaDeviceLocation,
	PTMediaDeviceUndefined
};

typedef void (^completion)(NSInteger authorizationStatus, BOOL granted);
typedef void (^handler)(BOOL grant);

@interface PTMediaDeviceAuthorize : NSObject

+ (void)isMediaDeviceAvailable:(PTMediaDeviceType)type
             completionHandler:(void (^)(BOOL granted))handler;
+ (void)isMediaDeviceAvailable:(PTMediaDeviceType)type
   shouldRequestAccessForMedia:(BOOL)bRequest
             completionHandler:(void (^)(BOOL granted))handler;
+ (void)showMediaAuthorizedAlert:(NSString *)title content:(NSString *)content;
+ (void)showMicPhoneAccessFailed;

@end

NS_ASSUME_NONNULL_END