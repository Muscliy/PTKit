//
//  AppDelegate.m
//  PTKit
//
//  Created by LeeHu on 14/11/24.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "AppDelegate.h"
#import "PTDebugListViewController.h"
#import "PTNavigationController.h"
#import "PTNavigationBar.h"
#import <BaiduMapAPI/BMapKit.h>


@interface AppDelegate ()<BMKGeneralDelegate>

@property (nonatomic, strong) BMKMapManager *baiduMapManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PTDebugListViewController *vc = [[PTDebugListViewController alloc] initWithNibName:nil bundle:nil];
    PTNavigationController *nav = [[PTNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self configrationApiInfo];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)configrationApiInfo
{
    _baiduMapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_baiduMapManager start:@"89WVu7Bn6pVitioygTFudGgB" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)onGetPermissionState:(int)iError
{

}

- (void)onGetNetworkState:(int)iError
{

}

@end
