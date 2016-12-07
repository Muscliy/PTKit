//
//  PTNetworkMonitor.m
//  PTKit
//
//  Created by LeeHu on 12/7/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "PTNetworkMonitor.h"
#import "AFNetworkReachabilityManager.h"
#import "PTNotificationCenter.h"

#define Reachability_Tag_Baidu 8001
#define Reachability_Tag_QQ 8002
#define Reachability_Tag_Apple 8003

#define Reachability_Host_Baidu @"www.baidu.com"
#define Reachability_Host_QQ @"www.qq.com"
#define Reachability_Host_Apple @"www.apple.com"


@interface PTNetworkMonitor ()

@property (nonatomic, assign) AFNetworkReachabilityStatus netStatus;

@end

@implementation PTNetworkMonitor


+ (instancetype)shareInstance
{
    static PTNetworkMonitor *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ shareInstance = [[PTNetworkMonitor alloc] init]; });
    return shareInstance;
}

- (instancetype)init
{
    if ((self = [super init])) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(netWorkChanged:)
                                                     name:AFNetworkingReachabilityDidChangeNotification
                                                   object:nil];
        _netStatus = AFNetworkReachabilityStatusUnknown-1;
        AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
        [reachManager startMonitoring];
        [reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            self.netStatus = status;
        }];
        
    }
    return self;
}


- (void)notifyNetWorkFailed
{
    [[PTNotificationCenter defaultCenter] notifyNetWorkFailed];
}

- (void)netWorkChanged:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    AFNetworkReachabilityStatus status = [userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
}

- (void)setNetStatus:(AFNetworkReachabilityStatus)netStatus
{
    @synchronized(self)
    {
    if (_netStatus == netStatus) {
        return;
    }
    _netStatus = netStatus;
    
    if (_netStatus < AFNetworkReachabilityStatusNotReachable) {
        [[PTNotificationCenter defaultCenter] notifyNetWorkFailed];
    } else if (_netStatus > AFNetworkReachabilityStatusNotReachable) {
        [[PTNotificationCenter defaultCenter] notifyNetWorkSuccess];
    } else {
        [[PTNotificationCenter defaultCenter] notifyNetWorkFailed];
    }
    }
    
    
}

- (AFNetworkReachabilityStatus)getNetWorkStatus {
    return _netStatus;
}

- (BOOL)isReachable
{
    return _netStatus > AFNetworkReachabilityStatusNotReachable;
}

// wifi  暂时已 QQ服务器 为准
- (BOOL)isReachableWIFI
{
    return _netStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

// 2 3 4G
- (BOOL)isReachableWWAN
{
    return _netStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}


@end
