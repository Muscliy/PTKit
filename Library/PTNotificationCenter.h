//
//  PTNotificationCenter.h
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTAppDelegate <NSObject>

@optional
- (void)onNetworkError;
- (void)onSignout;
- (void)onKickout;
- (void)onUserBlocked;
- (void)onDeviceBlocked;
- (void)onLoginSuccess;
- (void)onNetworkFailed;
- (void)onNetworkSuccess;

@end

@interface PTNotificationCenter : NSObject

+ (PTNotificationCenter *)defaultCenter;

- (void)addDeletegate:(id<PTAppDelegate>)d;
- (void)removeDeletegate:(id<PTAppDelegate>)d;
- (void)notifyNetworkError;
- (void)notifySignout;
- (void)notifyKickout;
- (void)notifyUserBlocked;
- (void)notifyDeviceBlocked;
- (void)notifyLoginSuccess;
- (void)notifyNetWorkFailed;
- (void)notifyNetWorkSuccess;

@end
