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
#import "Aspects.h"
#import "PTNavigationController.h"
#import "PTUIKitCategoryViewController.h"
#import "PTModuleCollectionViewController.h"
#import "PTSplashView.h"
#import "PTWindowStack.h"

@interface AppDelegate ()<BMKGeneralDelegate>

@property (nonatomic, strong) BMKMapManager *baiduMapManager;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
	
    return YES;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    PTDebugListViewController *vc = [[PTDebugListViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	vc.title = @"Demo1";

	NSMutableArray *images = [[NSMutableArray alloc] init];
	[images addObject:@"demos"];
	NSArray *imageGroup = [NSArray arrayWithArray:images];
	
	PTUIKitCategoryViewController *vc2 = [[PTUIKitCategoryViewController alloc] initWithNibName:nil bundle:nil];
	vc2.title = @"Demo2";
	PTNavigationController *nav2 = [[PTNavigationController alloc] initWithRootViewController:vc2];
	
	UITabBarController *tabController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
	tabController.viewControllers = @[nav, nav2],
	tabController.selectedIndex = 0;
	
	
	self.window.rootViewController = tabController;
	[self configrationApiInfo];
	[self.window makeKeyAndVisible];
	[PTWindowStack pushWindow:self.window];
	[PTSplashView showInWindow:self.window];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

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
