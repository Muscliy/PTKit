//
//  PTCameraView.h
//  PTKit
//
//  Created by LeeHu on 15/2/9.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PTCameraView : UIView

//进入相册button
@property (nonatomic, strong) UIButton *photoLibraryButton;

//拍照button
@property (nonatomic, strong) UIButton *triggerButton;

//退出button
@property (nonatomic, strong) UIButton *closeButton;

//切换摄像头button
@property (nonatomic, strong) UIButton *cameraPositionButton;

//闪光灯button
@property (nonatomic, strong) UIButton *flashButton;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

+ (instancetype)initWithFrame:(CGRect)frame;

@end
