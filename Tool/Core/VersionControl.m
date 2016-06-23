//
//  VersionControl.m
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "VersionControl.h"
#import "PTLogger.h"

@implementation VersionControl

+ (NSString *)appVersion
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)appBuildVersion
{
	static NSString *buildVersion = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		buildVersion =
		[self filterUnSafeString:[[NSBundle mainBundle]
								  objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
		NSString *channelId = [self appChannelId];
		if (channelId.length > 0) {
			buildVersion = [NSString stringWithFormat:@"%@ %@", buildVersion, channelId];
		}
	});
	
	return buildVersion;
}


+ (NSString *)appChannelId
{
	static NSString *channelId = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString *channelPath =
		[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"xmchannelId"];
		channelId =
		[NSString stringWithContentsOfFile:channelPath encoding:NSUTF8StringEncoding error:nil];
		
		if (channelId == nil) {
			channelId = @"";
		} else {
			channelId = [self filterUnSafeString:channelId];
		}
	});
	
	return channelId;
}

+ (NSString *)filterUnSafeString:(NSString *)str
{
	NSMutableString *modifyStr = [@"" mutableCopy];
	for (NSInteger i = 0; i < str.length; i++) {
		unichar c = [str characterAtIndex:i];
		if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') ||
			c == ' ' || c == '.' || c == '_') {
			[modifyStr appendFormat:@"%c", c];
		} else if (c == '\r' || c == '\n') {
			continue;
		} else {
			PTLogError(@"渠道id含有非法字符");
			continue;
		}
	}
	return [NSString stringWithString:modifyStr];
}

static NSInteger g_intVersion = -1;
+ (NSInteger)appVersionInt
{
	if (g_intVersion >= 0)
		return g_intVersion;
	NSString *str = [VersionControl appBuildVersion];
	NSUInteger len = [str length];
	NSInteger count = 0;
	for (NSInteger i = 0; i < len; i++) {
		unichar c = [str characterAtIndex:i];
		if (c != '.')
			continue;
		count++;
		if (count == 3) {
			NSString *tmp = [str substringFromIndex:(i + 1)];
			g_intVersion = [tmp intValue];
			break;
		}
	}
	
	if (g_intVersion < 0)
		g_intVersion = 0;
	return g_intVersion;
}

+ (long long)convertVersionToInt:(NSString *)str
{
	long long version = 0;
	NSArray *c = [str componentsSeparatedByString:@"."];
	NSInteger count = [c count];
	for (NSInteger i = 0; i < [c count]; i++) {
		count--;
		version += [[c objectAtIndex:i] integerValue] * pow(1000, count);
	}
	
	return version;
}

+ (NSString *)getServerVersion
{
	return [[NSUserDefaults standardUserDefaults] valueForKey:@"version_str"];
}

@end
