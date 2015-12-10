//
//  PTPrefsRouter.h
//  PTKit
//
//  Created by LeeHu on 12/9/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, PrefsType) {
	PrefsPhotos = 0,
	PrefsSounds,
	PrefsNetwork,
	PrefsLocationServices,
	PrefsGeneral,
	PrefsWiFi,
	PrefsNotification,
};

@interface PTPrefsRouter : NSObject

+ (void)openPrefs:(PrefsType)type;

@end
