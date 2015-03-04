//
//  UIDevice+Extents.m
//  PTKit
//
//  Created by LeeHu on 15/2/11.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "UIDevice+Extents.h"
#import <sys/sysctl.h>

#define DEVICE_TOKEN_STRING @"CCDeviceTokenStr"

@implementation UIDevice (Extents)

+ (NSString *)getDeviceUserName
{
    NSString *name = [[UIDevice currentDevice] name];
    if (name.length < 2)
        return nil;
    NSUInteger pos = [name rangeOfString:@"的"].location;
    if (pos != NSNotFound) {
        return [name substringToIndex:pos];
    }
    NSUInteger len = name.length;
    NSMutableString *userName = [@"" mutableCopy];
    for (NSInteger i = 0; i < len; i++) {
        unichar c = [name characterAtIndex:i];
        if (c == 8220) // “
            continue;
        if (c == 8221 || c == 39) //” '
            break;
        if (c == 8217)
            break;
        [userName appendFormat:@"%C", c];
    }
    if (userName.length > 1) {
        NSArray *ignores = @[ @"iPhone", @"iPad", @"iPod" ];
        for (NSString *ignore in ignores) {
            pos = [userName rangeOfString:ignore].location;
            if (pos != NSNotFound)
                return nil;
        }
        return userName;
    }
    return nil;
}

+ (NSString *)getDeviceToken
{
    NSString *aDeviceToken =
    [[NSUserDefaults standardUserDefaults] stringForKey:DEVICE_TOKEN_STRING];
    
    if (aDeviceToken == nil || [aDeviceToken length] <= 0) {
        return nil;
    }
    return aDeviceToken;
}

+ (void)saveDeviceToken:(NSData *)token
{
    NSString *deviceToken = [[token description]
                             stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:DEVICE_TOKEN_STRING];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (DeviceType)deviceVersion
{
    DeviceType currentVersion = Device_iPhoneNone;
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform;
    if (machine == NULL) {
        platform = @"i386";
    } else {
        platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    }
    free(machine);
    
    if ([platform hasPrefix:@"iPhone"]) {
        if ([platform isEqualToString:@"iPhone1,1"]) {
            currentVersion = Device_iPhone1G;
        } else if ([platform isEqualToString:@"iPhone1,2"]) {
            currentVersion = Device_iPhone3G;
        } else if ([platform isEqualToString:@"iPhone2,1"]) {
            currentVersion = Device_iPhone3GS;
        } else if ([platform rangeOfString:@"iPhone3,"].length > 0) {
            currentVersion = Device_iPhone4;
        } else if ([platform rangeOfString:@"iPhone4,"].length > 0) {
            currentVersion = Device_iPhone4S;
        } else {
            currentVersion = Device_iPhoneLater;
        }
    } else if ([platform hasPrefix:@"iPod"]) {
        if ([platform isEqualToString:@"iPod1,1"]) {
            currentVersion = Device_iPodTouch1G;
        } else if ([platform isEqualToString:@"iPod2,1"]) {
            currentVersion = Device_iPodTouch2G;
        } else if ([platform isEqualToString:@"iPod3,1"]) {
            currentVersion = Device_iPodTouch3G;
        } else if ([platform isEqualToString:@"iPod4,1"]) {
            currentVersion = Device_iPodTouch4G;
        } else {
            currentVersion = Device_iPodTouch4G;
        }
    } else if ([platform hasPrefix:@"iPad"]) {
        if ([platform isEqualToString:@"iPad1,1"]) {
            currentVersion = Device_iPad1;
        } else if ([platform isEqualToString:@"iPad2,1"]) {
            currentVersion = Device_iPad2;
        } else if ([platform isEqualToString:@"iPad2,2"]) {
            currentVersion = Device_iPad2;
        } else if ([platform hasPrefix:@"iPad3"]) {
            currentVersion = Device_iPad3;
        } else {
            currentVersion = Device_iPad2;
        }
    } else if ([platform isEqualToString:@"i386"]) {
        currentVersion = Device_iPhoneSimulator;
    } else if ([platform isEqualToString:@"x86_64"]) { // add by matthew
        currentVersion = Device_iPhoneSimulator;
    }
    
    return currentVersion;
}

@end
