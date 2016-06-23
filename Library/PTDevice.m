//
//  PTDevice.m
//  xmLife
//
//  Created by LeeHu on 14/11/19.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTDevice.h"
#import "UICKeyChainStore.h"

#define DEVICE_TOKEN_STRING @"PTDeviceTokenStr"

@interface PTDevice ()


@end

@implementation PTDevice

+ (PTDevice *)deviceInfo
{
	static PTDevice *_shared;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_shared = [self new];
	});
	
	return _shared;
}

- (BOOL)isPhone
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

- (BOOL)isPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (NSString *) uniqueAppIdentifier{
	return [self uniqueGlobalDeviceIdentifier];
}

- (NSString *) uniqueGlobalDeviceIdentifier {
	NSString *storeDeviceId = [UICKeyChainStore stringForKey:@"PTCommonDeviceId"];
	if ([storeDeviceId length]) {
		return storeDeviceId;
	}
	
	CFUUIDRef udid = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, udid);
	storeDeviceId = [(__bridge NSString*)string stringByReplacingOccurrencesOfString:@"-" withString:@""];
	CFRelease(string);
	CFRelease(udid);
	[UICKeyChainStore setString:storeDeviceId forKey:@"PTCommonDeviceId"];
	return storeDeviceId;
}

- (NSString *)getDeviceToken
{
	NSString *aDeviceToken =
	[[NSUserDefaults standardUserDefaults] stringForKey:DEVICE_TOKEN_STRING];
	
	if (aDeviceToken == nil || [aDeviceToken length] <= 0) {
		return nil;
	}
	return aDeviceToken;
}

- (void)saveDeviceToken:(NSData *)token
{
	NSString *deviceToken = [[token description]
        stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
	[[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:DEVICE_TOKEN_STRING];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
