//
//  PTMediaDeviceAuthorize.m
//  PTKit
//
//  Created by LeeHu on 15/2/7.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTMediaDeviceAuthorize.h"
#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AVCaptureDevice (ExtendIOS7)
+ (NSInteger)authorizationStatusForMediaType:(NSString *)mediaType;
+ (void)requestAccessForMediaType:(NSString *)mediaType
                completionHandler:(void (^)(BOOL granted))handler;
@end

@interface AVAudioSession (ExtendIOS7)
+ (void)requestRecordPermission:(void (^)(BOOL granted))handler;
@end

@implementation PTMediaDeviceAuthorize

+ (void)isMediaDeviceAvailable:(PTMediaDeviceType)type
             completionHandler:(void (^)(BOOL granted))handler
{
    [PTMediaDeviceAuthorize isMediaDeviceAvailable:type
                       shouldRequestAccessForMedia:NO
                                 completionHandler:handler];
}

+ (void)isMediaDeviceAvailable:(PTMediaDeviceType)type
    shouldRequestAccessForMedia:(BOOL)bRequest
              completionHandler:(void (^)(BOOL granted))handler
{
    switch (type) {
    case PTMediaDeviceCamera:
        [PTMediaDeviceAuthorize isCameraAvailable:handler shouldRequestAccessForMedia:bRequest];
        break;

    case PTMediaDeviceAlbum:
        [PTMediaDeviceAuthorize isAlbumAvailable:handler];
        break;

    case PTMediaDeviceMicroPhone:
        [PTMediaDeviceAuthorize isMicroPhoneAvailable:handler shouldRequestAccessForMedia:bRequest];
        break;

    case PTMediaDeviceLocation:
        [PTMediaDeviceAuthorize isLocationAvailable:handler];
        break;

    default:
        break;
    }
}

+ (void)isCameraAvailable:(void (^)(BOOL granted))handler shouldRequestAccessForMedia:(BOOL)bRequest
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self deviceHasMediaPrivilege:AVMediaTypeVideo
            shouldRequestAccessForMedia:
                bRequest completion:^(NSInteger authorizationStatus, BOOL granted) {
                    if (authorizationStatus != 0 && granted == NO) {
                        [PTMediaDeviceAuthorize
                            showMediaAuthorizedAlert:NSLocalizedString(@"无法使用相机", @"")
                                             content:NSLocalizedString(
                                                         @"请在iPhone的\"设置-隐私-"
                                                         @"相机\"中允许访问相机。",
                                                         @"")];
                    }
                    handler(granted);
                }];
    } else {
        [PTMediaDeviceAuthorize
            showMediaAuthorizedAlert:NSLocalizedString(@"无法使用相机", @"")
                             content:NSLocalizedString(
                                         @"请在iPhone的\"设置-通用-"
                                         @"访问限制-相机\"中允许访问相机。",
                                         @"")];
        handler(NO);
    }
}

+ (void)isAlbumAvailable:(void (^)(BOOL granted))handler
{
    if ([UIImagePickerController
            isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO ||
        ([[ALAssetsLibrary self] respondsToSelector:@selector(authorizationStatus)] &&
         [ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusAuthorized)) {
        [PTMediaDeviceAuthorize
            showMediaAuthorizedAlert:NSLocalizedString(@"无法访问相册", @"")
                             content:NSLocalizedString(@"请在iPhone的“设置-隐私-"
                                                       @"照片”中允许访问你的照片。",
                                                       @"")];

        handler(NO);
    } else {
        handler(YES);
    }
}

+ (void)isMicroPhoneAvailable:(void (^)(BOOL granted))handler
    shouldRequestAccessForMedia:(BOOL)bRequest
{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^() {
                if (granted == NO) {
                    [PTMediaDeviceAuthorize
                        showMediaAuthorizedAlert:NSLocalizedString(@"麦克风被禁用", @"")
                                         content:
                                             NSLocalizedString(
                                                 @"请在iPhone的\"设置-隐私-"
                                                 @"麦克风\"中允许访问你的麦克风。",
                                                 @"")];
                }

                handler(granted);
            });
        }];
    } else {
        handler(YES);
    }
}

+ (void)isLocationAvailable:(void (^)(BOOL granted))handler
{
    handler(YES);
}

#pragma mark -

+ (void)deviceHasMediaPrivilege:(NSString *)mediaType
    shouldRequestAccessForMedia:(BOOL)bRequest
                     completion:(void (^)(NSInteger authorizationStatus, BOOL granted))completion
{
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_0) {
        completion(3, YES);
        return;
    }

    NSInteger status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (status == 3) {
        completion(status, YES);
    } else if (status == 1 || status == 2) {
        completion(status, NO);
        return;
    } else if (status == 0) {
        if (bRequest == YES) {
            [AVCaptureDevice requestAccessForMediaType:mediaType
                                     completionHandler:^(BOOL granted) {
                                         dispatch_async(dispatch_get_main_queue(),
                                                        ^() { completion(status, granted); });
                                     }];
        } else {
            completion(status, YES);
        }
    }
}

+ (void)showMediaAuthorizedAlert:(NSString *)title content:(NSString *)content
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:content
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)showMicPhoneAccessFailed
{
    UIAlertView *alert = [[UIAlertView alloc]
            initWithTitle:NSLocalizedString(@"麦克风被禁用", @"")
                  message:NSLocalizedString(@"请在iPhone的\"设置-隐私-"
                                            @"麦克风\"中允许访问你的麦克风。",
                                            @"")
                 delegate:nil
        cancelButtonTitle:NSLocalizedString(@"确定", @"")
        otherButtonTitles:nil];
    [alert show];
}


@end
