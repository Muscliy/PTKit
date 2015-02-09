//
//  PTQRCodeReaderOverlayView.h
//  PTKit
//
//  Created by LeeHu on 15/2/7.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTQRCodeReaderOverlayView : UIView
{
    UIView *tipView;
    UILabel *analyLabel;
    UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic, assign) BOOL isCameraAvailable;
@property (nonatomic, strong) UIImageView *scanLine;

- (void)beginAnimation;
- (void)stopAnimation;
- (void)addAnalyingView;
- (void)removeAnalyingView;

@end

@interface PTQRCodeReaderOverlayer : CALayer

@end

