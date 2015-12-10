//
//  PTCameraView.m
//  PTKit
//
//  Created by LeeHu on 15/2/9.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTCameraView.h"
#import <AVFoundation/AVFoundation.h>

#define previewFrame (CGRect){ 0, 65, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 138 }

@interface PTCameraView ()

@property (nonatomic, strong) UIView *topContainerBar;
@property (nonatomic, strong) UIView *bottomContainerBar;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinch;

@end

@implementation PTCameraView

+ (instancetype)initWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame captureSession:nil];
}

+ (PTCameraView *)initWithCaptureSession:(AVCaptureSession *)captureSession
{
    return [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds] captureSession:captureSession];
}

- (instancetype)initWithFrame:(CGRect)frame captureSession:(AVCaptureSession *)captureSession
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor blackColor];
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
        
        if (captureSession) {
            [_previewLayer setSession:captureSession];
            _previewLayer.frame = previewFrame;
        } else {
            _previewLayer.frame = self.bounds;
        }
        
        if ([_previewLayer respondsToSelector:@selector(connection)]) {
            if ([_previewLayer.connection isVideoOrientationSupported]) {
                [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            }
        }
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

        [self.layer addSublayer:_previewLayer];
        
    }
    return self;
}

#pragma mark - create View
- (UIView *) topContainerBar
{
    if ( !_topContainerBar ) {
        _topContainerBar = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, CGRectGetWidth(self.bounds), CGRectGetMinY(previewFrame) }];
        [_topContainerBar setBackgroundColor:[UIColor blackColor]];
    }
    return _topContainerBar;
}

- (UIView *) bottomContainerBar
{
    if ( !_bottomContainerBar ) {
        CGFloat newY = CGRectGetMaxY(previewFrame);
        _bottomContainerBar = [[UIView alloc] initWithFrame:(CGRect){ 0, newY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - newY }];
        [_bottomContainerBar setUserInteractionEnabled:YES];
        [_bottomContainerBar setBackgroundColor:[UIColor blackColor]];
    }
    return _bottomContainerBar;
}

#pragma mark - button

- (UIButton *) photoLibraryButton
{
    if ( !_photoLibraryButton ) {
        _photoLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoLibraryButton setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.1]];
        [_photoLibraryButton.layer setCornerRadius:4];
        [_photoLibraryButton.layer setBorderWidth:1];
        [_photoLibraryButton.layer setBorderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.3].CGColor];
        [_photoLibraryButton setFrame:(CGRect){ CGRectGetWidth(self.bounds) - 59, CGRectGetMidY(self.bottomContainerBar.bounds) - 22, 44, 44 }];
        [_photoLibraryButton addTarget:self action:@selector(libraryAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _photoLibraryButton;
}

- (UIButton *) triggerButton
{
    if ( !_triggerButton ) {
        _triggerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_triggerButton setBackgroundColor:self.tintColor];
        [_triggerButton setImage:[UIImage imageNamed:@"trigger"] forState:UIControlStateNormal];
        [_triggerButton setFrame:(CGRect){ 0, 0, 66, 66 }];
        [_triggerButton.layer setCornerRadius:33.0f];
        [_triggerButton setCenter:(CGPoint){ CGRectGetMidX(self.bottomContainerBar.bounds), CGRectGetMidY(self.bottomContainerBar.bounds) }];
        [_triggerButton addTarget:self action:@selector(triggerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _triggerButton;
}

- (UIButton *) closeButton
{
    if ( !_closeButton ) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton setFrame:(CGRect){ 25,  CGRectGetMidY(self.bottomContainerBar.bounds) - 15, 30, 30 }];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (UIButton *) cameraPositionButton
{
    if ( !_cameraPositionButton ) {
        _cameraPositionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraPositionButton setBackgroundColor:[UIColor clearColor]];
        [_cameraPositionButton setImage:[UIImage imageNamed:@"flip"] forState:UIControlStateNormal];
        [_cameraPositionButton setImage:[UIImage imageNamed:@"flip"] forState:UIControlStateSelected];
        [_cameraPositionButton setFrame:(CGRect){ 25, 17.5f, 30, 30 }];
        [_cameraPositionButton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cameraPositionButton;
}

- (UIButton *) flashButton
{
    if ( !_flashButton ) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton setBackgroundColor:[UIColor clearColor]];
        [_flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateSelected];
        [_flashButton setFrame:(CGRect){ CGRectGetWidth(self.bounds) - 55, 17.5f, 30, 30 }];
        [_flashButton addTarget:self action:@selector(flashTriggerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _flashButton;
}





@end
