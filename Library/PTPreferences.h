//
//  PTPreferences.h
//  PTKit
//
//  Created by LeeHu on 12/1/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const PTPreferencesDidChangeNotification;
extern NSString *const PTPreferencesChangedPropertyKey;

@interface PTPreferences : NSObject
{
	NSDictionary *_properties;
}

@property (nonatomic, assign) BOOL shouldAutomaticallySynchronize;

+ (NSString *)defaultsKeyForPropertyName:(NSString *)key;
+ (instancetype)sharedInstance;

- (BOOL)sychronize;
- (NSUserDefaults *)userDefaults;

@end
