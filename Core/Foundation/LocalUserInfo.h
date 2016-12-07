//
//  LocalUserInfo.h
//  PTKit
//
//  Created by LeeHu on 6/21/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *getCurrentUser();
NSString *getCurrentSessionId();
NSString *getCurrentName();

@interface LoginInfo : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) NSUInteger gender;
@property (nonatomic, assign) long long lastLoginTime;
@property (nonatomic, assign) long long registerTime;

@end

@interface LocalUserInfo : NSObject

+ (BOOL)hasUserLogined;
+ (void)logoutCurrentUser;
+ (NSString *)getFormerUserPhone;
+ (NSString *)getLastLoginUserId;
+ (NSString *)getLastLoginedUserId;
+ (NSString *)getUserName;
+ (NSString *)getUserPhone;
+ (NSUInteger)getUserGender;
+ (long long)getUserRegisterTime;
+ (void)setUserGender:(NSUInteger)gender;
+ (void)setUserName:(NSString *)name;
+ (void)setUserPhone:(NSString *)phone;
+ (LoginInfo *)getLastLoginInfo;
+ (void)saveSessionId:(NSString *)sessionId;
+ (LoginInfo *)getLoginInfo:(NSString *)uid loginWay:(NSInteger)loginWay;
+ (void)setLoginInfo:(LoginInfo *)info logined:(BOOL)logined;

@end
