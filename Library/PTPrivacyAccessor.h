//
//  PTPrivacyAccessor.h
//  xmLife
//
//  Created by LeeHu on 11/7/15.
//  Copyright © 2015 PaiTao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kPermissionTypeLocation,
	kPermissionTypeContacts,
	kPermissionTypeCalendar,
	kPermissionTypeReminders,
	kPermissionTypePhotos,
	kPermissionTypeBluetoothLE,
	kPermissionTypeMicrophone,
	kPermissionTypeCamera,
	kPermissionTypeHealth,
	kPermissionTypeHomeKit,
	kPermissionTypeMotion,
} kPermissionType;

typedef enum {
	kPermissionAccessDenied, //User has rejected feature
	kPermissionAccessGranted, //User has accepted feature
	kPermissionAccessRestricted, //Blocked by parental controls or system settings
	kPermissionAccessUnknown, //Cannot be determined
	kPermissionAccessUnsupported, //Device doesn't support this - e.g Core Bluetooth
	kPermissionAccessMissingFramework, //Developer didn't import the required framework to the project
} kPermissionAccess;

@interface PTPrivacyAccessor : NSObject<UIAppearance, UIAppearanceContainer>

@property (nonatomic, assign) BOOL showAlertView UI_APPEARANCE_SELECTOR;


//Check permission of service. Cannot check microphone or motion without asking user for permission
-(kPermissionAccess)hasAccessToLocation;
-(kPermissionAccess)hasAccessToContacts;
-(kPermissionAccess)hasAccessToCalendar;
-(kPermissionAccess)hasAccessToReminders;
-(kPermissionAccess)hasAccessToPhotos;
-(kPermissionAccess)hasAccessToBluetoothLE;

//Request permission with callback
-(void)requestAccessToCalendarWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;
-(void)requestAccessToContactsWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;
-(void)requestAccessToMicrophoneWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;
-(void)requestAccessToPhotosWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;
-(void)requestAccessToRemindersWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;

//Instance methods
-(void)requestAccessToLocationWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied;

//No failure callback available
-(void)requestAccessToMotionWithSuccess:(void(^)())accessGranted;

@end
