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
#import "ServerConfig.h"
#import "ServerConfigSyncer.h"
#import "PTPushHandler.h"

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
	[self launchDealServerConfig];
    PTDebugListViewController *vc = [[PTDebugListViewController alloc] initWithNibName:nil bundle:nil];
    PTNavigationController *nav = [[PTNavigationController alloc] initWithRootViewController:vc];
	vc.title = @"Demo1";

	NSMutableArray *images = [[NSMutableArray alloc] init];
	[images addObject:@"demos"];
	
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
    [self modifyUserAgent];
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

- (void)launchDealServerConfig{
	
#if defined(DEBUG)
	NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
	NSString *serverKey = [userData valueForKey:@"_debug_server_key"];
	if (serverKey.length < 1 || ![ServerConfig getAllServerTypeKey]) {
		serverKey = @"dev";
		[userData setObject:serverKey forKey:@"_debug_server_key"];
		[userData synchronize];
	}
	[ServerConfig setServerTypeKey:serverKey];
#else
	[ServerConfig setServerTypeKey:@"product"];
#endif
	NSLog(@"%@",[[ServerConfig getUrls:CONSTANTS_DEFAULT_CATEGORY] firstObject]);
	
	[[ServerConfigSyncer singleton] start];
}


- (void)modifyUserAgent {
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *ua = [NSString stringWithFormat:@"%@ %@",
                    userAgent,
                    @"MicroMessenger/1.0"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}

@end
