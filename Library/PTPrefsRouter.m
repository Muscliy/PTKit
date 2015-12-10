//
//  PTPrefsRouter.m
//  PTKit
//
//  Created by LeeHu on 12/9/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTPrefsRouter.h"

@implementation PTPrefsRouter

+ (void)openPrefs:(PrefsType)type
{
    NSURL *url = [NSURL URLWithString:[[self class] prefsMapingString:type]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (NSString *)prefsMapingString:(PrefsType)type
{
    NSDictionary *map = @{
        @"Photos" : @(PrefsPhotos),
        @"Sounds" : @(PrefsSounds),
        @"General&path=Network" : @(PrefsNetwork),
        @"LOCATION_SERVICES" : @(PrefsLocationServices),
        @"General" : @(PrefsGeneral),
        @"WIFI" : @(PrefsWiFi),
        @"NOTIFICATIONS_ID" : @(PrefsNotification)
    };
    NSString *str = [NSString stringWithFormat:@"prefs:root=%@", [map objectForKey:@(type)]];
    return str;
}

@end
