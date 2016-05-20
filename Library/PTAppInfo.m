//
//  PTAppInfo.m
//  PTKit
//
//  Created by LeeHu on 12/17/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTAppInfo.h"

@implementation PTAppInfo

+ (BOOL) isFirstLaunchInPhone
{
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
	} else{
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
	}
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
}

@end
