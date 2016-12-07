//
//  LocalUserInfo.m
//  PTKit
//
//  Created by LeeHu on 6/21/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "LocalUserInfo.h"
#import "PTAssert.h"

static NSString *gLoginedUID = nil;
static NSString *gLoginedSessionId = nil;
static NSString *gLoginName = nil;
static NSString *gLoginPhone = nil;

NSString *getCurrentUser()
{
	@synchronized([LocalUserInfo class])
	{
	if (gLoginedUID) {
		return gLoginedUID;
	}
	NSString *loginedUID = [LocalUserInfo getLastLoginedUserId];
	gLoginedUID = loginedUID;
	return gLoginedUID;
	}
}

NSString *getCurrentName()
{
	@synchronized([LocalUserInfo class])
	{
	if (gLoginName) {
		return gLoginName;
	}
	NSString *loginedName = [LocalUserInfo getUserName];
	gLoginName = loginedName;
	return gLoginName;
	}
}

NSString *getCurrentSessionId()
{
	@synchronized([LocalUserInfo class])
	{
	if (gLoginedSessionId && gLoginedUID) {
		return gLoginedSessionId;
	}
	
	NSString *loginedSessionId = [LocalUserInfo getLastLoginInfo].sessionId;
	PTASSERT(!loginedSessionId || [loginedSessionId isKindOfClass:[NSString class]]);
	gLoginedSessionId = loginedSessionId;
	
	return gLoginedSessionId;
	}
}


@implementation LoginInfo

@end

@implementation LocalUserInfo

+ (BOOL)hasUserLogined
{
	return [getCurrentUser() length] > 1 && [getCurrentSessionId() length] > 1;
}

+ (void)logoutCurrentUser
{
	@synchronized([LocalUserInfo class])
	{
	NSLog(@"logoutCurrentUser");
	NSString *uid = [LocalUserInfo getLastLoginUserId];
	
	if (uid == nil || [uid length] < 2) {
		return;
	}
	
	NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
	
	NSString *key = [NSString stringWithFormat:@"us_%@_logined", uid];
	[userData setBool:FALSE forKey:key];
	
	key = [NSString stringWithFormat:@"us_%@_sessionId", uid];
	[userData setValue:nil forKey:key];
	
	key = [NSString stringWithFormat:@"us_%@_register_time", uid];
	[userData setValue:nil forKey:key];
	
	key = [NSString stringWithFormat:@"us_last_login_uid"];
	[userData setValue:nil forKey:key];
	
	[userData synchronize];
	
	gLoginedUID = nil;
	gLoginName = nil;
	gLoginedSessionId = nil;
	gLoginPhone = nil;
	}
}

+ (NSString *)getLastLoginUserId
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"us_last_login_uid"];
}

+ (NSString *)getLastLoginedUserId
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *uid = [userDefault stringForKey:@"us_last_login_uid"];
	if (!uid) {
		return nil;
	}
	NSString *key = [NSString stringWithFormat:@"us_%@_sessionId", uid];
	NSString *session = [userDefault stringForKey:key];
	if (session)
		return uid;
	return nil;
}

+ (NSString *)getUserName
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *uid = [userDefault stringForKey:@"us_last_login_uid"];
	if (!uid) {
		return nil;
	}
	NSString *key = [NSString stringWithFormat:@"us_%@_name", uid];
	return [userDefault objectForKey:key];
}

+ (NSString *)getUserPhone
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *uid = [userDefault stringForKey:@"us_last_login_uid"];
	if (!uid) {
		return nil;
	}
	NSString *key = [NSString stringWithFormat:@"us_%@_phone", uid];
	return [userDefault objectForKey:key];
}

+ (NSString *)getFormerUserPhone
{
	NSString *formerPhoneKey = [NSString stringWithFormat:@"us_former_phone"];
	return [[NSUserDefaults standardUserDefaults] objectForKey:formerPhoneKey];
}

+ (long long)getUserRegisterTime
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *uid = [userDefault stringForKey:@"us_last_login_uid"];
	if (!uid) {
		return 0;
	}
	
	NSString *key = [NSString stringWithFormat:@"us_%@_register_time", uid];
	return [[userDefault objectForKey:key] longLongValue];
}

+ (NSUInteger)getUserGender
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *uid = [userDefault stringForKey:@"us_last_login_uid"];
	if (!uid) {
		return 0;
	}
	
	NSString *key = [NSString stringWithFormat:@"us_%@_gender", uid];
	return [[userDefault objectForKey:key] integerValue];
}

+ (void)setUserName:(NSString *)name
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *uid = [userDefault stringForKey:@"us_last_login_uid"];
	if (!uid) {
		return;
	}
	NSString *key = [NSString stringWithFormat:@"us_%@_name", uid];
	[userDefault setObject:name forKey:key];
	[userDefault synchronize];
	gLoginName = name;
}

+ (void)setUserPhone:(NSString *)phone
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *uid = [userDefault stringForKey:@"us_last_login_uid"];
	if (!uid) {
		return;
	}
	NSString *key = [NSString stringWithFormat:@"us_%@_phone", uid];
	[userDefault setObject:phone forKey:key];
	[userDefault synchronize];
	gLoginPhone = phone;
}

+ (void)setUserGender:(NSUInteger)gender
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *uid = [userDefault stringForKey:@"us_last_login_uid"];
	if (!uid) {
		return;
	}
	NSString *key = [NSString stringWithFormat:@"us_%@_gender", uid];
	[userDefault setObject:@(gender) forKey:key];
	[userDefault synchronize];
}

+ (LoginInfo *)getLastLoginInfo
{
	return [LocalUserInfo getLoginInfo:[LocalUserInfo getLastLoginUserId] loginWay:0];
}

+ (void)saveSessionId:(NSString *)sessionId
{
	NSString *uid = getCurrentUser();
	if (!uid)
		return;
	if (sessionId) {
		PTASSERT([sessionId isKindOfClass:[NSString class]]);
	}
	NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
	NSString *key = [NSString stringWithFormat:@"us_%@_sessionId", uid];
	[userData setValue:sessionId forKey:key];
	[userData synchronize];
	
	gLoginedSessionId = sessionId;
}

+ (LoginInfo *)getLoginInfo:(NSString *)uid loginWay:(NSInteger)loginWay
{
	LoginInfo *loginInfo = [[LoginInfo alloc] init];
	
	if (!uid)
		return loginInfo;
	
	loginInfo.uid = uid;
	
	NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
	NSString *key = [NSString stringWithFormat:@"us_%@_sessionId", uid];
	loginInfo.sessionId = [userData stringForKey:key];
	
	key = [NSString stringWithFormat:@"us_%@_%zd_loginTime", uid, loginWay];
	NSNumber *time = (NSNumber *)[userData objectForKey:key]; // error
	loginInfo.lastLoginTime = [time longLongValue];
	
	NSString *nameKey = [NSString stringWithFormat:@"us_%@_name", uid];
	loginInfo.name = [userData objectForKey:nameKey];
	
	NSString *phoneKey = [NSString stringWithFormat:@"us_%@_phone", uid];
	loginInfo.phone = [userData objectForKey:phoneKey];
	
	NSString *createTimeKey = [NSString stringWithFormat:@"us_%@_register_time", uid];
	loginInfo.registerTime = [[userData objectForKey:createTimeKey] longLongValue];
	
	NSString *genderKey = [NSString stringWithFormat:@"us_%@_gender", uid];
	loginInfo.gender = [[userData objectForKey:genderKey] integerValue];
	return loginInfo;
}

+ (void)setLoginInfo:(LoginInfo *)info logined:(BOOL)logined
{
	@synchronized([LocalUserInfo class])
	{
	NSLog(@"start setLoginInfo");
	NSString *uid = info.uid;
	
	NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
	
	NSString *key = [NSString stringWithFormat:@"us_%@_logined", uid];
	[userData setBool:logined forKey:key];
	NSString *nameKey = [NSString stringWithFormat:@"us_%@_name", uid];
	[userData setObject:info.name forKey:nameKey];
	
	NSString *phoneKey = [NSString stringWithFormat:@"us_%@_phone", uid];
	NSString *formerPhoneKey = [NSString stringWithFormat:@"us_former_phone"];
	[userData setObject:info.phone forKey:phoneKey];
	[userData setObject:info.phone forKey:formerPhoneKey];
	
	NSNumber *number = [NSNumber numberWithLongLong:info.lastLoginTime];
	key = [NSString stringWithFormat:@"us_%@_loginTime", uid];
	[userData setObject:number forKey:key];
	
	key = [NSString stringWithFormat:@"us_%@_sessionId", uid];
	[userData setValue:info.sessionId forKey:key];
	
	key = [NSString stringWithFormat:@"us_%@_register_time", uid];
	[userData setValue:[NSNumber numberWithLongLong:info.registerTime] forKey:key];
	
	key = [NSString stringWithFormat:@"us_%@_gender", uid];
	[userData setValue:[NSNumber numberWithInteger:info.gender] forKey:key];
	if (info.sessionId) {
		PTASSERT([info.sessionId isKindOfClass:[NSString class]]);
	}
	
	if (logined) {
		[userData setValue:info.uid forKey:@"us_last_login_uid"];
	}
	
	[userData synchronize];
	
	NSLog(@"setLoginInfo success");
	gLoginedUID = nil;
	gLoginedSessionId = nil;
	
	if (logined) {
		dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
		dispatch_after(when, dispatch_get_main_queue(), ^{
//			[XMAPNSUtils registerAPNS];
//			[[KissIMClient singleton] createClient:uid];
		});
	}
	}
}


@end
